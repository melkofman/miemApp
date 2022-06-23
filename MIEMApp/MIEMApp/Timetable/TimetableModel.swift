//
//  TimetableModel.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 10.01.2021.
//

import Foundation


struct TimetableDayModel: Equatable {
  let date: Date?
  let dayOfWeek: String
  let items: [TimetableItemModel]
}
