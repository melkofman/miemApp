//
//  ProfileGraph.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 18.02.2021.
//

import UIKit
final class ProfileGraph {
  let screen: Screen
  private let profileLoad: ProfileScreenLoad
  private let profileDataSource: ProfileDataSource
  
  init(
    bottomInset: Variable<CGFloat>,
    user: Variable<User>,
    token: Property<String>
  ) {
     profileDataSource = ProfileDataSource(user: user, token: token)
    profileLoad = ProfileScreenLoad(bottomInset: bottomInset, refreshAction: profileDataSource.setNeedsUpdate, refreshActionAwards: profileDataSource.setNeedsUpdate)
    screen = Screen(id: .profileScreen, payload: profileLoad)
    profileDataSource.setOnUpdate { [unowned self] in
    self.profileLoad.modelProfile = $0
      
    }
    
    profileDataSource.setOnUpdateProject { [unowned self] in
    self.profileLoad.modelProject = $0
      
    }
    profileDataSource.setOnUpdateApplication {
      [unowned self] in
      self.profileLoad.modelApplication = $0
      
    }
    profileDataSource.setOnUpdateGitStat { [unowned self] in
      self.profileLoad.modelGitStat = $0
      self.profileLoad.collectionViewGit?.reloadData()
      self.profileLoad.endRefreshGit()
    }
    profileDataSource.setOnUpdateAwards { [unowned self] in
      self.profileLoad.modelAwards = $0
      self.profileLoad.collectionViewAwards?.reloadData()
      self.profileLoad.endRefreshAwards()

      }
  }
  
  func setNeedsUpdate() {
    profileDataSource.setNeedsUpdate()
  }
}
