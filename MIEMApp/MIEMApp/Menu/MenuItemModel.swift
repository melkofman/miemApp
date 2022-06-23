//
//  MenuItemModel.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 08.01.2021.
//

import UIKit

public enum MenuItemKind: Int {
  case about
  case projects
  case sandbox
  case navigation
}

struct MenuItemModel {
  let icon: UIImage
  let title: String
  let action: () -> Void
}
