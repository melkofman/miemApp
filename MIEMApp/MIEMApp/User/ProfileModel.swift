//
//  ProfileModel.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 30.04.2021.
//

import Foundation

struct ProfileItemModel: Decodable, Equatable {
  let main: ProfileInfo
}
struct ProfileInfo: Decodable, Equatable {
  let group: String
  let email: String
  let name: String
  let chatLink: String
  let pic: String
  let showAchievements: Bool
  let studentId: Int
}

struct ProfileParsedModel: Equatable {
  let status: String
  let items: ProfileInfo
}
