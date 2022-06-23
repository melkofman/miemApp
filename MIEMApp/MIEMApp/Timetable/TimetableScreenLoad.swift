//
//  TimetableScreenLoad.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 10.01.2021.
//

import UIKit

final class TimetableScreenLoad: UICollectionViewController, UICollectionViewDelegateFlowLayout, ScreenPayload {
  private let bottomInset: Variable<CGFloat>
  private let refreshAction: () -> Void
  private let setDates: ((Date, Date)) -> Void
  private let layout: UICollectionViewFlowLayout
  private let picker = DatePickerView()
  private let touchDetector = TouchDetectingView()
  private var dates: (Date, Date)
  
  var model: [TimetableDayModel]? {
    didSet {
      guard !collectionView.isDragging else {
        return
      }
      endRefresh()
    }
  }
  
  private var dateHeaderHeight: CGFloat = 0 {
    didSet {
      touchDetector.frame = CGRect(
        x: 0,
        y: dateHeaderHeight,
        width: view.bounds.width,
        height: view.bounds.height - dateHeaderHeight
      )
    }
  }
  
  var controller: UIViewController {
    self
  }
  
  private var pickerFrame: CGRect {
    CGRect(
      x: 0,
      y: view.bounds.height - pickerHeight - bottomInset.value,
      width: view.bounds.width,
      height: pickerHeight
    )
  }
  
  init(
    bottomInset: Variable<CGFloat>,
    refreshAction: @escaping () -> Void,
    initialDates: (Date, Date),
    setDates: @escaping ((Date, Date)) -> Void
  ) {
    self.bottomInset = bottomInset
    self.refreshAction = refreshAction
    self.dates = initialDates
    self.setDates = setDates
    layout = UICollectionViewFlowLayout()
    super.init(collectionViewLayout: layout)
    collectionView.contentInsetAdjustmentBehavior = .never
    collectionView.showsVerticalScrollIndicator = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.register(TimetableItemCell.self, forCellWithReuseIdentifier: timetableItemCellIdentifier)
    collectionView.register(
      TimetableSectionHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: timetableSectionHeaderIdentifier
    )
    collectionView.register(
      TimetableDatesHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: timetableDatesHeaderIdentifier
    )
    if #available(iOS 13.0, *) {
      collectionView.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    collectionView.refreshControl = UIRefreshControl()
    collectionView.refreshControl?.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset.value, right: 0)
    
    view.addSubview(touchDetector)
    touchDetector.setAction { [weak self] in
      self?.animatePicker(isOpening: false, completion: {
        self?.picker.reset()
      })
    }
    view.addSubview(picker)
  }
  
  @objc private func refreshControlAction() {
    refreshAction()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if model == nil {
      collectionView.refreshControl?.beginRefreshing()
    }
  }
  
  override func viewWillLayoutSubviews() {
    let availableWidth = collectionView.bounds.width - CGFloat(padding * (elementsInRow + 1))
    let widthPerItem = floor(availableWidth / elementsInRow)
    layout.estimatedItemSize = CGSize(width: widthPerItem, height: 10)
    picker.frame = pickerFrame.offsetBy(dx: 0, dy: pickerHeight + bottomInset.value)
    super.viewWillLayoutSubviews()
  }
  
  override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    guard let isRefreshing = collectionView.refreshControl?.isRefreshing, isRefreshing else {
      return
    }
    endRefresh()
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return (model?.count ?? 0) + 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return section == 0 ? 0 : model?[section - 1].items.count ?? 0
  }
  
  override func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: timetableItemCellIdentifier,
      for: indexPath
    ) as! TimetableItemCell
    guard indexPath.section != 0 else {
      return cell
    }
    cell.model = model?[indexPath.section - 1].items[indexPath.item]
    return cell
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return section == 0
      ? UIEdgeInsets(top: 0, left: 0, bottom: padding, right: 0)
      : UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return padding
  }
  
  override func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: indexPath.section == 0 ? timetableDatesHeaderIdentifier : timetableSectionHeaderIdentifier,
      for: indexPath
    )
    if indexPath.section == 0 {
      let datesView = header as! TimetableDatesHeader
      datesView.label.text = makeDatesRangeString(dates)
      datesView.action = {
        self.animatePicker(isOpening: true)
        self.picker.start { [weak self] in
          datesView.label.text = makeDatesRangeString($0)
          self?.dates = $0
          self?.collectionView.refreshControl?.beginRefreshing()
          self?.animatePicker(isOpening: false, completion: {
            self?.picker.reset()
          })
          self?.setDates($0)
        }
      }
      return datesView
    } else {
      let headerView = header as! TimetableSectionHeader
      guard let dayOfWeek = model?[indexPath.section - 1].dayOfWeek, let date = model?[indexPath.section - 1].date else {
        return headerView
      }
      headerView.label.text = "\(dayOfWeek), \(date.string(format: "d MMMM"))"
      return headerView
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    let indexPath = IndexPath(row: 0, section: section)
    let headerView = self.collectionView(
      collectionView,
      viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
      at: indexPath
    )
    let size = headerView.systemLayoutSizeFitting(
      CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .fittingSizeLevel
    )
    dateHeaderHeight = size.height
    return size
  }
  
  private func endRefresh() {
    collectionView.reloadData()
    collectionView.refreshControl?.endRefreshing()
  }
  
  private func animatePicker(isOpening: Bool, completion: (() -> Void)? = nil) {
    UIView.animate(
      withDuration: Brandbook.Durations.normal,
      animations: {
        self.picker.frame = isOpening
          ? self.pickerFrame
          : self.pickerFrame.offsetBy(dx: 0, dy: pickerHeight + self.bottomInset.value)
      },
      completion: { _ in
        completion?()
      }
    )
  }
}

private func makeDatesRangeString(_ dates: (Date, Date)) -> String {
  let format = "dd-MM-yyyy"
  return "\(dates.0.string(format: format)) – \(dates.1.string(format: format))"
}

private let timetableItemCellIdentifier = "TimetableItemCellIdentifier"
private let timetableSectionHeaderIdentifier = "TimetableSectionHeaderIdentifier"
private let timetableDatesHeaderIdentifier = "TimetableDatesHeaderIdentifier"
private let padding = Brandbook.Paddings.normal
private let elementsInRow: CGFloat = 1
private let pickerHeight: CGFloat = 200
