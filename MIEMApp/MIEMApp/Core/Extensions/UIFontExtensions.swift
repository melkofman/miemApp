//
//  UIFontExtensions.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 14.03.2021.
//

import UIKit

extension UIFont {
  var bold: UIFont {
    UIFont.boldSystemFont(ofSize: self.pointSize)
  }
}
