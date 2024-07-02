//
//  MenuVC.swift
//  Food Bro
//
//  Created by Tomasz Parys on 01/07/2024.
//

import UIKit

class MenuVC: UIViewController {
    
    lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: Margins.zero, left: Margins.standard, bottom: Margins.zero, right: Margins.standard)
        stack.spacing = Margins.standard
        stack.axis = .vertical
        stack.addArrangedSubviews(dailyMealPlannerBtn, weeklyMealPlannerBtn, apiKeySettingsBtn)
        return stack
    }()
    
    let dailyMealPlannerBtn: UIButton = {
        let btn = UIButton(configuration: .tinted())
        btn.configuration?.title = "Daily meal planner"
        return btn
    }()
    
    let weeklyMealPlannerBtn: UIButton = {
        let btn = UIButton(configuration: .tinted())
        btn.configuration?.baseBackgroundColor = .systemGreen
        btn.configuration?.baseForegroundColor = .systemGreen
        btn.configuration?.title = "Weekly meal planner"
        return btn
    }()
    
    let apiKeySettingsBtn: UIButton = {
        let btn = UIButton(configuration: .gray())
        btn.configuration?.title = "OpenAI Api key settings"
        return btn
    }()
    
    lazy var appVersionLbl: UILabel = {
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let lbl = UILabel()
        lbl.text = "Food Bro version: \(appVersion) (\(build))"
        lbl.textColor = .label
        lbl.font = .systemFont(ofSize: 14)
        lbl.textAlignment = .center
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUIElements()
        configAutolayout()
        checkForApiKey()
    }
    
    private func configUIElements() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Menu"
        
        view.backgroundColor = .systemBackground
        apiKeySettingsBtn.addTarget(self, action: #selector(apiKeySettingsBtnPressed), for: .touchUpInside)
        dailyMealPlannerBtn.addTarget(self, action: #selector(dailyMealPlannerBtnPressed), for: .touchUpInside)
        weeklyMealPlannerBtn.addTarget(self, action: #selector(weeklyMealPlannerBtnPressed), for: .touchUpInside)
    }
    
    private func configAutolayout() {
        view.addSubviews(buttonsStack, appVersionLbl)
        
        NSLayoutConstraint.activate([
            buttonsStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Margins.standard),
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            appVersionLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            appVersionLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            appVersionLbl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Margins.standard),
            
            dailyMealPlannerBtn.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight),
            weeklyMealPlannerBtn.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight),
            apiKeySettingsBtn.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight)
        ])
    }
    
    @objc private func apiKeySettingsBtnPressed() {
        let destVC = OpenAiApiKeyInputVC(withNavBar: true)
        destVC.delegate = self
        presentDestVCinNC(goTo: destVC)
    }
    
    @objc private func dailyMealPlannerBtnPressed() {
        let destVC = PersonInfoInputVC(planFor: .daily)
        presentDestVCinNC(goTo: destVC)
    }
    
    @objc private func weeklyMealPlannerBtnPressed() {
        let destVC = PersonInfoInputVC(planFor: .weakly)
        presentDestVCinNC(goTo: destVC)
    }
    
    private func checkForApiKey() {
        guard let _ = try? SecureStore.shared.getValue(for: Constants.openAiApiKey) else {
            let destVC = OpenAiApiKeyInputVC()
            destVC.delegate = self
            present(destVC, animated: true)
            return
        }
    }
}
extension MenuVC: OpenAiApiKeyInputVCDelegate {
    
    func apiKeyStatus(status: ApiKeyStatus) {
        switch status {
        case .save:
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                AlertFactory.createSheetAlert(for: self, with: "Great news", message: "Your key has been saved.", buttons: [])
            }
        case .delete:
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                AlertFactory.createSheetAlert(for: self, with: "Great news", message: "Your key has been removed.", buttons: [])
            }
        }
    }
}
