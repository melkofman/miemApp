//
//  MoreProjectGraph.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 05.12.2021.
//

import UIKit
final class MoreProjectsGraph {
  
  private let moreProjectScreeLoad: MoreProjectScreenLoad
  private let moreProjectDataSource: MoreProjectDataSource
  let token: Property<String>
  
  
  init(id: Int, token: Property<String>)
  {
    self.token = token
    moreProjectDataSource = MoreProjectDataSource(id: id)
    
    moreProjectScreeLoad = MoreProjectScreenLoad(refreshAction: moreProjectDataSource.setNeedsUpdate, id: id, token: self.token)
    
    moreProjectDataSource.setOnUpdateHeader(onUpdate: { [unowned self] in
      self.moreProjectScreeLoad.modelHeader = $0
      self.moreProjectScreeLoad.controller.reloadInputViews()
    })
    
    moreProjectDataSource.setOnUpdateBody(onUpdate: { [unowned self] in
      self.moreProjectScreeLoad.modelBody = $0
      self.moreProjectScreeLoad.reloadViews()
    })
    
    moreProjectDataSource.setOnUpdateVacancy(onUpdate: {
      self.moreProjectScreeLoad.modelVacancy = $0
      self.moreProjectScreeLoad.reloadViews()
      
    })
    
    moreProjectDataSource.setOnUpdateTeam(onUpdate: { [unowned self] in
      self.moreProjectScreeLoad.modelTeam = $0
      self.moreProjectScreeLoad.reloadViews()
    })
  }
  
  
  func setNeedsUpdate() {
    moreProjectDataSource.setNeedsUpdate()
  }
  
  func getScreenLoad() -> MoreProjectScreenLoad {
    return self.moreProjectScreeLoad
  }
}
