//
//  CardsDataModel.swift
//  TinderStack
//
//  Created by Ilya on 11.11.2021.
//

import UIKit

struct ApiResponse: Decodable {
  
  var data: [CardDataModel]
  
  init(data: [CardDataModel]) {
    self.data = data
  }
}

struct CardDataModel: Decodable, Encodable, Equatable {
  
  var project_id: Int
  var project_name_rus: String
  var vacancy_role: String
  var vacancy_disciplines: [String]
  
  
  init(project_id: Int,
       project_name_rus: String,
       vacancy_role: String,
       vacancy_disciplines: [String]) {
    
    self.project_id = project_id
    self.project_name_rus = project_name_rus
    self.vacancy_role = vacancy_role
    self.vacancy_disciplines = vacancy_disciplines
  }
}
