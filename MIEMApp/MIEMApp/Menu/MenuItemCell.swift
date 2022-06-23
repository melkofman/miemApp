//
//  MenuItemCell.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 08.01.2021.
//

import UIKit

final class MenuItemCell: UICollectionViewCell {
  private let icon = UIImageView()
  private let title = makeTitle()
  
  var model: MenuItemModel? {
    didSet {
      updateView()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
    addGestureRecognizer(tapGesture)
    setUp()
  }
      
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    animateAlpha(to: 0.7)
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
  
  static func maxLabelHeight() -> CGFloat {
    let title = makeTitle()
    title.text = "1"
    return title.sizeThatFits(CGSize(
      width: CGFloat.greatestFiniteMagnitude,
      height: CGFloat.greatestFiniteMagnitude)
    ).height * 2
  }
  
  private static func makeTitle() -> UILabel {
    let title = UILabel()
    title.numberOfLines = 0
    title.textAlignment = NSTextAlignment.center
    title.font = title.font.withSize(Brandbook.TextSize.small)
    title.lineBreakMode = NSLineBreakMode.byWordWrapping
    title.translatesAutoresizingMaskIntoConstraints = false
    return title
  }
  
  private func setUp() {
    icon.contentMode = .scaleAspectFit
    icon.translatesAutoresizingMaskIntoConstraints = false
    addSubview(icon)
    icon.topAnchor.constraint(equalTo: topAnchor).isActive = true
    icon.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    icon.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
    
    addSubview(title)
    title.topAnchor.constraint(equalTo: icon.bottomAnchor).isActive = true
    title.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
  }
  
  @objc func onTap(sender: UITapGestureRecognizer) {
    animateAlpha(to: 0.5) { _ in
      self.animateAlpha(to: 1)
    }
    model?.action()
  }
  
  private func updateView() {
    icon.image = model?.icon
    title.text = model?.title
  }
}

extension UIView {
  func animateAlpha(to alpha: CGFloat, completion: ((Bool) -> Void)? = nil) {
    UIView.animate(
      withDuration: Brandbook.Durations.short,
      delay: 0,
      options: [.curveEaseInOut],
      animations: {
        self.alpha = alpha
      },
      completion: completion
    )
  }
}
