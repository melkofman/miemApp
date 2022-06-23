//
//  SessionManagerBuilder.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 27.12.2020.
//

import Alamofire
import Foundation

public func makeDefaultSession() -> Alamofire.Session {
  let configuration = URLSessionConfiguration.default
  return Alamofire.Session(configuration: configuration)
}

public class Logger {
  private struct Log {
    let date: String
    let message: String
  }
  
  public static let shared = Logger()
  private var logs = [Log]()
  
  public var logString: String {
    var result = ""
    logs.forEach {
      result += "\($0.date) \($0.message)\n\n"
    }
    return result
  }
  
  func log(_ message: String) {
    logs.append(Log(date: Date().string(format: "YYYY-MM-dd hh:mm:ss.SSSSSS"), message: message))
  }
}
