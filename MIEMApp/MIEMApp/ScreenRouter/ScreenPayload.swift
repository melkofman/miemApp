//
//  ScreenPayload.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 15.11.2020.
//

import UIKit

protocol ScreenPayload {
  var controller: UIViewController { get }
}

struct FakeScreenPayload: ScreenPayload {
  private(set) var controller = UIViewController()
  
  init(color: UIColor) {
    controller.view.backgroundColor = color
  }
}

