//
//  TabBarModelBuilder.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 16.11.2020.
//

import UIKit

func makeTabBarItems(wireframe: Wireframe, isReview: Bool) -> [TabBar.Item] {
  return isReview
    ? [
      TabBar.Item(title: "Расписание", image: Brandbook.Images.Icons.timetabelTabBarIcon, action: { [wireframe] in
        wireframe.showTimetableScreen()
      }, isSelectable: true),
      TabBar.Item(title: "Меню", image: Brandbook.Images.Icons.menuTabBarIcon, action: { [wireframe] in
        wireframe.toggleMenu()
      }, isSelectable: false),
      TabBar.Item(title: "Профиль", image: Brandbook.Images.Icons.menuTabBarIcon, action: { [wireframe] in
        wireframe.showProfileScreen()
      }, isSelectable: false)
    ]
    : [
      TabBar.Item(title: "Расписание", image: Brandbook.Images.Icons.timetabelTabBarIcon, action: { [wireframe] in
        wireframe.showTimetableScreen()
      }, isSelectable: true),

      TabBar.Item(title: "Меню", image: Brandbook.Images.Icons.menuTabBarIcon, action: { [wireframe] in
        wireframe.toggleMenu()
      }, isSelectable: false),
      TabBar.Item(title: "Профиль", image: Brandbook.Images.Icons.profileTabBarIcon, action: { [wireframe] in
        wireframe.showProfileScreen()
      }, isSelectable: false)
    ]
}
