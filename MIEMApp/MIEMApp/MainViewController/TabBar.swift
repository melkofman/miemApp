//
//  TabBar.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 16.11.2020.
//

import UIKit

final class TabBar: UITabBar {
  struct Item {
    let title: String
    let image: UIImage
    let action: () -> Void
    let isSelectable: Bool
  }
  
  private var tabBarItems: [Item]?
  private var currentItemIndex = 0
  
  init() {
    super.init(frame: .zero)
    delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setTabBarItems(_ items: [Item]) {
    tabBarItems = items
    bindItems()
  }
  
  func selectItem(at index: Int) {
    guard let items = items, index < items.count else {
      return
    }
    selectedItem = items[index]
    currentItemIndex = index
  }
  
  private func bindItems() {
    setItems(
      tabBarItems?.map {
        UITabBarItem(title: $0.title, image: $0.image, tag: tabBarItems?.firstIndex(of: $0) ?? 0)
      },
      animated: false
    )
  }
}

extension TabBar: UITabBarDelegate {  
  func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    guard let tabBarItem = tabBarItems?[item.tag] else {
      return
    }
    tabBarItem.isSelectable ? currentItemIndex = item.tag : selectItem(at: currentItemIndex)
    tabBarItem.action()
  }
}

extension TabBar.Item: Equatable {
  static func == (lhs: TabBar.Item, rhs: TabBar.Item) -> Bool {
    lhs.title == rhs.title && lhs.image == rhs.image
  }
}
