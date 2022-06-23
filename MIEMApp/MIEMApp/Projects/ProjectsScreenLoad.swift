//
//  ProjectsScreenLoad.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 03.11.2021.
//

import UIKit

private let padding = Brandbook.Paddings.normal

final class ProjectsScreenLoad: UIViewController, ScreenPayload, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchResultsUpdating {
  

  private unowned let wireframe: Wireframe
  var controller: UIViewController {
    self
  }
  
  private let refreshAction: () -> Void
  private let bottomInset: Variable<CGFloat>
  var model: [ProjectsListModel]?
  var types: [String]?
  var status: [String]?
  var vacancies: Bool?
  
  var type_filter: String?
  var status_filter: String?
  var vacancies_filter: Bool?
  
  var collectionView: UICollectionView?

  var isFiltering = false
  var filteredProjects = [ProjectsListModel]()
  var isFilter = false
  
  var openedOnce = false
  var check = true
  
  var lastContentsOffset: CGFloat = 0
  var offset: CGFloat = 0
  var scrolled = false
  
  let token: Property<String>
  
  init(wireframe: Wireframe, bottomInset: Variable<CGFloat>, refreshAction: @escaping () -> Void, token: Property<String>) {
    self.wireframe = wireframe
    self.bottomInset = bottomInset
    self.refreshAction = refreshAction
    self.token = token
    super.init(nibName: nil, bundle: nil)
    
    setupComponents()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  lazy var search: UISearchController = {
      let search = UISearchController()
      search.searchBar.placeholder = "Поиск по проекту"
      search.searchResultsUpdater = self
      
      search.obscuresBackgroundDuringPresentation = false
      search.searchBar.sizeToFit()
      search.searchBar.searchBarStyle = .default


      search.searchBar.delegate = self
      return search
  }()
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if isFiltering {
      return filteredProjects.count
    }
    else {
    return model?.count ?? 0
    }
  }
  
    func updateSearchResults(for searchController: UISearchController) {
      
      let searchText = searchController.searchBar.text!
      if !searchText.isEmpty {
        if isFilter {
          isFiltering = true
          filteredProjects.removeAll()
          for project in model ?? [] {
            
            if vacancies_filter == true && vacancies_filter != nil {
              
              if (project.head.lowercased().contains(searchText.lowercased()) || project.typeDesc.lowercased().contains(searchText.lowercased()) || project.nameRus.lowercased().contains(searchText.lowercased()) || ((project.number?.contains(searchText))) ?? (0 != 0)) && ((project.typeDesc == type_filter && project.statusDesc == status_filter) && project.vacancies > 0 || project.vacancies > 0 && (project.typeDesc != type_filter && project.statusDesc == status_filter) && type_filter == "Любой" || project.vacancies > 0 && (project.typeDesc == type_filter && project.statusDesc != status_filter) && status_filter == "Любой" || project.vacancies > 0 && status_filter == "Любой" && type_filter == "Любой"){
                filteredProjects.append(project)
              }
              
            } else {
              
              if (project.head.lowercased().contains(searchText.lowercased()) || project.typeDesc.lowercased().contains(searchText.lowercased()) || project.nameRus.lowercased().contains(searchText.lowercased()) || ((project.number?.contains(searchText))) ?? (0 != 0)) && ((project.typeDesc == type_filter && project.statusDesc == status_filter) || ((project.typeDesc != type_filter && project.statusDesc == status_filter) && type_filter == "Любой") || ((project.typeDesc == type_filter && project.statusDesc != status_filter) && status_filter == "Любой") || (status_filter == "Любой" && type_filter == "Любой")) {
                filteredProjects.append(project)
              }
            }
          }
          
        } else {
          
          isFiltering = true
          filteredProjects.removeAll()
          for project in model ?? [] {
            
            if vacancies_filter == true && vacancies_filter != nil {
              
              if (project.head.lowercased().contains(searchText.lowercased()) || project.typeDesc.lowercased().contains(searchText.lowercased()) || project.nameRus.lowercased().contains(searchText.lowercased()) || ((project.number?.contains(searchText))) ?? (0 != 0)) {
                filteredProjects.append(project)
              }
              
            } else {
              
              if (project.head.lowercased().contains(searchText.lowercased()) || project.typeDesc.lowercased().contains(searchText.lowercased()) || project.nameRus.lowercased().contains(searchText.lowercased()) || ((project.number?.contains(searchText))) ?? (0 != 0)) {
                filteredProjects.append(project)
              }
              
            }
          }
          
        }
        
      }


      collectionView?.reloadData()
    }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    isFiltering = false
    filteredProjects.removeAll()
    collectionView?.reloadData()
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: UIScreen.main.bounds.width - padding, height: 350)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let id: Int
    let nameRus: String
    let vacancyData: [String]
    let team: [String]
    let status: String
  
    if isFiltering {
      id = filteredProjects[indexPath.row].id
      nameRus = filteredProjects[indexPath.row].nameRus
      vacancyData = filteredProjects[indexPath.row].vacancyData
      team = filteredProjects[indexPath.row].team
      status = filteredProjects[indexPath.row].statusDesc
    } else {
      id = model![indexPath.row].id
      nameRus = model![indexPath.row].nameRus
      vacancyData = model![indexPath.row].vacancyData
      team = model![indexPath.row].team
      status = model![indexPath.row].statusDesc
    }
    
    let moreProjectGraph = MoreProjectsGraph(id: id, token: self.token)
    moreProjectGraph.setNeedsUpdate()

  
    self.modalPresentationStyle = .popover
    
    self.present(moreProjectGraph.getScreenLoad(), animated: true, completion: moreProjectGraph.getScreenLoad().reloadViews)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListProjectsGalleryCell.reusedId, for: indexPath) as! ListProjectsGalleryCell
    var currentProject: ProjectsListModel?
        if isFiltering {
          currentProject = filteredProjects[indexPath.row]
        } else {
          currentProject = model?[indexPath.row]
        }
        cell.idLabel.text = currentProject?.number
        cell.nameLabel.text = currentProject?.nameRus
        cell.headLabel.text = currentProject?.head
        cell.typeLabel.text = currentProject?.typeDesc
        cell.statusLabel.text = currentProject!.statusDesc
        cell.vacanciesLabel.text = ("\(currentProject!.vacancies) вакансий(я)")
        cell.managerTxt.text = "Руководитель: "
        cell.typeTxt.text = "Тип: "
        cell.backgroundColor = .white
        
    cell.nameLabel.heightAnchor.constraint(equalToConstant: ProjectsScreenLoad.height(text: cell.nameLabel.text, font: cell.nameLabel.font!, width: cell.frame.width).height).isActive = true
        
        return cell
  }
  
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
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: Brandbook.Images.Icons.filterIcon1, style: .done, target: self, action: #selector(open_filter))
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
  
  @objc
  func open_filter() {
    
    let filterViewController = FilterViewController(bottomInset: self.bottomInset, types: self.types ?? [], status: self.status ?? [], parentVC: self, token: self.token)
    self.modalPresentationStyle = .popover
    self.present(filterViewController, animated: false, completion: nil)
  }
  
  func filter(type: String, status: String, vacancy: Bool) {
  
    self.type_filter = type
    self.status_filter = status
    self.vacancies_filter = vacancy
    
    isFilter = true
    isFiltering = true
    filteredProjects.removeAll()
    for project in model ?? [] {
      
      if vacancy {
       
        if (project.typeDesc == type && project.statusDesc == status) && project.vacancies > 0 {
          filteredProjects.append(project)
        } else {
            if project.vacancies > 0 && (project.typeDesc != type && project.statusDesc == status) && type == "Любой"{
              filteredProjects.append(project)
            } else {
              if project.vacancies > 0 && (project.typeDesc == type && project.statusDesc != status) && status_filter == "Любой" {
                filteredProjects.append(project)
              } else {
                if project.vacancies > 0 && status == "Любой" && type == "Любой" {
                  filteredProjects.append(project)
                }
              }
            }
          }
       
      } else {
        
        if (project.typeDesc == type && project.statusDesc == status) {
          filteredProjects.append(project)
        } else {
            if (project.typeDesc != type && project.statusDesc == status) && type == "Любой"{
              filteredProjects.append(project)
            } else {
              if (project.typeDesc == type && project.statusDesc != status) && status == "Любой" {
                filteredProjects.append(project)
              } else {
                if status == "Любой" && type == "Любой" {
                  filteredProjects.append(project)
                }
              }
            }
          }
      }
    }
    
    collectionView?.reloadData()
    
  }
  
  func setupComponents() {
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    if #available(iOS 13.0, *) {
      self.view.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView?.delegate = self
    collectionView?.dataSource = self
    collectionView?.register(ListProjectsGalleryCell.self, forCellWithReuseIdentifier: ListProjectsGalleryCell.reusedId)
    collectionView?.translatesAutoresizingMaskIntoConstraints = false
    
    self.view.addSubview(collectionView!)
    if #available(iOS 13.0, *) {
      collectionView?.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    collectionView?.topAnchor.constraint(equalTo: self.navigationController?.navigationBar.bottomAnchor ?? self.view.topAnchor).isActive = true
    collectionView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    collectionView?.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    collectionView?.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    collectionView?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true


    
  }
  

  
  
  private func measureFrameForText(_ text: String) -> CGRect{
    let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
      let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
      return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
  }
  
  
  
  
}
extension ProjectsScreenLoad {

  static func height(text: String?, font: UIFont, width: CGFloat) -> CGRect {
      var currentHeight: CGRect!

      var textView  = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
      textView.text = text
      textView.font = font
      textView.sizeToFit()
      currentHeight = textView.frame

      return currentHeight
  }

}

