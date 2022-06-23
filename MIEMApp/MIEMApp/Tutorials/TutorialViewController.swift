//
//  TutorialViewController.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 14.03.2021.
//

import UIKit

protocol TutorialViewControlling {
  func showTutorial(_ tutorial: TutorialViewModel)
}

final class TutorialViewController: UIViewController, UIScrollViewDelegate, TutorialViewControlling {
  private let scrollView = UIScrollView(frame: .zero)
  private let pageControl = UIPageControl(frame: .zero)
  private let dimmingView = UIView(frame: .zero)
  private var closeAction: () -> Void = {}
  private var model: TutorialViewModel?
  
  func setCloseAction(_ closeAction: @escaping () -> Void) {
    self.closeAction = closeAction
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()

    scrollView.delegate = self
  }
  
  override func viewWillLayoutSubviews() {
    scrollView.frame = view.bounds.inset(by: UIEdgeInsets(top: 0, left: padding * 1.5, bottom: 0, right: padding * 1.5))
    dimmingView.frame = view.bounds
    pageControl.frame = CGRect(
      x: 0,
      y: view.bounds.height - 50 - view.safeAreaInsets.bottom,
      width: view.bounds.width,
      height: 50
    )
    let pages = model?.pages.count ?? 0
    scrollView.subviews.enumerated().forEach { index, view in
      var frame = CGRect()
      let offsetY = scrollView.frame.height - pageControl.frame.minY
      
      frame.origin = CGPoint(
        x: scrollView.frame.width * CGFloat(index) + padding / 2,
        y: scrollView.frame.height / 2 - offsetY
      )
      frame.size = CGSize(
        width: scrollView.frame.width - padding,
        height: scrollView.frame.height / 2
      )
      view.frame = frame
    }
    scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(pages), height: scrollView.frame.height)
  }
  
  private func configureViews() {
    scrollView.isPagingEnabled = true
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.clipsToBounds = false
    dimmingView.backgroundColor = .black
    dimmingView.alpha = 0.8
    pageControl.tintColor = Brandbook.Colors.tint
    pageControl.pageIndicatorTintColor = Brandbook.Colors.darkTint
    pageControl.currentPageIndicatorTintColor = Brandbook.Colors.tint
    view.addSubview(dimmingView)
    view.addSubview(scrollView)
    view.addSubview(pageControl)
  }

  private func configurePageControl() {
    guard let model = model else {
      return
    }
    pageControl.numberOfPages = model.pages.count
    pageControl.currentPage = 0
    pageControl.addTarget(self, action: #selector(changePage), for: .valueChanged)
  }
  
  private func setUpPages() {
    guard let model = model else {
      return
    }
    for (index, page) in model.pages.enumerated() {
      let isLast = index == model.pages.count - 1
      let subView = TutorialView(
        pageModel: page,
        buttonText: isLast ? "Закрыть" : "Далее",
        closeAction: closeAction,
        buttonAction: isLast
          ? closeAction
          : nextPage
      )
      subView.layer.cornerRadius = 10
      scrollView.addSubview(subView)
    }
  }
  
  func showTutorial(_ tutorial: TutorialViewModel) {
    model = tutorial
    scrollView.subviews.forEach {
      $0.removeFromSuperview()
    }
    configurePageControl()
    setUpPages()
  }

  @objc private func changePage() {
    let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
    scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
  }
  
  private func nextPage() {
    pageControl.currentPage = pageControl.currentPage + 1
    changePage()
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
    pageControl.currentPage = Int(pageNumber)
  }
}

private let padding = Brandbook.Paddings.light
