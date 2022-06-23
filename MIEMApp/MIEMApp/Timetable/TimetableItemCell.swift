//
//  TimetableItemCell.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 10.01.2021.
//

import UIKit

final class TimetableItemCell: UICollectionViewCell {
  private let mainStack: UIStackView
  private let timeStack: UIStackView
  private let infoStack: UIStackView
  private let wrapperTimeStack: UIStackView
  private let wrapperInfoStack: UIStackView
  private let placeLabel = makeLabel()
  private let lessonNumberLabel = makeLabel()
  private let beginLessonLabel = makeLabel()
  private let endLessonLabel = makeLabel()
  private let disciplineLabel = makeLabel()
  private let kindOfWorkLabel = makeLabel()
  private let lecturerLabel = makeLabel()
  
  private lazy var width: NSLayoutConstraint = {
      let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
      width.isActive = true
      return width
  }()
  
  var model: TimetableItemModel? {
    didSet {
      updateView()
    }
  }
  
  override init(frame: CGRect) {
    timeStack = UIStackView(arrangedSubviews: [
      beginLessonLabel,
      endLessonLabel,
      lessonNumberLabel,
    ])
    infoStack = UIStackView(arrangedSubviews: [
      disciplineLabel,
      kindOfWorkLabel,
      placeLabel,
      lecturerLabel,
    ])
    wrapperTimeStack = UIStackView(arrangedSubviews: [timeStack])
    wrapperInfoStack = UIStackView(arrangedSubviews: [infoStack])
    mainStack = UIStackView(arrangedSubviews: [
      wrapperTimeStack,
      wrapperInfoStack,
    ])
    super.init(frame: frame)
    setUpConstraints()
    setUpLabels()
  }
      
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func systemLayoutSizeFitting(
    _ targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority
  ) -> CGSize {
    width.constant = bounds.size.width
    return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
  }
  
  private func setUpConstraints() {
    timeStack.axis = .vertical
    timeStack.spacing = smallPadding
    infoStack.axis = .vertical
    infoStack.spacing = smallPadding
    wrapperTimeStack.alignment = .top
    wrapperInfoStack.alignment = .top
    mainStack.spacing = padding
    contentView.translatesAutoresizingMaskIntoConstraints = false
    mainStack.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(mainStack)
    mainStack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    mainStack.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    wrapperTimeStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor, multiplier: 1.2 / widthParts).isActive = true
    if let lastSubview = contentView.subviews.last {
      contentView.bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor, constant: 10).isActive = true
    }
  }
  
  private func setUpLabels() {
    lessonNumberLabel.textColor = Brandbook.Colors.grey
    disciplineLabel.font = disciplineLabel.font.withSize(Brandbook.TextSize.small)
    
    beginLessonLabel.font = beginLessonLabel.font.bold
    beginLessonLabel.font = beginLessonLabel.font.withSize(Brandbook.TextSize.largeNormal)
    
    endLessonLabel.font = endLessonLabel.font.bold
    endLessonLabel.font = endLessonLabel.font.withSize(Brandbook.TextSize.largeNormal)
    
    disciplineLabel.textColor = Brandbook.Colors.tint
    disciplineLabel.font = disciplineLabel.font.withSize(Brandbook.TextSize.large).bold
    
    kindOfWorkLabel.font = kindOfWorkLabel.font.bold
    lecturerLabel.textColor = Brandbook.Colors.grey
  }
  
  private func updateView() {
    guard let model = model else {
      return
    }
    lessonNumberLabel.text = "\(model.lessonNumberStart) пара"
    beginLessonLabel.text = model.beginLesson
    endLessonLabel.text = model.endLesson
    placeLabel.text = "\(model.auditorium) (\(model.building))"
    disciplineLabel.text = model.discipline
    kindOfWorkLabel.text = model.kindOfWork
    lecturerLabel.text = model.lecturer
  }
}

private let widthParts: CGFloat = 7
private let smallPadding = Brandbook.Paddings.small
private let padding = Brandbook.Paddings.normal

private func makeLabel() -> UILabel {
  let label = UILabel()
  label.numberOfLines = 0
  label.font = label.font.withSize(Brandbook.TextSize.normal)
  return label
}
