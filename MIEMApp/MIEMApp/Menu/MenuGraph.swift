//
//  MenuGraph.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 09.01.2021.
//

import UIKit

final class MenuGraph {
  let screen: Screen
  private let menuLoad: MenuScreenLoad
  private let menuDataSource: MenuDataSource
  
  init(
    wireframe: Wireframe,
    bottomInset: Variable<CGFloat>,
    menuItems: Property<[MenuItemKind]>,
    user: Variable<User>
  ) {
    menuDataSource = MenuDataSource(menuItems: menuItems, user: user)
    menuLoad = MenuScreenLoad(wireframe: wireframe, bottomInset: bottomInset, model: menuDataSource.initialModel)
    screen = Screen(id: .menuScreen, payload: menuLoad)
    menuDataSource.setOnUpdate { [unowned self] in
      self.menuLoad.model = $0
    }
  }
  
  func setNeedsUpdate() {
    menuDataSource.setNeedsUpdate()
  }
}
