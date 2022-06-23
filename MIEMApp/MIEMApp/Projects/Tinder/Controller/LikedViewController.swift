//
//  LikedViewController.swift
//  TinderStack
//
//  Created by Ilya on 16.11.2021.
//

import UIKit

private let padding = Brandbook.Paddings.normal
private let light = Brandbook.Paddings.light

class LikedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  
  
  var likedCardsData: [CardDataModel] = []
  var tableView: UITableView?
  var deleteIndex: IndexPath? = nil
  let token: Property<String>
  
  init(token: Property<String>) {
    self.token = token
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupComponents()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return likedCardsData.count
  }
  
  
  let noFavouriteLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .gray
    label.text = "Вам еще не понравился ни один проект :("
    if #available(iOS 13.0, *) {
      label.backgroundColor = Brandbook.Colors.dark_light
      label.textColor = Brandbook.Colors.dark_light_text_gray
    } else {
      // Fallback on earlier versions
      label.textColor = .gray
    }
    return label
  }()
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ListLikedGalleryCell.reusedId, for: indexPath) as! ListLikedGalleryCell
    let currentProject = LikedSettings.likedCards[indexPath.row]
    
    
    cell.idLabel.text = "\(currentProject.project_id)"
    cell.nameLabel.text = currentProject.project_name_rus
    cell.vacancyLbl.text = "Вакансия: "
    cell.vacancyLabel.text = currentProject.vacancy_role
    cell.backgroundColor = .white
    
    cell.nameLabel.heightAnchor.constraint(equalToConstant: LikedViewController.height(text: cell.nameLabel.text, font: cell.nameLabel.font!, width: cell.frame.width).height).isActive = true
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let id: Int
    id = likedCardsData[indexPath.row].project_id
    let moreProjectGraph = MoreProjectsGraph(id: id, token: self.token)
    moreProjectGraph.setNeedsUpdate()
    self.modalPresentationStyle = .popover
    
    self.present(moreProjectGraph.getScreenLoad(), animated: true, completion: moreProjectGraph.getScreenLoad().reloadViews)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 250
  }
  
  func setupComponents() {
    self.view.addSubview(noFavouriteLabel)
    noFavouriteLabel.topAnchor.constraint(equalTo: self.navigationController?.navigationBar.bottomAnchor ?? self.view.topAnchor, constant: padding).isActive = true
    noFavouriteLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: light).isActive = true
    noFavouriteLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: light).isActive = true
    
    if likedCardsData.isEmpty {
      noFavouriteLabel.heightAnchor.constraint(equalToConstant: measureFrameForText("Hello").height).isActive = true
    }
    else {
      noFavouriteLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
    }
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    if #available(iOS 13.0, *) {
      self.view.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    
    tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
    tableView?.delegate = self
    tableView?.dataSource = self
    tableView?.register(ListLikedGalleryCell.self, forCellReuseIdentifier: ListLikedGalleryCell.reusedId)
    tableView?.translatesAutoresizingMaskIntoConstraints = false
    
    self.view.addSubview(tableView!)
    if #available(iOS 13.0, *) {
      tableView?.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    tableView?.topAnchor.constraint(equalTo: noFavouriteLabel.bottomAnchor).isActive = true
    tableView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    tableView?.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    tableView?.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    tableView?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    
    
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      deleteIndex = indexPath
      confirmDelete()
    }
  }
  
  
  func confirmDelete() {
    let alert = UIAlertController(title: "Удалить из избранного", message: "Вы уверены, что хотите удалить проект из избранного?", preferredStyle: .actionSheet)
    
    let DeleteAction = UIAlertAction(title: "Удалить", style: .destructive, handler: handleDeleteProject)
    let CancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: cancelDeleteProject)
    
    alert.addAction(DeleteAction)
    alert.addAction(CancelAction)
    alert.popoverPresentationController?.sourceView = self.view
    
    self.present(alert, animated: true, completion: nil)
  }
  
  func cancelDeleteProject(alertAction: UIAlertAction!) {
    deleteIndex = nil
  }
  
  func handleDeleteProject(alertAction: UIAlertAction!) -> Void {
    if let indexPath = deleteIndex {
      tableView?.beginUpdates()
      likedCardsData.remove(at: indexPath.row)
      tableView?.deleteRows(at: [indexPath], with: .automatic)
      deleteIndex = nil
      
      tableView?.endUpdates()
      LikedSettings.likedCards = likedCardsData
      
    }
  }
  
  private func measureFrameForText(_ text: String) -> CGRect{
    let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
  }
  
  
}

extension LikedViewController {
  
  static func height(text: String?, font: UIFont, width: CGFloat) -> CGRect {
    var currentHeight: CGRect!
    
    let textView  = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    textView.text = text
    textView.font = font
    textView.sizeToFit()
    currentHeight = textView.frame
    
    return currentHeight
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    LikedSettings.likedCards = likedCardsData
  }
}
