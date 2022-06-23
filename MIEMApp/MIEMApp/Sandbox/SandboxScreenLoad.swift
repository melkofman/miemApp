//
//  SandboxScreenLoad.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 10.03.2022.
//

import Foundation
import UIKit
class SandboxSreenLoad: UIViewController, ScreenPayload, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchResultsUpdating {
  
  
  
  private unowned let wireframe: Wireframe
  var controller: UIViewController {
    self
  }
  var modelSandbox: [ListProjectInfoModel]?
  var collectionView: UICollectionView?
  var isFiltering = false
  var filteredProjects = [ListProjectInfoModel]()
  
  var openedOnce = false
  var check = true
  
  var lastContentsOffset: CGFloat = 0
  var offset: CGFloat = 0
  var scrolled = false
  
  
  private let bottomInset: Variable<CGFloat>
  init(wireframe: Wireframe, bottomInset: Variable<CGFloat>) {
    self.wireframe = wireframe
    self.bottomInset = bottomInset
    
    super.init(nibName: nil, bundle: nil)
    setUpComponent()
    
    
  }
  
  lazy var search: UISearchController = {
    let search = UISearchController()
    search.searchBar.placeholder = "Поиск"
    search.searchResultsUpdater = self
    
    search.obscuresBackgroundDuringPresentation = false
    search.searchBar.sizeToFit()
    search.searchBar.searchBarStyle = .default
    
    
    search.searchBar.delegate = self
    return search
  }()
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    if check {
      self.lastContentsOffset = scrollView.contentOffset.y
      offset = lastContentsOffset
      check = false
    }
    
    self.lastContentsOffset = scrollView.contentOffset.y
    
    if (self.lastContentsOffset != offset) {
      scrolled = true
    }
    if self.lastContentsOffset == offset {
      scrolled = false
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.setNavigationBarHidden(false, animated: animated)
    navigationItem.searchController = search
    
    if !openedOnce {
      navigationItem.hidesSearchBarWhenScrolling = false
      openedOnce = true
    }
    
    if !scrolled {
      navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    if scrolled {
      navigationItem.hidesSearchBarWhenScrolling = true
    }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if !scrolled {
      navigationItem.hidesSearchBarWhenScrolling = true
    } else {
      
      if !openedOnce {
        navigationItem.hidesSearchBarWhenScrolling = false
        openedOnce = true
      }
      
      if !scrolled {
        navigationItem.hidesSearchBarWhenScrolling = false
      }
      
      if scrolled {
        navigationItem.hidesSearchBarWhenScrolling = true
      }
    }
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    
    let searchText = searchController.searchBar.text!
    if !searchText.isEmpty {
      
      isFiltering = true
      filteredProjects.removeAll()
      for project in modelSandbox ?? [] {
        
        
        if (project.head.lowercased().contains(searchText.lowercased()) || project.typeDesc.lowercased().contains(searchText.lowercased()) || project.nameRus.lowercased().contains(searchText.lowercased()) || project.number.contains(searchText)) {
          filteredProjects.append(project)
        }
        
      }
    }
    
    collectionView?.reloadData()
  }
  
  func setUpComponent() {
    if #available(iOS 13.0, *) {
      self.view.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
      self.view.backgroundColor = Brandbook.Colors.grey
    }
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView?.delegate = self
    collectionView?.dataSource = self
    collectionView?.register(SandboxCell.self, forCellWithReuseIdentifier: SandboxCell.reusedId)
    collectionView?.translatesAutoresizingMaskIntoConstraints = false
    
    self.view.addSubview(collectionView!)
    if #available(iOS 13.0, *) {
      collectionView?.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
      collectionView?.backgroundColor = .white
    }
    collectionView?.topAnchor.constraint(equalTo: self.navigationController?.navigationBar.bottomAnchor ?? self.view.topAnchor).isActive = true
    collectionView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    collectionView?.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    collectionView?.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    collectionView?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if isFiltering {
      return filteredProjects.count
    }
    else {
      return modelSandbox?.count ?? 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: UIScreen.main.bounds.width - padding, height: 250)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let id: Int
    let nameRus: String
    let vacancyData: Int
    let status: String
    
    if isFiltering {
      id = Int(filteredProjects[indexPath.row].number) ?? 0
      nameRus = filteredProjects[indexPath.row].nameRus
      vacancyData = filteredProjects[indexPath.row].vacancies
      status = filteredProjects[indexPath.row].statusDesc
    } else {
      id = Int(modelSandbox![indexPath.row].number) ?? 0
      nameRus = modelSandbox![indexPath.row].nameRus
      vacancyData = modelSandbox![indexPath.row].vacancies
      status = modelSandbox![indexPath.row].statusDesc
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SandboxCell.reusedId, for: indexPath) as! SandboxCell
    
    var currentProject: ListProjectInfoModel?
    if isFiltering {
      currentProject = filteredProjects[indexPath.row]
    } else {
      currentProject = modelSandbox?[indexPath.row]
    }
    
    cell.idLabel.text = currentProject?.number
    cell.nameLabel.text = currentProject?.nameRus
    cell.headLabel.text = currentProject?.head
    cell.statusLabel.text = currentProject?.statusDesc
    if let status =  currentProject?.status {
      cell.status = status
      
      switch status {
      case SandboxStatus.new.rawValue:
        cell.statusLabel.backgroundColor = Brandbook.Colors.turquoiseStatus
      case SandboxStatus.revise.rawValue:
        cell.statusLabel.backgroundColor = Brandbook.Colors.lightBlueStatus
      case SandboxStatus.po_approved.rawValue:
        cell.statusLabel.backgroundColor = Brandbook.Colors.greenStatus
      case SandboxStatus.head_assigned.rawValue:
        cell.statusLabel.backgroundColor = Brandbook.Colors.greenStatus
      case SandboxStatus.passport_complete.rawValue:
        cell.statusLabel.backgroundColor = Brandbook.Colors.blueStatus
      case SandboxStatus.control_passed.rawValue:
        cell.statusLabel.backgroundColor = Brandbook.Colors.greenStatus
      case SandboxStatus.need_revision.rawValue:
        cell.statusLabel.backgroundColor = Brandbook.Colors.orangeStatus
        
      default:
        cell.statusLabel.backgroundColor = .white
      }
    }
    
    if let vacancy = modelSandbox?[indexPath.row].vacancies {
      let vacancyString = String(vacancy)
      cell.numVacancyLabel.text = (vacancyString + " вакансий(я)")
    }
    
    
    cell.managerTxt.text = "Руководитель: "
    cell.typeTxt.text = "Тип: "
    cell.typeLabel.text = modelSandbox?[indexPath.row].typeDesc
    cell.backgroundColor = .white
    
    return cell
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    isFiltering = false
    filteredProjects.removeAll()
    collectionView?.reloadData()
  }
  
}
private let padding = Brandbook.Paddings.normal
