//
//  FoodPreferencesVC.swift
//  Food Bro
//
//  Created by Tomasz Parys on 27/06/2024.
//

import UIKit

class FoodPreferencesVC: UIViewController {
    
    var person: Person
    
    let foodPreferencesTV: UITextView = {
       let tv = UITextView()
        tv.backgroundColor = .secondarySystemBackground
        tv.autocorrectionType = .no
        tv.layer.cornerRadius = UIConstants.standardCornerRadius
        tv.text = "Please enter your food preferences. \nType in full sentence or leave blank \n(ex.: I can’t stand eating fish. I very like chocolate and fruits.)"
        tv.textColor = .secondaryLabel
        tv.addHideKeyboardButton(forControl: tv)
       return tv
    }()
    
    let nextBtn: UIButton = {
        let btn = UIButton(configuration: .tinted())
        btn.configuration?.title = "Next"
        btn.isEnabled = false
        return btn
    }()
    
    init(person: Person) {
        self.person = person
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
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Food Preferences"
        
        foodPreferencesTV.delegate = self
        nextBtn.addTarget(self, action: #selector(nextBtnPressed), for: .touchUpInside)
    }
    
    private func configAutolayout() {
        view.addSubviews(foodPreferencesTV, nextBtn)
        
        NSLayoutConstraint.activate([
            foodPreferencesTV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Margins.standard),
            foodPreferencesTV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Margins.standard),
            foodPreferencesTV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Margins.standard),
            foodPreferencesTV.heightAnchor.constraint(equalToConstant: 134),
            
            nextBtn.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight),
            nextBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Margins.standard),
            nextBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Margins.standard),
            nextBtn.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -Margins.standard),
        ])
    }
    
    @objc func nextBtnPressed() {
        person.foodPreferences = foodPreferencesTV.text
        let destVC = FoodAllergiesVC(person: person)
        presentDestVCinNC(goTo: destVC)
    }
}
//MARK: -UITextViewDelegate
extension FoodPreferencesVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .label
        nextBtn.isEnabled = true
    }
}
