//
//  MainController.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 26.12.2020.
//

import UIKit

final class MainController: UINavigationController, RootControlling {
  
  
  private let tabController: TabBarController
  private let tutorialController = TutorialViewController()
  
  init(tabController: TabBarController) {
    self.tabController = tabController
    super.init(rootViewController: tabController)
//    view.backgroundColor = .white
    if #available(iOS 13.0, *) {
      view.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    tutorialController.willMove(toParent: self)
    view.addSubview(tutorialController.view)
    closeTutorial()
    tutorialController.didMove(toParent: self)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillLayoutSubviews() {
    tutorialController.view.frame = view.bounds
    super.viewWillLayoutSubviews()
  }
  
  override func pushViewController(_ controller: UIViewController, animated: Bool) {
    super.pushViewController(controller, animated: animated)
  }
  
  @discardableResult
  override func popViewController(animated: Bool) -> UIViewController? {
    let controller = super.popViewController(animated: animated)
    return controller
  }
  
  func close(controller: UIViewController, animated: Bool) {
    dismiss(animated: animated, completion: nil)
  }
  
  func push(controller: UIViewController, animated: Bool) {
    pushViewController(controller, animated: animated)
  }
  
  func pop(animated: Bool) {
    popViewController(animated: animated)
  }
  
  func popAll(animated: Bool) {
    popToRootViewController(animated: animated)
  }

  func show(controller: UIViewController, direction: TransitionDirection?) {
    tabController.show(controller: controller, direction: direction)
  }
  
  func openBottomSheet(notifyAboutClosing: (() -> Void)?) {
    tabController.openBottomSheet(notifyAboutClosing: notifyAboutClosing)
  }
  
  func closeBottomSheet() {
    tabController.closeBottomSheet()
  }
  
  func addBottomSheetChild(_ child: UIViewController) {
    tabController.addBottomSheetChild(child)
  }
  
  func removeBottomSheetChild() {
    tabController.removeBottomSheetChild()
  }
  
  func selectItem(at index: Int) {
    tabController.selectItem(at: index)
  }
  
  func showTutorial(_ tutorial: TutorialViewModel, closeAction: @escaping () -> Void) {
    tutorialController.view.isHidden = false
    tutorialController.setCloseAction {
      self.closeTutorial()
      closeAction()
    }
    tutorialController.showTutorial(tutorial)
    tutorialController.view.animateAlpha(to: 1)
  }
  
  private func closeTutorial() {
    tutorialController.view.animateAlpha(to: 0) {
      self.tutorialController.view.isHidden = $0
    }
  }
}
