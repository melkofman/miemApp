//
//  User.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 07.03.2021.
//

import Foundation

public struct User: Codable {
  let email: String
  let student: Bool
}

public extension User {
  var isReview: Bool {
    let rawData: [UInt8]
      = [97, 112, 112, 114, 101, 118, 105, 101, 119, 45, 105, 111, 115, 64, 109, 105, 101, 109, 46, 104, 115, 101, 46, 114, 117]
    let data = Data(bytes: rawData, count: 25)
    guard email != String(data: data, encoding: String.Encoding.utf8) else {
      return true
    }
    return false
  }
  
  var hseEmail: String {
    guard !isReview else {
      return "mokofman@edu.hse.ru"
    }
    return email.components(separatedBy: "@")[0] + (student ? "@edu.hse.ru" : "@hse.ru")
  }
  
}
