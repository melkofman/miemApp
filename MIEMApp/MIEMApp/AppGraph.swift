//
//  AppGraph.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 16.11.2020.
//

import UIKit
import NavigationModule

final class AppGraph {
  let screenRouter: ScreenRouter
  private let tabBarController = TabBarController()
  private let wireframe: Wireframe
  private let settings = Settings()
  private let authGraph: AuthGraph
  private let menuGraph: MenuGraph
  private let timetableGraph: TimetableGraph
  private let profileGraph: ProfileGraph
  private let projectsGraph: ProjectsGraph
  private let sandboxGraph: SandboxGraph
  
  init() {
    screenRouter = ScreenRouter(rootController: MainController(tabController: tabBarController))
    wireframe = Wireframe(screenRouter: screenRouter)
    menuGraph = MenuGraph(
      wireframe: wireframe,
      bottomInset: tabBarController.tabBarHeight,
      menuItems: settings.menuItems,
      user: settings.user.asVariable()
    )
    timetableGraph = TimetableGraph(
      bottomInset: tabBarController.tabBarHeight,
      user: settings.user.asVariable()
    )
    projectsGraph = ProjectsGraph(wireframe: wireframe, bottomInset: tabBarController.tabBarHeight, user: settings.user.asVariable(), token: settings.authToken)
    sandboxGraph = SandboxGraph(wireframe: wireframe, bottomInset: tabBarController.tabBarHeight, user: settings.user.asVariable(), token: settings.authToken)
    profileGraph = ProfileGraph(bottomInset: tabBarController.tabBarHeight, user: settings.user.asVariable(), token: settings.authToken)
    authGraph = AuthGraph(
      wireframe: wireframe,
      token: settings.authToken,
      user: settings.user,
      onLogIn: { [
        unowned menuGraph,
        unowned timetableGraph,
        unowned profileGraph,
        unowned projectsGraph,
        unowned sandboxGraph,
        unowned settings,
        unowned tabBarController,
        unowned wireframe
      ] in
        menuGraph.setNeedsUpdate()
        timetableGraph.setNeedsUpdate()
        profileGraph.setNeedsUpdate()
        projectsGraph.setNeedsUpdate()
        sandboxGraph.setNeedsUpdate()
        
        tabBarController.setItems(makeTabBarItems(wireframe: wireframe, isReview: settings.user.value.isReview))
        tabBarController.selectItem(at: 0)
        wireframe.showTimetableScreen()
      }
    )
    wireframe.setUpMenu(menuScreen: menuGraph.screen)
    
//    wireframe.setScreens([
//      authGraph.screen,
//      timetableGraph.screen,
//      projectsGraph.screen,
//      sandboxGraph.screen,
//      profileGraph.screen,
//      Screen(id: .aboutScreen, payload: AboutScreenLoad(onExitClicked: authGraph.logOut)),
//      Screen(id: .navScreen, payload: NavigationScreenLoad(navController: nc))
//
//    ])
    if #available(iOS 13.0, *) {
      let nc = NavigationModule.NavigationController()
      wireframe.setScreens([
        authGraph.screen,
        timetableGraph.screen,
        projectsGraph.screen,
        sandboxGraph.screen,
        profileGraph.screen,
        Screen(id: .aboutScreen, payload: AboutScreenLoad(onExitClicked: authGraph.logOut)),
        Screen(id: .navScreen, payload: NavigationScreenLoad(navController: nc))
        
      ])
    } else {
      wireframe.setScreens([
        authGraph.screen,
        timetableGraph.screen,
        projectsGraph.screen,
        sandboxGraph.screen,
        profileGraph.screen,
        Screen(id: .aboutScreen, payload: AboutScreenLoad(onExitClicked: authGraph.logOut))
      ])
    }
    authGraph.logIn()
  }
  
  func refreshProfile() {
    profileGraph.setNeedsUpdate()
  }
  
  func applicationWillTerminate() {
    settings.close()
  }
}
