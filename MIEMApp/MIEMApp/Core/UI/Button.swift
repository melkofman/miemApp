//
//  Button.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 21.01.2021.
//

import UIKit
final class Button: UIButton {
  override public var isHighlighted: Bool {
    didSet {
      animateAlpha(to: isHighlighted ? 0.5 : 1)
    }
  }
  
  init(_ text: String? = nil) {
    super.init(frame: .zero)
    backgroundColor = Brandbook.Colors.tint
    adjustsImageWhenHighlighted = false
    tintColor = .white
    setTitleColor(.white, for: .normal)
    contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    layer.cornerRadius = 11
    layer.masksToBounds = true
    if let text = text {
      setTitle(text, for: .normal)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
