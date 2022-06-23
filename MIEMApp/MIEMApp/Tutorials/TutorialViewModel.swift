//
//  TutorialViewModel.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 14.03.2021.
//

import UIKit

struct TutorialViewModel {
  let pages: [TutorialPageViewModel]
}

struct TutorialPageViewModel {
  let image: UIImage
  let title: String
  let text: String
}
