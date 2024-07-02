//
//  SportGoalsVC.swift
//  Food Bro
//
//  Created by Tomasz Parys on 27/06/2024.
//

import UIKit

class SportGoalsVC: UIViewController {
    
    let vm: SportGoalsViewModel
    var person: Person
    
    let sportGoalsTV: UITextView = {
       let tv = UITextView()
        tv.backgroundColor = .secondarySystemBackground
        tv.autocorrectionType = .no
        tv.layer.cornerRadius = UIConstants.standardCornerRadius
        tv.text = "Do you have any sports or nutrition goals?"
        tv.textColor = .secondaryLabel
        tv.addHideKeyboardButton(forControl: tv)
       return tv
    }()
    
    let activityFactor: TitleRowView = TitleRowView(title: "Activity" , desc: "activity level")
    
    let nextBtn: UIButton = {
        let btn = UIButton(configuration: .tinted())
        btn.configuration?.title = "Submit"
        btn.isEnabled = false
        return btn
    }()
    
    init(person: Person, vm: SportGoalsViewModel) {
        self.person = person
        self.vm = vm
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
        title = "Your goals"
        
        activityFactor.backgroundColor = .secondarySystemBackground
        activityFactor.layer.cornerRadius = UIConstants.standardCornerRadius
        
        activityFactor.delegate = self
        sportGoalsTV.delegate = self
        nextBtn.addTarget(self, action: #selector(submitBtnPressed), for: .touchUpInside)
    }
    
    private func configAutolayout() {
        view.addSubviews(sportGoalsTV, activityFactor, nextBtn)
        
        NSLayoutConstraint.activate([
            sportGoalsTV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Margins.standard),
            sportGoalsTV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Margins.standard),
            sportGoalsTV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Margins.standard),
            sportGoalsTV.heightAnchor.constraint(equalToConstant: 134),
            
            activityFactor.topAnchor.constraint(equalTo: sportGoalsTV.bottomAnchor, constant: Margins.standard),
            activityFactor.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Margins.standard),
            activityFactor.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Margins.standard),
            activityFactor.heightAnchor.constraint(equalToConstant: 51),
            
            nextBtn.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight),
            nextBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Margins.standard),
            nextBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Margins.standard),
            nextBtn.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -Margins.standard),
        ])
    }
    
    @objc func submitBtnPressed() {
        guard let calories = vm.calculateDailyCalories(person: person) else {
            AlertFactory.createSheetAlert(for: self, with: "Ups something was wrong", message: "Please select your activity level.", buttons: [])
            return
        }
        
        person.dailyCalories = calories
        person.sportGoals = sportGoalsTV.text
        let destVC = ResultVC(vm: ResultViewModel(person: person))
        presentDestVCinNC(goTo: destVC)
    }
}
//MARK: - UITextViewDelegate
extension SportGoalsVC: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Do you have any sports or nutrition goals?" {
            textView.text = ""
        }
            
        textView.textColor = .label
        nextBtn.isEnabled = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        person.sportGoals = textView.text
    }
}
//MARK: - TitleRowViewDelegate
extension SportGoalsVC: TitleRowViewDelegate {
    func btnPressed(tag: Int) {
        let destVC = ActivityLevelVC(person.activityLevel)
        destVC.delegate = self
        presentDestVCinNC(goTo: destVC)
    }
}
//MARK: - ActivityLevelDelegate
extension SportGoalsVC: ActivityLevelDelegate {
    func selectedActivityLevel(_ activityLevel: ActivityLevel?) {
        person.activityLevel = activityLevel
        activityFactor.updateDescription(activityLevel?.cellTitle)
    }
}
