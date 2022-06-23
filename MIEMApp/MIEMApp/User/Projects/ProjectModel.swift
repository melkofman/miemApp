//
//  ProjectModel.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 21.02.2021.
//

import UIKit

struct ProjectItemModel: Decodable, Equatable {
  let status: String
  let nameRus: String
  let head: String
  let type: String
  let team: [String]
  let number: String?
  let role: String
  let hoursCount: Int
  
  
  
//  static func fetchProjects(projectsModel: [ProjectParsedModel]) -> [ProjectItemModel] {
  static func fetchProjects(projectsModel: [ProjectItemModel]) -> [ProjectItemModel] {
    var projects = [ProjectItemModel]()
    for project in projectsModel {

      let projectInfo = project

      
//      projects.append(ProjectItemModel(status: projectInfo.status, nameRus: projectInfo.nameRus, head: projectInfo.head, type: projectInfo.type, team: projectInfo.team, number: projectInfo.number, role: projectInfo.role))
      
      projects.append(ProjectItemModel(status: projectInfo.status, nameRus: projectInfo.nameRus, head: projectInfo.head, type: projectInfo.type, team: projectInfo.team, number: projectInfo.number, role: projectInfo.role, hoursCount: projectInfo.hoursCount))
    }
    return projects
  }
}

struct ProjectAndApplicationModel: Decodable, Equatable {
  let projects: [ProjectItemModel]
  let applications: [ApplicationItemModel]
  let archive: [ProjectItemModel]
}

struct ProjectStaffModel: Decodable, Equatable {
  let projects: [ProjectItemModel]
}

struct ProjectParsedModel: Decodable, Equatable {
  let data: [ProjectItemModel]
}

struct StaffParsedProjectsModel: Decodable, Equatable {
  let items: ProjectItemModel
}



