//
//  ProjectsCollectionView.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 21.02.2021.
//

import UIKit

class ProjectsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  

  var cells = [ProjectItemModel]()
  
  init() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 2*Brandbook.Paddings.small
    super.init(frame: .zero, collectionViewLayout: layout)
    contentInset = UIEdgeInsets(top: 0, left: Brandbook.Paddings.normal, bottom: 0, right: Brandbook.Paddings.normal)
    showsHorizontalScrollIndicator = false
    showsVerticalScrollIndicator = false
    delegate = self
    dataSource = self
    backgroundColor = .clear
    register(ProjectCell.self, forCellWithReuseIdentifier: ProjectCell.reuseId)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cells.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = dequeueReusableCell(withReuseIdentifier: ProjectCell.reuseId, for: indexPath) as! ProjectCell
    
     if let number = cells[indexPath.row].number {
      cell.labelNumber.text = number
    }
    cell.labelName.text = cells[indexPath.row].nameRus
    cell.labelStatus.text = cells[indexPath.row].status
    cell.labelType.text = ("Тип: " + cells[indexPath.row].type)
    cell.labelHead.text = ("Руководитель: " + cells[indexPath.row].head)
    cell.labelRole.text = ("Роль: " + cells[indexPath.row].role)
    cell.labelPart.text = ("Участники: " + String(cells[indexPath.row].team.count))
    
    cell.labelHours.text = ("Часы: " + String(cells[indexPath.row].hoursCount))
    if cells[indexPath.row].status == "В архиве" {
      cell.labelStatus.backgroundColor = Brandbook.Colors.grey
    }
    cell.setUp()
    
    return cell
  }
  

  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 250, height: frame.height-4)
  }
  
  func set(cells: [ProjectItemModel]) {
    self.cells = cells
  }
}
