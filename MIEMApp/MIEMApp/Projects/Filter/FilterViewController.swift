//
//  FilterViewController.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 17.11.2021.
//

import UIKit
import BEMCheckBox

class FilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, BEMCheckBoxDelegate {
  
  
  private let bottomInset: Variable<CGFloat>
  var selectedType: String?
  var selectedStatus: String?
  var vacancyFlag: Bool?
  var types = [String]()
  var status = [String]()
  var isType: Bool? //for picker
  let parentVC: ProjectsScreenLoad?
  let token: Property<String>
  
  
  
  var group:BEMCheckBoxGroup!
  
  init(bottomInset: Variable<CGFloat>, types: [String], status: [String], parentVC: ProjectsScreenLoad, token: Property<String>) {
    self.bottomInset = bottomInset
    self.types = types
    self.status = status
    self.parentVC = parentVC
    self.token = token
    
    super.init(nibName: nil, bundle: nil)
    picker.delegate = self
    picker.dataSource = self
    setUp()
    initialize()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  var controller: UIViewController {
    self
  }
  
  let filterLabel: UILabel = {
    let label = UILabel()
    label.text = "Фильтры"
    label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.enormous, weight: .bold)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  
  
  let typePickerLabel: UILabel = {
    let label = UILabel()
    label.text = "Тип проекта"
    label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.normal)
    label.textColor = UIColor.gray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let typeTextField: UITextField = {
    let textField = UITextField()
    textField.attributedPlaceholder = NSAttributedString(string: "Любой", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    textField.addTarget(self, action: #selector(typePickerHandled), for: .touchDown)
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.backgroundColor = Brandbook.Colors.lightGray
    textField.layoutMargins = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    textField.textAlignment = NSTextAlignment.center
    textField.clipsToBounds = true
    textField.layer.cornerRadius = 6
    return textField
  }()
  
  let picker: UIPickerView = {
    let picker = UIPickerView()
    return picker
  }()
  
  let statusPickerLabel: UILabel = {
    let label = UILabel()
    label.text = "Статус проекта"
    label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.normal)
    label.textColor = UIColor.gray
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .left
    return label
  }()
  
  let statusTextField: UITextField = {
    let textField = UITextField()
    textField.attributedPlaceholder = NSAttributedString(string: "Любой", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    textField.addTarget(self, action: #selector(statusPickerHandle), for: .touchDown)
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.backgroundColor = Brandbook.Colors.lightGray
    textField.layoutMargins = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    textField.textAlignment = NSTextAlignment.center
    textField.clipsToBounds = true
    textField.layer.cornerRadius = 6
    return textField
  }()
  
  let tinderButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Воспользоваться тиндером", for: .normal)
    button.tintColor = .black
    button.backgroundColor = Brandbook.Colors.blueStatus
    button.clipsToBounds = true
    button.layer.cornerRadius = 6
    button.addTarget(self, action: #selector(openTinderButton), for: .touchDown)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let vacancyCheckBox: BEMCheckBox = {
    let checkbox = BEMCheckBox()
    checkbox.boxType = .circle
    checkbox.onTintColor = Brandbook.Colors.blueStatus
    checkbox.onCheckColor = Brandbook.Colors.blueStatus
    checkbox.lineWidth = 1.5
    checkbox.on = false
    checkbox.animationDuration = 1.5
    checkbox.onAnimationType = BEMAnimationType.oneStroke
    checkbox.offAnimationType = BEMAnimationType.oneStroke
    checkbox.translatesAutoresizingMaskIntoConstraints = false
    return checkbox
  }()
  
  
  let vacancyLable: UILabel = {
    let label = UILabel()
    label.text = "С вакансиями"
    label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.large)
    label.textColor = UIColor.black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let showResultsButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Показать результаты", for: .normal)
    button.tintColor = .black
    button.backgroundColor = Brandbook.Colors.blueStatus
    button.clipsToBounds = true
    button.layer.cornerRadius = 6
    button.addTarget(self, action: #selector(showResults), for: .touchDown)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  func initialize() {
    vacancyCheckBox.delegate = self
  }
  
  @objc
  func typePickerHandled() {
    isType = true
    let toolbar = UIToolbar();
    toolbar.sizeToFit()
    let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(donePickerType));
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelPicker));
    toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
    typeTextField.inputAccessoryView = toolbar
    typeTextField.inputView = picker
  }
  
  @objc
  func statusPickerHandle() {
    isType = false
    let toolbar = UIToolbar();
    toolbar.sizeToFit()
    let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(donePickerStatus));
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelPicker));
    toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
    statusTextField.inputAccessoryView = toolbar
    statusTextField.inputView = picker
  }
  
  @objc
  func donePickerType(){
    typeTextField.text = selectedType
    view.endEditing(true)
  }
  
  @objc
  func donePickerStatus(){
    statusTextField.text = selectedStatus
    view.endEditing(true)
  }
  
  @objc
  func cancelPicker(){
    view.endEditing(true)
  }
  
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if isType! {
      return types.count
    } else {
      return status.count
    }
    
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    if isType! {
      selectedType = types[row]
    } else {
      selectedStatus = status[row]
    }
    
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if isType! {
      return types[row]
    } else {
      return status[row]
    }
  }
  
  
  override func viewWillLayoutSubviews() {
    controller.view.frame = CGRect(x: 0, y:UIScreen.main.bounds.height-350, width: UIScreen.main.bounds.width, height: 350)
  }
  
  func didTap(_ checkBox: BEMCheckBox) {
    if vacancyFlag ?? true {
      self.vacancyFlag = false
    } else {
      self.vacancyFlag = true
    }
  }
  
  
  func setUp() {
    controller.view.backgroundColor = .white
    controller.view.layer.cornerRadius = 16
    controller.view.clipsToBounds = true
    
    controller.view.addSubview(filterLabel)
    filterLabel.topAnchor.constraint(equalTo: controller.view.topAnchor, constant: small).isActive = true
    filterLabel.leftAnchor.constraint(equalTo: controller.view.leftAnchor, constant: padding).isActive = true
    filterLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
    
    controller.view.addSubview(typePickerLabel)
    typePickerLabel.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: padding).isActive = true
    typePickerLabel.leftAnchor.constraint(equalTo: controller.view.leftAnchor, constant: padding).isActive = true
    typePickerLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width-3*padding)/2).isActive = true
    
    controller.view.addSubview(statusPickerLabel)
    statusPickerLabel.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: padding).isActive = true
    statusPickerLabel.leftAnchor.constraint(equalTo: typePickerLabel.rightAnchor, constant: padding).isActive = true
    
    
    controller.view.addSubview(typeTextField)
    typeTextField.topAnchor.constraint(equalTo: typePickerLabel.bottomAnchor,constant: small).isActive = true
    typeTextField.leftAnchor.constraint(equalTo: controller.view.leftAnchor, constant: padding).isActive = true
    typeTextField.rightAnchor.constraint(equalTo: typePickerLabel.rightAnchor).isActive = true
    typeTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width-3*padding)/2).isActive = true
    typeTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
    controller.view.addSubview(statusTextField)
    statusTextField.topAnchor.constraint(equalTo: typePickerLabel.bottomAnchor,constant: small).isActive = true
    statusTextField.rightAnchor.constraint(equalTo: controller.view.rightAnchor, constant: -padding).isActive = true
    
    statusTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width-3*padding)/2).isActive = true
    statusTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
    controller.view.addSubview(vacancyCheckBox)
    vacancyCheckBox.topAnchor.constraint(equalTo: typeTextField.bottomAnchor, constant: padding).isActive = true
    vacancyCheckBox.leftAnchor.constraint(equalTo: controller.view.leftAnchor, constant: padding).isActive = true
    vacancyCheckBox.widthAnchor.constraint(equalToConstant: 30).isActive = true
    vacancyCheckBox.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
    controller.view.addSubview(vacancyLable)
    vacancyLable.topAnchor.constraint(equalTo: typeTextField.bottomAnchor, constant: padding).isActive = true
    vacancyLable.leftAnchor.constraint(equalTo: vacancyCheckBox.rightAnchor, constant: small).isActive = true
    vacancyLable.rightAnchor.constraint(equalTo: controller.view.rightAnchor, constant: -padding).isActive = true
    vacancyLable.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
    
    controller.view.addSubview(tinderButton)
    tinderButton.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor, constant: -bottomInset.value).isActive = true
    tinderButton.heightAnchor.constraint(equalToConstant: self.measureFrameForText("Hello").height + padding).isActive = true
    tinderButton.leftAnchor.constraint(equalTo: controller.view.leftAnchor, constant: small).isActive = true
    tinderButton.rightAnchor.constraint(equalTo: controller.view.rightAnchor, constant: -small).isActive = true
    
    controller.view.addSubview(showResultsButton)
    showResultsButton.bottomAnchor.constraint(equalTo: tinderButton
                                                .topAnchor, constant: -padding).isActive = true
    showResultsButton.leftAnchor.constraint(equalTo: controller.view.leftAnchor, constant: small).isActive = true
    showResultsButton.rightAnchor.constraint(equalTo: controller.view.rightAnchor, constant: -small).isActive = true
    showResultsButton.heightAnchor.constraint(equalToConstant: measureFrameForText("Hello").height + padding).isActive = true
    
  }
  
  @objc
  func openTinderButton() {
    self.openTinderView()
  }
  
  @objc
  func showResults() {
    self.dismiss(animated: false, completion: (self.filter))
  }
  
  func filter(){
    self.didTap(vacancyCheckBox)
    self.parentVC!.filter(type: self.selectedType ?? "Любой", status: selectedStatus ?? "Любой", vacancy: vacancyFlag ?? false)
  }
  
  
  private func openTinderView() {
    let tinderViewController = TinderViewController(token: self.token)
    self.modalPresentationStyle = .popover
    self.present(tinderViewController, animated: true, completion: nil)
  }
  
  private func measureFrameForText(_ text: String) -> CGRect{
    let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
  }
  
}
private let padding = Brandbook.Paddings.normal
private let small = Brandbook.Paddings.small

