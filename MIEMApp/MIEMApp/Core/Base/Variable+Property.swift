//
//  Variable+Property.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 27.12.2020.
//

import Foundation

public struct Variable<T> {
  public var value: T {
    get {
      getter()
    }
  }
  private let getter: () -> T
  
  public init(getter: @escaping () -> T) {
    self.getter = getter
  }
}

public struct Property<T> {
  public var value: T {
    get {
      getter()
    }
    set {
      setter(newValue)
    }
  }
  private let getter: () -> T
  private let setter: (T) -> ()
  
  public init(getter: @escaping () -> T, setter: @escaping (T) -> ()) {
    self.getter = getter
    self.setter = setter
  }
  
  public init(initialValue: T) {
    var value = initialValue
    self.init(getter: { value }, setter: { value = $0 })
  }
}

public extension Property {
  func asVariable() -> Variable<T> {
    Variable(getter: getter)
  }
}
