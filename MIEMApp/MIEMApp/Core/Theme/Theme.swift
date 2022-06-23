//
//  Theme.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 11.04.2022.
//

import UIKit
enum Theme: Int, CaseIterable {
  case light = 0
  case dark
}
extension Theme {
  private static var appTheme = Int()
  
  // Сохранение темы в UserDefaults
  func save() {
    Theme.appTheme = self.rawValue
  }
  
  // Текущая тема приложения
  static var current: Theme {
    Theme(rawValue: appTheme) ?? .light
  }
  
  @available(iOS 13.0, *)
  var userInterfaceStyle: UIUserInterfaceStyle {
    switch self {
    case .light: return .light
    case .dark: return .dark
    }
  }
  
  func setActive() {
    // Сохраняем активную тему
    save()
    
    guard #available(iOS 13.0, *) else { return }
    
    // Устанавливаем активную тему для всех окон приложения
    UIApplication.shared.windows
      .forEach { $0.overrideUserInterfaceStyle = userInterfaceStyle }
  }
}
