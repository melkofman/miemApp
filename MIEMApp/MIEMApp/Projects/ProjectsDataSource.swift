//
//  ProjectsDataSource.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 03.11.2021.
//

import UIKit
import Alamofire

struct ProjectsParsedInfo: Decodable {
  let data: [ProjectsListModel]
}

struct ProjectsListModel: Decodable, Equatable {
  let id: Int
  let statusDesc: String
  let nameRus: String
  let head: String
  let typeDesc: String
  let vacancies: Int
  let vacancyData: [String]
  let team: [String]
  let number: String?
  
}

final class ProjectsDataSource {
  private let session = makeDefaultSession()
  private let user: Variable<User>
  private let token: Property<String>
  private var onUpdate: (([ProjectsListModel]) -> Void)?
  private var onUpdateTypes: (([String]) -> Void)?
  private var onUpdateStatus: (([String]) -> Void)?
  private var isUpdating: Bool = false
  var types = [String]()
  var status = [String]()
  
  init(
    user: Variable<User>,
    token: Property<String>) {
      self.user = user
      self.token = token
    }
  
  func setOnUpdate(onUpdate: @escaping ([ProjectsListModel]) -> Void) {
    self.onUpdate = onUpdate
  }
  
  func setOnUpdateTypes(onUpdateType: @escaping ([String]) -> Void) {
    self.onUpdateTypes = onUpdateType
  }
  
  func setOnUpdateStatus(onUpdateStatus: @escaping ([String]) -> Void) {
    self.onUpdateStatus = onUpdateStatus
  }
  
  func setNeedsUpdate() {
    guard !isUpdating else {
      return
    }
    parseProjects()
    
  }
  
  private func parseProjects() {
    self.isUpdating = true
    let headers: HTTPHeaders = ["x-auth-token": self.token.value]
    let url = "https://devcabinet.miem.vmnet.top/public-api/projects"
    session.request(url, method: .get).response {
      response in
      guard let data = response.data, let parsedResponse = try? JSONDecoder().decode(ProjectsParsedInfo.self, from: data) else {
        return
      }
      var typesNotUnique = [String]()
      var statsNotUnique = [String]()
      
      for i in parsedResponse.data {
        typesNotUnique.append(i.typeDesc)
        statsNotUnique.append(i.statusDesc)
      }
      typesNotUnique.append("Любой")
      statsNotUnique.append("Любой")
      
      
      self.types = Array(Set(typesNotUnique))
      self.status = Array(Set(statsNotUnique))
      
      var projectsListModel = [ProjectsListModel]()
      projectsListModel = parsedResponse.data
      
      self.onUpdate?(projectsListModel)
      self.onUpdateTypes?(self.types)
      self.onUpdateStatus?(self.status)
      
      self.isUpdating = false
      
    }
  }
}
