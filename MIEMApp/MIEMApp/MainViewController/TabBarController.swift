//
//  TabBarController.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 15.11.2020.
//

import UIKit

final class TabBarController: UIViewController {
  private let bottomSheetVC = BottomSheetViewController()
  private let tabBar = TabBar()
  private let statusBar = UIView()
  
  private(set) var currentVC: UIViewController?
  private var isAnimating = false
  
  private var statusBarHeight: CGFloat {
    UIApplication.shared.statusBarFrame.size.height
  }
  
  var tabBarHeight: Variable<CGFloat> = Variable {
    UIDevice.hasNotch ? 83 : 49
  }
  
  private var tabBarFrame: CGRect {
    CGRect(x: 0, y: view.bounds.maxY - tabBarHeight.value, width: view.bounds.width, height: tabBarHeight.value)
  }
  
  private var childFrame: CGRect {
    CGRect(
      x: view.bounds.minX,
      y: view.bounds.minY + statusBarHeight,
      width: view.bounds.width,
      height: view.bounds.height - statusBarHeight
    )
  }

  init() {
    super.init(nibName: nil, bundle: nil)
    //navigationItem.backButtonTitle = ""
    view.addSubview(statusBar)
    addBottomSheetView()
    view.addSubview(tabBar)
//    statusBar.backgroundColor = .white
    if #available(iOS 13.0, *) {
      statusBar.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    tabBar.frame = tabBarFrame
    bottomSheetVC.view.frame = view.bounds
    statusBar.frame = UIApplication.shared.statusBarFrame
    if !isAnimating {
      currentVC?.view.frame = childFrame
    }
  }
  
  func show(controller: UIViewController, direction: TransitionDirection? = nil) {
    guard controller != currentVC else { return }
    self.addChild(controller)
    view.insertSubview(controller.view, at: 0)
    controller.didMove(toParent: self)
    animate(from: currentVC?.view, to: controller.view, direction: direction, completion: {
      if $0 {
        self.remove(controller: self.currentVC)
        self.currentVC = controller
      } else {
        self.remove(controller: controller)
      }
    })
  }
  
  private func remove(controller: UIViewController?) {
    controller?.willMove(toParent: nil)
    controller?.removeFromParent()
    controller?.view.removeFromSuperview()
  }
  
  private func animate(
    from: UIView?,
    to: UIView,
    direction: TransitionDirection?,
    completion: @escaping (Bool) -> Void
  ) {
    guard let from = from else {
      return completion(true)
    }
    guard let direction = direction else {
      return completion(true)
    }
    
    let fromFrame: CGRect
    switch direction {
    case .up:
      fromFrame = from.frame.offsetBy(dx: 0, dy: -from.frame.height)
      to.frame = childFrame.offsetBy(dx: 0, dy: view.bounds.height - statusBarHeight)
    case .down:
      fromFrame = from.frame.offsetBy(dx: 0, dy: from.frame.height)
      to.frame = childFrame.offsetBy(dx: 0, dy: -(view.bounds.height - statusBarHeight))
    }
    UIView.animate(
      withDuration: Brandbook.Durations.normal,
      animations: {
        self.isAnimating = true
        from.frame = fromFrame
        to.frame = self.childFrame
      },
      completion: {
        self.isAnimating = false
        completion($0)
      }
    )
  }

  func openBottomSheet(notifyAboutClosing: (() -> Void)?) {
    bottomSheetVC.open(notifyAboutClosing: notifyAboutClosing)
  }
  
  func closeBottomSheet() {
    bottomSheetVC.close()
  }
  
  func addBottomSheetChild(_ child: UIViewController) {
    bottomSheetVC.addController(child: child)
  }
  
  func removeBottomSheetChild() {
    bottomSheetVC.removeCurrent()
  }
  
  func setItems(_ items: [TabBar.Item]) {
    tabBar.setTabBarItems(items)
  }
  
  func selectItem(at index: Int) {
    tabBar.selectItem(at: index)
  }
  
  private func addBottomSheetView() {
    self.addChild(bottomSheetVC)
    self.view.addSubview(bottomSheetVC.view)
    bottomSheetVC.didMove(toParent: self)
  }
}

private extension UIDevice {
  static let modelName: String = {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }

    return mapToDevice(identifier: identifier)
  }()
  
  static let hasNotch: Bool = {
    switch modelName {
      case "iPhone X", "iPhone XS", "iPhone XS Max", "iPhone XR", "iPhone 11", "iPhone 11 Pro", "iPhone 11 Pro Max",
      "iPhone 12 mini", "iPhone 12", "iPhone 12 Pro", "iPhone 12 Pro Max", "iPhone 13 Pro", "iPhone 13 Pro Max", "iPhone 13 Mini", "iPhone 13":
        return true
    default:
      return false
    }
  }()
  
  static private func mapToDevice(identifier: String) -> String {
    #if os(iOS)
    switch identifier {
    case "iPod5,1":                                 return "iPod touch (5th generation)"
    case "iPod7,1":                                 return "iPod touch (6th generation)"
    case "iPod9,1":                                 return "iPod touch (7th generation)"
    case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
    case "iPhone4,1":                               return "iPhone 4s"
    case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
    case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
    case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
    case "iPhone7,2":                               return "iPhone 6"
    case "iPhone7,1":                               return "iPhone 6 Plus"
    case "iPhone8,1":                               return "iPhone 6s"
    case "iPhone8,2":                               return "iPhone 6s Plus"
    case "iPhone8,4":                               return "iPhone SE"
    case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
    case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
    case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
    case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
    case "iPhone10,3", "iPhone10,6":                return "iPhone X"
    case "iPhone11,2":                              return "iPhone XS"
    case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
    case "iPhone11,8":                              return "iPhone XR"
    case "iPhone12,1":                              return "iPhone 11"
    case "iPhone12,3":                              return "iPhone 11 Pro"
    case "iPhone12,5":                              return "iPhone 11 Pro Max"
    case "iPhone12,8":                              return "iPhone SE (2nd generation)"
    case "iPhone13,1":                              return "iPhone 12 mini"
    case "iPhone13,2":                              return "iPhone 12"
    case "iPhone13,3":                              return "iPhone 12 Pro"
    case "iPhone13,4":                              return "iPhone 12 Pro Max"
    case "iPhone14,2":                              return "iPhone 13 Pro"
    case "iPhone14,3":                              return "iPhone 13 Pro Max"
    case "iPhone14,4":                              return "iPhone 13 Mini"
    case "iPhone14,5":                              return "iPhone 13"
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
    case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
    case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
    case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
    case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
    case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
    case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
    case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
    case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
    case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
    case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
    case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
    case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
    case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
    case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
    case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
    case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
    case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
    case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
    case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
    case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
    case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
    case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
    case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
    case "AppleTV5,3":                              return "Apple TV"
    case "AppleTV6,2":                              return "Apple TV 4K"
    case "AudioAccessory1,1":                       return "HomePod"
    case "AudioAccessory5,1":                       return "HomePod mini"
    case "i386", "x86_64":                          return "\(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
    default:                                        return identifier
    }
    #endif
  }
}

