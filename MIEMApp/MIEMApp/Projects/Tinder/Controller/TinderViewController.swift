
//
//  ViewController.swift
//  TinderStack
//
//  Created by Ilya on 11.11.2021.
//

import UIKit

class TinderViewController: UIViewController {

    //MARK: - Properties
    
    var viewModelData: [CardDataModel] = []
    var stackContainer: StackContainerView!
    let token: Property<String>
  init(token: Property<String> ) {
    self.token = token
    super.init(nibName: nil, bundle: nil)
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
    //MARK: - Init
    
    override func loadView() {
        view = UIView()
      view.backgroundColor = UIColor(patternImage: Brandbook.Images.Icons.tinderBackground2)
        stackContainer = StackContainerView()
        view.addSubview(stackContainer)
        configureStackContainer()
        view.addSubview(resetButton)
        setupResetButton()
        view.addSubview(likedButton)
        setupLikedButton()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        stackContainer.dataSource = self
        fetchData(from: "https://devcabinet.miem.vmnet.top/public-api/vacancy/list")
    }
    
 
    //MARK: - Make UI Elements
    
    let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Сбросить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Brandbook.Colors.blueColor
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(resetButtonAction), for: .touchDown)
        return button
    }()
    
    let likedButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Избранное", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Brandbook.Colors.blueColor
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(likedButtonAction), for: .touchDown)
        return button
    }()
    
    //MARK: - Setup UI Elements
    
    func configureStackContainer() {
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        stackContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive = true
        stackContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 400).isActive = true
    }
    
    
    func setupResetButton(){
        resetButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        resetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        resetButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/5).isActive = true
    }
    
    func setupLikedButton(){
        likedButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        likedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        likedButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        likedButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/5).isActive = true
    }
    
    //MARK: - Setup UI Actions
    
    @objc func resetButtonAction() {
        stackContainer.reloadData()
      LikedSettings.clear()
    }
  
    @objc func likedButtonAction() {
      let vc = LikedViewController(token: self.token)
      var array = stackContainer.likedCardsData
      var uniqueCards: [CardDataModel] = []
      
      if let likedDefault = LikedSettings.likedCards {
        
        for element in stackContainer.likedCardsData {
          if !likedDefault.contains(where: { $0 == element }) {
            uniqueCards.append(element)
          }
        }
        
        array = uniqueCards + likedDefault
        
        
      }
      LikedSettings.likedCards = array
      vc.likedCardsData = array
        present(vc, animated: true, completion: nil)
    }
    
  
  
  
    //MARK: - Fetch Data
    
    private func fetchData(from url: String) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            DispatchQueue.main.async {
                do {
                    let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                    self.viewModelData = apiResponse.data
                    self.stackContainer.reloadData()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}


extension TinderViewController : SwipeCardsDataSource {
    
    func numberOfCardsToShow() -> Int {
        return viewModelData.count
    }
    
    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.dataSource = viewModelData[index]
        return card
    }
    
    func emptyView() -> UIView? {
        return nil
    }
    
}
