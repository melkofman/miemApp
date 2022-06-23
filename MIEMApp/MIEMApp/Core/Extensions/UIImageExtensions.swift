//
//  UIImsgeExtensions.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 07.03.2022.
//

import Foundation
import UIKit
extension UIImage {
  convenience init?(base64 str: String) {
    guard let url = URL(string: str),
          let data = try? Foundation.Data(contentsOf: url),
          UIImage(data: data) != nil else { return nil }
    self.init(data: data)!
  }
}
