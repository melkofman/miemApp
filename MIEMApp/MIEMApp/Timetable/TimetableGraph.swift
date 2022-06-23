//
//  TimetableGraph.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 10.01.2021.
//

import UIKit

final class TimetableGraph {
  let screen: Screen
  private let timetableLoad: TimetableScreenLoad
  private let timetableDataSource: TimetableDataSource
  
  init(
    bottomInset: Variable<CGFloat>,
    user: Variable<User>
  ) {
    let dates = Date().week
    timetableDataSource = TimetableDataSource(initialDates: dates, user: user)
    timetableLoad = TimetableScreenLoad(
      bottomInset: bottomInset,
      refreshAction: timetableDataSource.setNeedsUpdate,
      initialDates: dates,
      setDates: { [timetableDataSource] in
        timetableDataSource.dates = $0
      }
    )
    screen = Screen(id: .timetableScreen, payload: timetableLoad)
    timetableDataSource.setOnUpdate { [unowned self] in
      self.timetableLoad.model = $0
      
    }
  }
  
  func setNeedsUpdate() {
    timetableDataSource.setNeedsUpdate()
  }
}
