//
//  ApplicationCokkectionView.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 21.02.2021.
//

import UIKit

class ApplicationCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  
  var cells = [ApplicationItemModel]()
  var moreViewController = UIViewController()
  var height: CGFloat
  var parent: ProfileScreenLoad?
  var indexCell: Int?
  
  init() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 2*Brandbook.Paddings.small
    self.height = 250
    super.init(frame: .zero, collectionViewLayout: layout)
    contentInset = UIEdgeInsets(top: 0, left: Brandbook.Paddings.normal, bottom: 0, right: Brandbook.Paddings.normal)
    showsHorizontalScrollIndicator = false
    showsVerticalScrollIndicator = false
    delegate = self
    dataSource = self
    backgroundColor = .clear
    register(ApplicationCell.self, forCellWithReuseIdentifier: ApplicationCell.reuseId)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cells.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = dequeueReusableCell(withReuseIdentifier: ApplicationCell.reuseId, for: indexPath) as! ApplicationCell
    cell.labelName.text = cells[indexPath.row].name
    cell.groupLabel.text = cells[indexPath.row].group
    cell.studentComment.text = cells[indexPath.row].studentComment
    cell.leaderComment.text = cells[indexPath.row].leaderComment
    cell.roleLabel.text = cells[indexPath.row].role
    cell.projectNameLabel.text = cells[indexPath.row].nameRus
    cell.leaderNameLabel.text = cells[indexPath.row].head
    cell.moreButton.addTarget(self, action: #selector(openApplicationMore), for: .touchUpInside)
    self.indexCell = indexPath.row
    cell.setup()
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 250, height: frame.height)
  }
  
  func set(cells: [ApplicationItemModel]) {
    self.cells = cells
  }
  
  func setParent(parent: ProfileScreenLoad) {
    self.parent = parent
  }
  
  @objc
  func openApplicationMore() {

    if self.indexCell != nil {
      let project_name = cells[self.indexCell!].nameRus
      let name = cells[self.indexCell!].name
      let email = cells[self.indexCell!].email
      let studentComment = cells[self.indexCell!].studentComment
      let leaderComment = cells[self.indexCell!].leaderComment
      let group = cells[self.indexCell!].group
      let role = cells[self.indexCell!].role
      let leader = cells[self.indexCell!].head
      parent?.open(project_name: project_name, name: name, email: email, studentComment: studentComment, leaderComment: leaderComment, group: group, role: role, leader: leader)
      }
      else {
        return
      }
  
  }
}

