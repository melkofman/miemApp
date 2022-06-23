//
//  ChildViewController.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 15.11.2020.
//

import UIKit

protocol ScrollOffsetProviding {
  var scrollOffset: CGPoint { get }
}

class BottomSheetViewController: UIViewController {
  private let placeholderView = UIView()
  
  private(set) var currentVC: UIViewController?
  private var isOpened = false {
    didSet {
      updateViews()
    }
  }
  private var notifyAboutClosing: (() -> Void)?
  private var gesture: UIPanGestureRecognizer?
  
  private var placeholderHeight: CGFloat {
    view.bounds.height * viewHeightPercentage
  }
  
  private var gapSize: CGFloat {
    view.bounds.height - placeholderHeight
  }
  
  private var layout: CGRect {
    CGRect(
      x: 0,
      y: isOpened ? gapSize : view.bounds.height,
      width: view.bounds.width,
      height: placeholderHeight
    )
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpViews()
    updateViews()
  }
  
  private func updateViews() {
    placeholderView.frame = layout
    currentVC?.view.frame = placeholderView.bounds
    updateAlpha()
  }
  
  private func setUpViews() {
    roundView()
    placeholderView.backgroundColor = .white
    view.addSubview(placeholderView)
    placeholderView.frame = .zero
  }
  
  private func updateAlpha() {
    let alpha = maxDimmingAlpha * (1 - (placeholderView.frame.minY - gapSize) / (view.bounds.height - gapSize))
    view.backgroundColor = Brandbook.Colors.dimming.withAlphaComponent(alpha)
  }
  
  private func roundView() {
    let path = UIBezierPath(
      roundedRect: view.bounds,
      byRoundingCorners: [.topRight, .topLeft],
      cornerRadii: CGSize(width: 30, height: 30)
    )
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    placeholderView.layer.mask = maskLayer
  }
  
  func open(notifyAboutClosing: (() -> Void)?) {
    self.notifyAboutClosing = notifyAboutClosing
    view.isUserInteractionEnabled = true
    UIView.animate(
      withDuration: Brandbook.Durations.normal,
      delay: 0,
      options: [.allowUserInteraction],
      animations: {
        self.isOpened = true
      },
      completion: {
        self.view.isUserInteractionEnabled = $0
      }
    )
  }
  
  func close() {
    UIView.animate(
      withDuration: Brandbook.Durations.normal,
      delay: 0,
      options: [.allowUserInteraction],
      animations: {
        self.isOpened = false
      },
      completion: {
        self.view.isUserInteractionEnabled = !$0
      }
    )
  }
  
  func addController(child: UIViewController) {
    self.addChild(child)
    placeholderView.addSubview(child.view)
    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
    gestureRecognizer.delegate = self
    child.view.addGestureRecognizer(gestureRecognizer)
    child.didMove(toParent: self)
    currentVC = child
    gesture = gestureRecognizer
  }
  
  func removeCurrent() {
    currentVC?.willMove(toParent: nil)
    currentVC?.removeFromParent()
    currentVC?.view.removeFromSuperview()
    if let gesture = gesture {
      currentVC?.view.removeGestureRecognizer(gesture)
    }
  }
    
  @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
    if let scrollOffsetProvider = currentVC as? ScrollOffsetProviding {
      guard scrollOffsetProvider.scrollOffset.y <= 0 else {
        return
      }
    }
    
    let translation = recognizer.translation(in: view)
    self.placeholderView.frame = CGRect(
      x: 0,
      y: (gapSize + translation.y).clamp(
        min: gapSize,
        max: view.frame.height
      ),
      width: view.frame.width,
      height: placeholderHeight
    )
    updateAlpha()
    
    if recognizer.state == .ended {
      UIView.animate(
        withDuration: Brandbook.Durations.normal,
        delay: 0.0,
        options: [.allowUserInteraction],
        animations: {
          self.isOpened = !recognizer.isProjectedToDownHalf(
              maxTranslation: self.placeholderHeight,
              currentTranslation: self.placeholderHeight - (self.view.frame.height - self.placeholderView.frame.minY)
            )
        },
        completion: {
          if $0, !self.isOpened {
            self.notifyAboutClosing?()
            self.view.isUserInteractionEnabled = false
          }
        }
      )
    }
  }
}

private extension UIPanGestureRecognizer {
  func isProjectedToDownHalf(maxTranslation: CGFloat, currentTranslation: CGFloat) -> Bool {
    let endLocation = projectedLocation(decelerationRate: .normal, currentTranslation: currentTranslation)
    return endLocation.y > maxTranslation / 2
  }

  func projectedLocation(decelerationRate: UIScrollView.DecelerationRate, currentTranslation: CGFloat) -> CGPoint {
    let velocityOffset = velocity(in: view).projectedOffset(decelerationRate: .normal)
    return CGPoint(x: 0, y: currentTranslation) + velocityOffset
  }
}

extension CGPoint {
  func projectedOffset(decelerationRate: UIScrollView.DecelerationRate) -> CGPoint {
    CGPoint(
      x: x.projectedOffset(decelerationRate: decelerationRate),
      y: y.projectedOffset(decelerationRate: decelerationRate)
    )
  }
  
  static func +(left: CGPoint, right: CGPoint) -> CGPoint {
    CGPoint(
      x: left.x + right.x,
      y: left.y + right.y
    )
  }
}

extension CGFloat {
  func projectedOffset(decelerationRate: UIScrollView.DecelerationRate) -> CGFloat {
    let multiplier = 1 / (1 - decelerationRate.rawValue) / 1000
    return self * multiplier
  }
  
  func clamp(min: CGFloat, max: CGFloat) -> CGFloat {
    guard self > min else { return min }
    guard self < max else { return max }
    return self
  }
}

extension BottomSheetViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    return true
  }
}

private let viewHeightPercentage: CGFloat = 0.93
private let maxDimmingAlpha: CGFloat = 0.7
