//
//  Settings.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 27.12.2020.
//

import Foundation

public final class Settings {
  private enum Keys {
    static let authTokenKey = "AuthTokenKey"
    static let userKey = "UserKey"
    static let menuItemsKey = "MenuItemsKey"
    static let camerasTutorialShownKey = "CamerasTutorialShownKey"
  }
  
  private enum Defaults {
    static let authTokenDefault = ""
    static let userDefault = User(email: "", student: true)
//    static let menuItemsDefault: [MenuItemKind] = [.control, .about, .profile]
    static let menuItemsDefault: [MenuItemKind] = [.about, .projects]
  }
  
  public let authToken: Property<String>
  public let user: Property<User>
  public let menuItems: Property<[MenuItemKind]>
  public let camerasTutorialShown: Property<Bool>
    
  public init() {
    authToken = Property(initialValue: UserDefaults.standard.string(forKey: Keys.authTokenKey) ?? Defaults.authTokenDefault)
    user = Property(
      initialValue: decode(
        data: UserDefaults.standard.object(forKey: Keys.userKey) as? Data,
        type: User.self
      ) ?? Defaults.userDefault
    )
    menuItems = Property(
      initialValue: UserDefaults.standard.array(forKey: Keys.menuItemsKey)?.compactMap {
        MenuItemKind(rawValue: $0 as! Int)
      } ?? Defaults.menuItemsDefault
    )
    camerasTutorialShown = Property(initialValue: UserDefaults.standard.bool(forKey: Keys.camerasTutorialShownKey))
  }
  
  public func close() {
    UserDefaults.standard.set(authToken.value, forKey: Keys.authTokenKey)
    if let userData = encode(value: user.value) {
      UserDefaults.standard.setValue(userData, forKey: Keys.userKey)
    }
    UserDefaults.standard.setValue(menuItems.value.map { $0.rawValue }, forKey: Keys.menuItemsKey)
    UserDefaults.standard.set(camerasTutorialShown.value, forKey: Keys.camerasTutorialShownKey)
    UserDefaults.standard.synchronize()
  }
}

private func decode<T: Codable>(data: Data?, type: T.Type) -> T? {
  guard let data = data else {
    return nil
  }
  guard let result = try? JSONDecoder().decode(T.self, from: data) else {
    return nil
  }
  return result
}

private func encode<T: Codable>(value: T) -> Data? {
  try? JSONEncoder().encode(value)
}
