//
//  TouchDetectingView.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 19.01.2021.
//

import UIKit

final class TouchDetectingView: UIView {
  private var action: (() -> Void)?
  
  func setAction(_ action: @escaping () -> Void) {
    self.action = action
  }
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    if bounds.contains(point) {
      action?()
    }
    return false
  }
}
