//
//  StackContainerController.swift
//  TinderStack
//
//  Created by Ilya on 11.11.2021.
//

import UIKit


class StackContainerView: UIView, SwipeCardsDelegate {
  
  //MARK: - Properties
  var numberOfCardsToShow: Int = 0
  var cardsToBeVisible: Int = 3
  var cardViews : [SwipeCardView] = []
  var remainingCards: Int = 0
  
  let horizontalInset: CGFloat = 10.0
  let verticalInset: CGFloat = 10.0
  
  var likedCardsData: [CardDataModel] = []
  var visibleCards: [SwipeCardView] {
    return subviews as? [SwipeCardView] ?? []
  }
  var dataSource: SwipeCardsDataSource? {
    didSet {
      reloadData()
    }
  }
  //MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: .zero)
    backgroundColor = .clear
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  func reloadData() {
    likedCardsData = []
    removeAllCardViews()
    guard let datasource = dataSource else { return }
    setNeedsLayout()
    layoutIfNeeded()
    numberOfCardsToShow = datasource.numberOfCardsToShow()
    remainingCards = numberOfCardsToShow
    
    for i in 0..<min(numberOfCardsToShow,cardsToBeVisible) {
      addCardView(cardView: datasource.card(at: i), atIndex: i )
      
    }
  }
  
  //MARK: - Configurations
  
  private func addCardView(cardView: SwipeCardView, atIndex index: Int) {
    cardView.delegate = self
    addCardFrame(index: index, cardView: cardView)
    cardViews.append(cardView)
    insertSubview(cardView, at: 0)
    remainingCards -= 1
  }
  
  func addCardFrame(index: Int, cardView: SwipeCardView) {
    var cardViewFrame = bounds
    let horizontalInset = (CGFloat(index) * self.horizontalInset)
    let verticalInset = CGFloat(index) * self.verticalInset
    
    cardViewFrame.size.width -= 2 * horizontalInset
    cardViewFrame.origin.x += horizontalInset
    cardViewFrame.origin.y += verticalInset
    
    cardView.frame = cardViewFrame
  }
  
  private func removeAllCardViews() {
    for cardView in visibleCards {
      cardView.removeFromSuperview()
    }
    cardViews = []
  }
  
  func swipeDidEnd(on view: SwipeCardView, isLiked: Bool) {
    guard let datasource = dataSource else { return }
    if isLiked{
      guard let likedCardData = view.dataSource else {return}
      likedCardsData.append(likedCardData)
    }
    view.removeFromSuperview()
    if remainingCards > 0 {
      let newIndex = datasource.numberOfCardsToShow() - remainingCards
      addCardView(cardView: datasource.card(at: newIndex), atIndex: 2)
      for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
        UIView.animate(withDuration: 0.2, animations: {
          cardView.center = self.center
          self.addCardFrame(index: cardIndex, cardView: cardView)
          self.layoutIfNeeded()
        })
      }
      
    }else {
      for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
        UIView.animate(withDuration: 0.2, animations: {
          cardView.center = self.center
          self.addCardFrame(index: cardIndex, cardView: cardView)
          self.layoutIfNeeded()
        })
      }
    }
  }
  
}

