//
//  MoewProjectDataSource.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 05.12.2021.
//

import UIKit
import Alamofire

struct MoreProjectHeader: Decodable {
  let data: ProjectHeaderModel
}

struct ProjectHeaderModel: Decodable, Equatable {
  let id: Int
  let nameRus: String
  let number: String
  let googleGroup: String
  let chat: String
  let wiki: String
  let statusLabel: String
}

struct MoreProjectBody: Decodable {
  let data: ProjectBodyModel
}

struct ProjectBodyModel: Decodable, Equatable {
  let target: String
  let annotation: String
}

struct MoreProjectsParsedVacancyInfo: Decodable {
  let data: [VacancyInfoModel]
}

struct VacancyInfoModel: Decodable, Equatable {
  let role: String
  let count: Int
  let disciplines: [String]
  let additionally: [String]
  let vacancy_id: Int
}

struct MoreProjectTeam: Decodable, Equatable {
  let data: ProjectMemberResponseModel
}

struct ProjectMemberResponseModel: Decodable, Equatable {
  let leaders: [HumanModel]
  let activeMembers: [HumanModel]
}

struct HumanModel: Decodable, Equatable {
  let first_name: String
  let last_name: String
  let pic: String
  let role: String
}

final class MoreProjectDataSource {
  private let session = makeDefaultSession()
  
  private var onUpdateHeader: ((ProjectHeaderModel) -> Void)?
  private var onUpdateBody: ((ProjectBodyModel) -> Void)?
  private var onUpdateVacancy: (([VacancyInfoModel]) -> Void)?
  private var onUpdateTeam: ((ProjectMemberResponseModel) -> Void)?
  
  private var isUpdating: Bool = false
  let id: Int
  
  init(id: Int) {
    self.id = id
  }
  
  func setOnUpdateHeader(onUpdate: @escaping (ProjectHeaderModel) -> Void) {
    self.onUpdateHeader = onUpdate
  }
  
  func setOnUpdateBody(onUpdate: @escaping (ProjectBodyModel) -> Void) {
    self.onUpdateBody = onUpdate
  }
  
  func setOnUpdateVacancy(onUpdate: @escaping ([VacancyInfoModel]) -> Void) {
    self.onUpdateVacancy = onUpdate
  }
  
  func setOnUpdateTeam(onUpdate: @escaping (ProjectMemberResponseModel) -> Void) {
    self.onUpdateTeam = onUpdate
  }
  
  func setNeedsUpdate() {
    guard !isUpdating else {
      return
    }
    parseInfo()
  }
  
  private func parseInfo() {
    parseHeader()
    parseBody()
    parseVacancy()
    parseTeam()
  }
  
  private func parseHeader() {
    let id = self.id
    let url = "https://devcabinet.miem.vmnet.top/public-api/project/header/\(id)"
    session.request(url, method: .get).response {
      response in
      guard let data = response.data, let parsedResponse = try? JSONDecoder().decode(MoreProjectHeader.self, from: data) else {
        return
      }
      
      var headerProjectModel: ProjectHeaderModel
      headerProjectModel = parsedResponse.data
      self.onUpdateHeader?(headerProjectModel)
      self.isUpdating = false
      
    }
  }
  
  private func parseBody() {
    let id = self.id
    let url = "https://devcabinet.miem.vmnet.top/public-api/project/body/\(id)"
    session.request(url, method: .get).response {
      response in
      guard let data = response.data, let parsedResponse = try? JSONDecoder().decode(MoreProjectBody.self, from: data) else {
        return
      }
      
      var bodyProjectModel: ProjectBodyModel
      bodyProjectModel = parsedResponse.data
      self.onUpdateBody?(bodyProjectModel)
      self.isUpdating = false
      
    }
  }
  
  private func parseVacancy() {
    let id = self.id
    let url = "https://devcabinet.miem.vmnet.top/public-api/project/vacancies/\(id)"
    session.request(url, method: .get).response {
      response in
      guard let data = response.data, let parsedResponse = try? JSONDecoder().decode(MoreProjectsParsedVacancyInfo.self, from: data) else {
        return
      }
      var vacancyProjectModel = [VacancyInfoModel]()
      vacancyProjectModel = parsedResponse.data
      self.onUpdateVacancy?(vacancyProjectModel)
      self.isUpdating = false
      
    }
  }
  
  private func parseTeam() {
    let id = self.id
    let url = "https://devcabinet.miem.vmnet.top/public-api/project/students/\(id)"
    session.request(url, method: .get).response {
      response in
      guard let data = response.data, let parsedResponse = try? JSONDecoder().decode(MoreProjectTeam.self, from: data) else {
        return
      }
      
      var teamProjectModel: ProjectMemberResponseModel
      teamProjectModel = parsedResponse.data
      self.onUpdateTeam?(teamProjectModel)
      self.isUpdating = false
    }
  }
  
}
