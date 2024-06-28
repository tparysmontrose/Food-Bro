//
//  FoodAllergiesVC.swift
//  Food Bro
//
//  Created by Tomasz Parys on 27/06/2024.
//

import UIKit

class FoodAllergiesVC: UIViewController {
    
    var person: Person

    let foodAllergiesTV: UITextView = {
       let tv = UITextView()
        tv.backgroundColor = .secondarySystemBackground
        tv.layer.cornerRadius = UIConstants.standardCornerRadius
        tv.text = "Please enter any food allergies you have. Please write list the individual ingredients ex. nuts, carrots, peas"
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
        title = "Food allergies"
        
        foodAllergiesTV.delegate = self
        nextBtn.addTarget(self, action: #selector(nextBtnPressed), for: .touchUpInside)
    }
    
    private func configAutolayout() {
        view.addSubviews(foodAllergiesTV, nextBtn)
        
        NSLayoutConstraint.activate([
            foodAllergiesTV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Margins.standard),
            foodAllergiesTV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Margins.standard),
            foodAllergiesTV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Margins.standard),
            foodAllergiesTV.heightAnchor.constraint(equalToConstant: 134),
            
            nextBtn.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight),
            nextBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Margins.standard),
            nextBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Margins.standard),
            nextBtn.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -Margins.standard),
        ])
    }
    
    @objc func nextBtnPressed() {
        person.foodAllergies = foodAllergiesTV.text
        let destVC = SportGoalsVC(person: person, vm: SportGoalsViewModel())
        presentDestVCinNC(goTo: destVC)
    }
}

//MARK: -UITextViewDelegate
extension FoodAllergiesVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .label
        nextBtn.isEnabled = true
    }
}
