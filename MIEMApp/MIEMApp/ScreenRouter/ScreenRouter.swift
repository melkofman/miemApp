//
//  ScreenRouter.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 15.11.2020.
//

import UIKit

enum TransitionDirection {
  case up
  case down
}

typealias RootController = RootControlling & UIViewController

protocol RootControlling {
  func close(controller: UIViewController, animated: Bool)
  
  func show(controller: UIViewController, direction: TransitionDirection?)
  func push(controller: UIViewController, animated: Bool)
  func pop(animated: Bool)
  func popAll(animated: Bool)
  func openBottomSheet(notifyAboutClosing: (() -> Void)?)
  func closeBottomSheet()
  func addBottomSheetChild(_ child: UIViewController)
  func removeBottomSheetChild()
  func selectItem(at index: Int)
  func showTutorial(_ tutorial: TutorialViewModel, closeAction: @escaping () -> Void)
}

final class ScreenRouter: ScreenRouting {
  private let rootController: RootController
  
  var rootViewController: UIViewController {
    rootController
  }
  
  init(rootController: RootController) {
    self.rootController = rootController
  }
  
  func close(screen: Screen, animated: Bool) {
//    screen.payload.controller.dismiss(animated: animated, completion: { print("f closed")})
    rootViewController.dismiss(animated: animated, completion:{ print("f closed")})
  }
  
  func show(screen: Screen, direction: TransitionDirection?) {
    rootController.show(controller: screen.payload.controller, direction: direction)
  }
  
  func push(screen: Screen, animated: Bool) {
    rootController.push(controller: screen.payload.controller, animated: animated)
  }
  
  
  func pop(animated: Bool) {
    rootController.pop(animated: animated)
  }
  
  func popAll(animated: Bool) {
    rootController.popAll(animated: animated)
  }

  func openBottomSheet(notifyAboutClosing: (() -> Void)?) {
    rootController.openBottomSheet(notifyAboutClosing: notifyAboutClosing)
  }
  
  func closeBottomSheet() {
    rootController.closeBottomSheet()
  }
  
  func addBottomSheetChild(screen: Screen) {
    rootController.addBottomSheetChild(screen.payload.controller)
  }
  
  func removeBottomSheetChild() {
    rootController.removeBottomSheetChild()
  }
  
  func selectItem(at index: Int) {
    rootController.selectItem(at: index)
  }
  
  func showTutorial(_ tutorial: TutorialViewModel, closeAction: @escaping () -> Void) {
    rootController.showTutorial(tutorial, closeAction: closeAction)
  }
}
