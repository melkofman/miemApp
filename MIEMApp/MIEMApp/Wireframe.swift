//
//  Wireframe.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 16.11.2020.
//

import UIKit

protocol ScreenRouting {
  func show(screen: Screen, direction: TransitionDirection?)
  func push(screen: Screen, animated: Bool)
  func pop(animated: Bool)
  func popAll(animated: Bool)
  func openBottomSheet(notifyAboutClosing: (() -> Void)?)
  func closeBottomSheet()
  func addBottomSheetChild(screen: Screen)
  func removeBottomSheetChild()
  func selectItem(at index: Int)
  func showTutorial(_ tutorial: TutorialViewModel, closeAction: @escaping () -> Void)
}

final class Wireframe {
  private var screens: [Screen] = []
  
  private let screenRouter: ScreenRouting
  
  private var currentRegularScreen: Screen!
  private var isMenuOpened = false
  private var isOverlayScreenOpened = false
  private var isAuthScreenOpened = false
  
  init(screenRouter: ScreenRouting) {
    self.screenRouter = screenRouter
  }
  
  @objc private func btnOpenList() {
    openCamerasList()
  }
  
  @objc private func btnCloseList() {
    closeCamerasList()
  }
  
  @objc private func btnPush() {
    pushAboutScreen()
  }
  
  @objc private func btnPop() {
    screenRouter.pop(animated: true)
  }
  
  func setScreens(_ screens: [Screen]) {
    self.screens = screens
  }
  
  func pushAboutScreen() {
    pushScreen(with: .aboutScreen, animated: true)
  }
  
  func pushNavigationScreen() {
    pushScreen(with: .navScreen, animated: true)
    
  }
  
  func pushProjectListScreen() {
    pushScreen(with: .projectsScreen, animated: true)
  }
  
  func pushSandboxScreen() {
    pushScreen(with: .sandboxScreen, animated: true)
  }
  
  func pushAuthScreen() {
    isAuthScreenOpened = true
    pushScreen(with: .authScreen, animated: false)
  }
  
  func popAuthScreen() {
    guard isAuthScreenOpened else {
      return
    }
    isAuthScreenOpened = false
    screenRouter.pop(animated: false)
  }
  
  func closeAll() {
    screenRouter.popAll(animated: false)
    closeMenu()
    closeCamerasList()
  }
  
  func closeProfile() {
    closeProfileScreen(with: .profileScreen, animated: false)
   
  }
  
  func reloadProfile() {
    reload(with: .profileScreen)
  }
  
  private func reload(with id: ScreenId) {
    guard let screen = getScreen(with: id) else {
      return
    }
    screen.payload.controller.reloadInputViews()
  }
  
  private func closeProfileScreen(with id: ScreenId, animated: Bool) {
  guard let screen = getScreen(with: id) else {
    return
  }
    screen.payload.controller.reloadInputViews()
  }
  
  func showRecordScreen() {
    showRegularScreen(with: .recordScreen)
  }
  
  func showTimetableScreen() {
    showRegularScreen(with: .timetableScreen)
  }
  
  func showVmixScreen() {
    showRegularScreen(with: .vmixScreen)
    screenRouter.selectItem(at: 2)
  }
  
  func showProfileScreen() {
    showRegularScreen(with: .profileScreen)
    screenRouter.selectItem(at: 2)
  }
  
  func showProjectsScreen() {
    showRegularScreen(with: .projectsScreen)
    screenRouter.selectItem(at: 2)
  }
  
  func showControlScreen() {
    showRegularScreen(with: .cameraScreen)
    screenRouter.selectItem(at: 2)
  }
  
  private func showRegularScreen(with id: ScreenId) {
    guard let screen = getScreen(with: id) else {
      return
    }
    currentRegularScreen = screen
    closeMenu()
    screenRouter.show(screen: screen, direction: isOverlayScreenOpened ? .up : nil)
    isOverlayScreenOpened = false
  }
  
  private func pushScreen(with id: ScreenId, animated: Bool) {
    guard let screen = getScreen(with: id) else {
      return
    }
    closeMenu()
    screenRouter.push(screen: screen, animated: animated)
  }
  
  func setUpMenu(menuScreen: Screen) {
    screenRouter.addBottomSheetChild(screen: menuScreen)
  }
  
  private func openMenu() {
    isMenuOpened = true
    screenRouter.openBottomSheet(notifyAboutClosing: { self.isMenuOpened = false })
  }
  
  private func closeMenu() {
    isMenuOpened = false
    screenRouter.closeBottomSheet()
  }
  
  func toggleMenu() {
    isMenuOpened ? closeMenu() : openMenu()
  }
  
  func openCamerasList() {
    guard let cameraListScreen = getScreen(with: .cameraListScreen) else {
      return
    }
    isOverlayScreenOpened = true
    screenRouter.show(screen: cameraListScreen, direction: .down)
  }
  
  func closeCamerasList() {
    guard isOverlayScreenOpened else {
      return
    }
    isOverlayScreenOpened = false
    screenRouter.show(screen: currentRegularScreen, direction: .up)
  }
  
  func showTutorial(_ tutorial: TutorialViewModel, closeAction: @escaping () -> Void) {
    screenRouter.showTutorial(tutorial, closeAction: closeAction)
  }
  
  private func getScreen(with id: ScreenId) -> Screen? {
    screens.first(where: { $0.id == id })
  }
}
