//
//  SwipeCardsDataSource.swift
//  TinderStack
//
//  Created by Ilya on 11.11.2021.
//

import UIKit

protocol SwipeCardsDataSource {
  func numberOfCardsToShow() -> Int
  func card(at index: Int) -> SwipeCardView
  func emptyView() -> UIView?
}

protocol SwipeCardsDelegate {
  func swipeDidEnd(on view: SwipeCardView,isLiked: Bool)
}
