//
//  DatePickerView.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 11.01.2021.
//

import UIKit

final class DatePickerView: UIView {
  private let firstPicker = makePicker()
  private let secondPicker = makePicker()
  private let button = UIButton()
  private let blurView = UIVisualEffectView()
  
  private var onResult: (((Date, Date)) -> Void)?
  private var isFirstPicker = true
  
  private var buttonFrame: CGRect {
    let padding = Brandbook.Paddings.normal
    let buttonSize = button.systemLayoutSizeFitting(
      CGSize(width: bounds.width, height: 20),
      withHorizontalFittingPriority: .fittingSizeLevel,
      verticalFittingPriority: .fittingSizeLevel
    )
    return CGRect(
      origin: CGPoint(x: bounds.width - buttonSize.width - padding, y: 0),
      size: buttonSize
    )
  }
  
  private var initialLayout: (CGRect, CGRect, CGRect, CGRect) {
    let button = buttonFrame
    let pickerSize = CGSize(width: bounds.width, height: bounds.height - button.height)
    let firstPickerFrame = CGRect(origin: CGPoint(x: 0, y: button.maxY), size: pickerSize)
    let secondPickerFrame = CGRect(origin: CGPoint(x: bounds.width, y: button.maxY), size: pickerSize)
    return (firstPickerFrame, secondPickerFrame, button, bounds)
  }
  
  init() {
    super.init(frame: .zero)
    setUp()
  }
  
  private func setUp() {
    addSubview(blurView)
    addSubview(firstPicker)
    addSubview(secondPicker)
    addSubview(button)
    blurView.effect = UIBlurEffect(style: .regular)
    button.setTitleColor(Brandbook.Colors.tint, for: .normal)
    button.addTarget(self, action: #selector(onClick), for: .touchUpInside)
    button.showsTouchWhenHighlighted = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func start(onResult: @escaping ((Date, Date)) -> Void) {
    self.onResult = onResult
    button.setTitle("Далее", for: .normal)
    let layout = initialLayout
    button.frame = layout.2
    UIView.animate(
      withDuration: isFirstPicker ? 0 : Brandbook.Durations.normal,
      animations: {
        (self.firstPicker.frame, self.secondPicker.frame, _, self.blurView.frame) = layout
      }
    )
    isFirstPicker = true
  }
  
  @objc private func onClick() {
    if isFirstPicker {
      button.setTitle("Применить", for: .normal)
      button.frame = buttonFrame
      isFirstPicker = false
      UIView.animate(
        withDuration: Brandbook.Durations.normal,
        animations: {
          self.firstPicker.frame = self.firstPicker.frame.offsetBy(dx: -self.bounds.width, dy: 0)
          self.secondPicker.frame = self.secondPicker.frame.offsetBy(dx: -self.bounds.width, dy: 0)
        }
      )
    } else {
      if firstPicker.date < secondPicker.date {
        onResult?((firstPicker.date, secondPicker.date))
      } else {
        print("Выбран неверный промежуток времени")
        alert()
      }
    }
  }
  
  func reset() {
    (firstPicker.frame, secondPicker.frame, button.frame, blurView.frame) = initialLayout
  }
}

private func makePicker() -> UIDatePicker {
  let datePicker = UIDatePicker()
  datePicker.datePickerMode = .date
  if #available(iOS 13.4, *) {
    datePicker.preferredDatePickerStyle = .wheels
  }
  return datePicker
}

func alert() {
  
  let alert = UIAlertView()
  alert.title = "Ошибка!"
  alert.message = "Указан неправильный промежуток времени"
  alert.addButton(withTitle: "ОК")
  alert.show()
}
