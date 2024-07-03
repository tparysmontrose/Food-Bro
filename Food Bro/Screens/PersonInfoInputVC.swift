//
//  PersonInfoInputVC.swift
//  Food Bro
//
//  Created by Tomasz Parys on 26/06/2024.
//

import UIKit

class PersonInfoInputVC: UIViewController {
    
    let planFor: MealPlaner
    
    lazy var basicInfoStack: UIStackView = {
        let stack = UIStackView()
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: Margins.zero, left: Margins.standard, bottom: Margins.zero, right: Margins.standard)
        stack.spacing = Margins.standard
        stack.axis = .vertical
        stack.addArrangedSubviews(genderSegmentedControl, ageTextField, weightTextField, heightTextField)
        return stack
    }()
    
    let ageTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .secondarySystemBackground
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.addHideKeyboardButton(forControl: tf)
        tf.placeholder = "Enter your age"
        return tf
    }()
    
    let weightTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .secondarySystemBackground
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.addHideKeyboardButton(forControl: tf)
        tf.placeholder = "Enter your body weight [kg]"
        return tf
    }()
    
    let heightTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .secondarySystemBackground
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.addHideKeyboardButton(forControl: tf)
        tf.placeholder = "Enter your height [cm]"
        return tf
    }()
    
    let genderSegmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Male", "Female"])
        seg.selectedSegmentIndex = 0
        return seg
    }()
    
    let nextBtn: UIButton = {
        let btn = UIButton(configuration: .tinted())
        btn.configuration?.title = "Next"
        return btn
    }()
    
    init(planFor: MealPlaner) {
        self.planFor = planFor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUIElements()
        configAutolayout()
    }
    
    private func configUIElements() {
        NotificationCenter.default.addObserver(self, selector: #selector(clearData), name: .startAgain, object: nil)
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Personal information"
        
        nextBtn.addTarget(self, action: #selector(nextBtnPressed), for: .touchUpInside)
    }
    
    private func configAutolayout() {
        view.addSubviews(basicInfoStack, nextBtn)
        
        NSLayoutConstraint.activate([
            basicInfoStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Margins.standard),
            basicInfoStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            basicInfoStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        
            nextBtn.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight),
            nextBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Margins.standard),
            nextBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Margins.standard),
            nextBtn.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -Margins.standard),
            
            ageTextField.heightAnchor.constraint(equalToConstant: UIConstants.standardTF),
            weightTextField.heightAnchor.constraint(equalToConstant: UIConstants.standardTF),
            heightTextField.heightAnchor.constraint(equalToConstant: UIConstants.standardTF),
            genderSegmentedControl.heightAnchor.constraint(equalToConstant: UIConstants.standardSegmentedControl)
        ])
    }
    
    @objc func clearData() {
        let tfs = [ageTextField, weightTextField, heightTextField]
        tfs.forEach { $0.text = nil }
    }
    
    @objc func nextBtnPressed() {
        guard let age: Int = Int(ageTextField.text ?? ""), let weight: Double = Double(weightTextField.text ?? ""), let height: Double = Double(heightTextField.text ?? "") else {
            AlertFactory.createSheetAlert(for: self, with: "Ups something was wrong", message: "Please enter all fields", buttons: [])
            return
        }
        let gender = Gender(rawValue: genderSegmentedControl.selectedSegmentIndex) ?? .male
        let bmi = calculateBMI(weight: weight, height: height)
        let person = Person(age: age, weight: weight, height: height, bmi: bmi, gender: gender, planFor: planFor, foodPreferences: "", foodAllergies: "", sportGoals: "", activityLevel: nil, dailyCalories: 0)
        let destVC = FoodPreferencesVC(person: person)
        presentDestVCinNC(goTo: destVC)
    }
    
    private func calculateBMI(weight: Double, height: Double) -> Double {
        let heightInMeters = height / 100
        return weight/(heightInMeters * heightInMeters)
    }
}
