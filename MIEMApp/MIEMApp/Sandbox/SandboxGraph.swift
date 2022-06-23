//
//  SandboxGraph.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 10.03.2022.
//

import UIKit

final class SandboxGraph {
  let screen: Screen
  private let sandboxLoad: SandboxSreenLoad
  private let sandboxDataSource: SandboxDataSource
  
  init(wireframe: Wireframe, bottomInset: Variable<CGFloat>, user: Variable<User>,
       token: Property<String>) {
    sandboxDataSource = SandboxDataSource(user: user, token: token)
    
    sandboxLoad = SandboxSreenLoad(wireframe: wireframe, bottomInset: bottomInset)
    screen = Screen(id: .sandboxScreen, payload: sandboxLoad)
    sandboxDataSource.setOnUpdate { [unowned self] in
      sandboxLoad.modelSandbox = $0
      sandboxLoad.controller.reloadInputViews()
    }
    
  }
  
  func setNeedsUpdate() {
    sandboxDataSource.parseSandbox()
  }
}
