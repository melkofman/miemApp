//
//  ProjectsGraph.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 03.11.2021.
//

import UIKit

final class ProjectsGraph {
  let screen: Screen
  private let projectsLoad: ProjectsScreenLoad
  private let projectsDataSource: ProjectsDataSource
  
  init(wireframe: Wireframe,
       bottomInset: Variable<CGFloat>,
       user: Variable<User>,
       token: Property<String>
  ) {
    projectsDataSource = ProjectsDataSource(user: user, token: token)
    
    projectsLoad = ProjectsScreenLoad(wireframe: wireframe, bottomInset: bottomInset, refreshAction: projectsDataSource.setNeedsUpdate, token: token)
    screen = Screen(id: .projectsScreen, payload: projectsLoad)
    projectsDataSource.setOnUpdate { [unowned self] in
      self.projectsLoad.model = $0
      self.projectsLoad.collectionView?.reloadData()
    }
    
    projectsDataSource.setOnUpdateTypes { [unowned self] in
      self.projectsLoad.types = $0
    }
    
    projectsDataSource.setOnUpdateStatus { [unowned self] in
      self.projectsLoad.status = $0
    }
    
  }
  
  func setNeedsUpdate() {
    projectsDataSource.setNeedsUpdate()
  }
}

