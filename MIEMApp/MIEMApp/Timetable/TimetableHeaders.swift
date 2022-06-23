//
//  TimetableHeaders.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 10.01.2021.
//

import UIKit

final class TimetableSectionHeader: UICollectionReusableView {
  let label = UILabel()
 
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUp() {
    addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.topAnchor.constraint(equalTo: topAnchor).isActive = true
    label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
    label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    label.textColor = Brandbook.Colors.grey
  }
}

final class TimetableDatesHeader: UICollectionReusableView {
  let label = UILabel()
  var action: (() -> Void)?
 
  override init(frame: CGRect) {
    super.init(frame: frame)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
    addGestureRecognizer(tapGesture)
    setUp()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func onTap(sender: UITapGestureRecognizer) {
    animateAlpha(to: 0.5) { _ in
      self.animateAlpha(to: 1)
    }
    action?()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    animateAlpha(to: 0.5)
    super.touchesBegan(touches, with: event)
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    animateAlpha(to: 1)
    super.touchesEnded(touches, with: event)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    animateAlpha(to: 1)
    super.touchesMoved(touches, with: event)
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    animateAlpha(to: 1)
    super.touchesCancelled(touches, with: event)
  }
  
  private func setUp() {
    addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.topAnchor.constraint(equalTo: topAnchor).isActive = true
    label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
    label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    label.textColor = Brandbook.Colors.tint
  }
}

private let padding = Brandbook.Paddings.normal
