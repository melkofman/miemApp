//
//  SandboxDataSource.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 10.03.2022.
//

import UIKit
import Alamofire

struct SandboxInfo: Decodable {
  let data: [ListProjectInfoModel]
}

struct ListProjectInfoModel: Decodable, Equatable {
  let owner: Bool
  let status: String
  let statusDesc: String
  let nameRus: String
  let head: String
  let typeDesc: String
  let dateCreated: String
  let vacancies: Int
  let number: String
}

final class SandboxDataSource {
  private let session = makeDefaultSession()
  private let user: Variable<User>
  private let token: Property<String>
  
  private var onUpdate: (([ListProjectInfoModel])-> Void)?
  
  private var isUpdating: Bool = false
  
  
  init(
    user: Variable<User>,
    token: Property<String>) {
      self.user = user
      self.token = token
      parseSandbox()
    }
  
  func setOnUpdate(onUpdate: @escaping (([ListProjectInfoModel])->Void)) {
    self.onUpdate = onUpdate
  }
  
  func setNeedsUpdate() {
    guard !isUpdating else {
      return
    }
    parseSandbox()
  }
  
  func parseSandbox() {
    let url = "https://devcabinet.miem.vmnet.top/api/sandbox"
    let headers: HTTPHeaders = ["x-auth-token": self.token.value]
    
    session.request(url, method: .get, headers: headers).response {
      response in
      guard let data = response.data, let parsedResponse = try? JSONDecoder().decode(SandboxInfo.self, from: data) else {
        return
      }
      
      var sandboxModel = [ListProjectInfoModel]()
      for element in parsedResponse.data {
        if element.nameRus.count > 4 {
          sandboxModel.append(element)
        }
      }
      self.onUpdate?(sandboxModel)
      self.isUpdating = false
    }
  }
}
