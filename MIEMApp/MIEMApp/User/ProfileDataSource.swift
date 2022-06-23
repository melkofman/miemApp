//
//  ProfileDataSource.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 12.03.2021.
//

import UIKit
import Alamofire

private struct ProfileResponse: Decodable {
  let data: [ProfileItemModel]
}

private struct ApplicationResponse: Decodable {
  let data: ProjectAndApplicationModel
}

private struct ProjectStaffResponse: Decodable {
  let data: ProjectStaffModel
}

private struct ApplicationStaffResponse: Decodable {
  let data: ApplicationParsedModel
}

struct GitStatistics: Decodable, Equatable {
  let data: GitInfoModel
}

struct GitInfoModel: Decodable, Equatable {
  let stat: GitStat
}

struct GitStat: Decodable, Equatable {
  let projects: [ProjectGitModel]
}

struct ProjectGitModel: Decodable, Equatable {
  let name: String
  let commitCount: Int
}

struct AwardsModel: Decodable, Equatable {
  let data: [AwardsItemModel]
}


struct AwardsItemModel: Decodable, Equatable {
  let name: String
  let award_condition_description: String
  let image: String
  let progress: Double
}

final class ProfileDataSource {
  private let session = makeDefaultSession()
  private let user: Variable<User>
  private let token: Property<String>
  
  private var onUpdate: (([ProfileParsedModel]) -> Void)?
  private var onUpdateProject: (([ProjectItemModel]) -> Void)?
  private var onUpdateApplication: (([ApplicationParsedModel]) -> Void)?
  private var onUpdateGitStat: ((GitStat) -> Void)?
  private var onUpdateAwards: ((AwardsModel) -> Void)?
  private var isUpdating: Bool = false
  private var showAwards: Bool = true
  private var userId: Int = 0
  
  init(user: Variable<User>, token: Property<String>) {
    self.user = user
    self.token = token
  }
  
  func setOnUpdate(onUpdate: @escaping ([ProfileParsedModel]) -> Void) {
    self.onUpdate = onUpdate
    
  }
  
  func setOnUpdateProject(onUpdateProject: @escaping ([ProjectItemModel]) -> Void) {
    self.onUpdateProject = onUpdateProject
  }
  
  func setOnUpdateApplication(onUpdateApplication: @escaping ([ApplicationParsedModel]) -> Void) {
    self.onUpdateApplication = onUpdateApplication
  }
  
  func setOnUpdateGitStat(onUpdate: @escaping (GitStat) -> Void) {
    self.onUpdateGitStat = onUpdate
  }
  
  func setOnUpdateAwards(onUpdate: @escaping (AwardsModel) -> Void) {
    self.onUpdateAwards = onUpdate
  }
  
  
  
  func setNeedsUpdate() {
    guard !isUpdating else {
      return
    }
    update()
  }
  
  private func update() {
    isUpdating = true
    if (user.value.student) {
      profileInfoRequestStudent()
      applicationRequestStudent()
      getGitStatistics()
      if showAwards {
        getUserAwards(user_id: self.userId)
      }
    }
    else {
      profileInfoRequestStaff()
      ProjectsStaff()
      ApplicationsStaff()
      
    }
    self.isUpdating = false
  }
  
  private func profileInfoRequestStudent() {
    let headers: HTTPHeaders = ["x-auth-token": self.token.value]
    session.request("https://devcabinet.miem.vmnet.top/api/student_profile", method: .get, headers: headers).response { response in
      guard let data = response.data, let parsedResponse = try? JSONDecoder().decode(ProfileResponse.self, from: data) else {
        return
      }
      
      self.showAwards = parsedResponse.data[0].main.showAchievements
      self.userId = parsedResponse.data[0].main.studentId
      var profileModel = [ProfileParsedModel]()
      var currentInfo: ProfileInfo
      currentInfo = parsedResponse.data[0].main
      profileModel.append(ProfileParsedModel(status: "Студент", items: currentInfo))
      self.onUpdate?(profileModel)
    }
    
  }
  
  private func applicationRequestStudent() {
    
    let headers: HTTPHeaders = ["x-auth-token": self.token.value]
    let url = "https://devcabinet.miem.vmnet.top/api/student/projects/and/applications/my"
    session.request(url, method: .get, headers: headers).response { response in
      guard let data = response.data, let parsedResponse = try? JSONDecoder().decode(ApplicationResponse.self, from: data) else {
        return
      }
      
      var projectData = [ProjectItemModel]()
      for i in parsedResponse.data.projects {
        projectData.append(i)
      }
      
      for i in parsedResponse.data.archive {
        projectData.append(i)
      }
      self.onUpdateProject?(projectData)
      
      
      //applications
      var applicatoionsModel = [ApplicationParsedModel]()
      var applicationData = [ApplicationItemModel]()
      for info in parsedResponse.data.applications {
        applicationData.append(info)
      }
      
      applicatoionsModel.append(ApplicationParsedModel(data: applicationData))
      
      self.onUpdateApplication?(applicatoionsModel)
      
    }
  }
  
  private func profileInfoRequestStaff() {
    let headers: HTTPHeaders = ["x-auth-token": self.token.value]
    session.request("https://devcabinet.miem.vmnet.top/api/teacher_profile", method: .get, headers: headers).response
    { response in
      guard let data = response.data, let parsedResponse = try? JSONDecoder().decode(ProfileResponse.self, from: data) else {
        
        return
      }
      var profileModel = [ProfileParsedModel]()
      var currentInfo: ProfileInfo
      currentInfo = parsedResponse.data[0].main
      profileModel.append(ProfileParsedModel(status: "Руководитель", items: currentInfo))
      self.onUpdate?(profileModel)
    }
    
    
  }
  
  private func ProjectsStaff() {
    let headers: HTTPHeaders = ["x-auth-token": self.token.value]
    session.request("https://devcabinet.miem.vmnet.top/api/leader/projects/my", method: .get, headers: headers).response { response in
      guard let data = response.data, let parsedResponse = try? JSONDecoder().decode(ProjectStaffResponse.self, from: data) else {
        return
      }
      
      var projectModel = [ProjectParsedModel]()
      var currentInfo = [ProjectItemModel]()
      for i in parsedResponse.data.projects {
        currentInfo.append(i)
        
      }
      projectModel.append(ProjectParsedModel(data: currentInfo))
      
    }
    
  }
  
  private func ApplicationsStaff() {
    let headers: HTTPHeaders = ["x-auth-token": self.token.value]
    session.request("https://devcabinet.miem.vmnet.top/api/leader/application/my", method: .get, headers: headers).response {
      response in
      guard let data = response.data, let parsedResponse = try? JSONDecoder().decode(ApplicationStaffResponse.self, from: data) else {
        return
      }
      var applicatoionsModel = [ApplicationParsedModel]()
      var applicationData = [ApplicationItemModel]()
      for info in parsedResponse.data.data {
        applicationData.append(info)
      }
      
      applicatoionsModel.append(ApplicationParsedModel(data: applicationData))
      self.onUpdateApplication?(applicatoionsModel)
      self.isUpdating = false
    }
  }
  
  private func getGitStatistics() {
    let headers: HTTPHeaders = ["x-auth-token": self.token.value]
    session.request("https://devcabinet.miem.vmnet.top/api/student_statistics/git/my", method: .get, headers: headers).response {
      response in
      guard let data = response.data, let parsedResponse = try? JSONDecoder().decode(GitStatistics.self, from: data) else {
        return
      }
      var gitStatModel: GitStat
      gitStatModel = parsedResponse.data.stat
      self.onUpdateGitStat?(gitStatModel)
      self.isUpdating = false
      
    }
  }
  
  private func getUserAwards(user_id: Int) {
    session.request("https://devcabinet.miem.vmnet.top/public-api/badge/user/\(user_id)/progress", method: .get).response {
      response in
      guard let data = response.data, let parsedResponse = try? JSONDecoder().decode(AwardsModel.self, from: data) else {
        return
      }
      var awardsModel: AwardsModel
      awardsModel = parsedResponse
      self.onUpdateAwards?(awardsModel)
      self.isUpdating = false
      
    }
  }
  
}
