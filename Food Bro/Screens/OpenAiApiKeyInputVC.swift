//
//  OpenAiApiKeyInputVC.swift
//  Food Bro
//
//  Created by Tomasz Parys on 01/07/2024.
//

import UIKit

enum ApiKeyStatus: CaseIterable {
    case save
    case delete
}

protocol OpenAiApiKeyInputVCDelegate: NSObject {
    func apiKeyStatus(status: ApiKeyStatus)
}

class OpenAiApiKeyInputVC: UIViewController {
    
    let withNavBar: Bool
    weak var delegate: OpenAiApiKeyInputVCDelegate?

    let apiKeyTf: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .secondarySystemBackground
        tf.borderStyle = .roundedRect
        tf.keyboardType = .default
        tf.addHideKeyboardButton(forControl: tf)
        tf.placeholder = "Enter your OpenAI Api Key"
        return tf
    }()
    
    let backBtn: UIButton = {
        let btn = UIButton(configuration: .tinted())
        btn.configuration?.image = UIImage(systemName: "xmark.circle.fill")
        btn.configuration?.baseBackgroundColor = .clear
        btn.configuration?.baseForegroundColor = .gray
        btn.configuration?.cornerStyle = .capsule
        return btn
    }()
    
    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Api key Settings"
        lbl.textColor = .label
        lbl.font = .systemFont(ofSize: 17)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let saveBtn: UIButton = {
        let btn = UIButton(configuration: .tinted())
        btn.configuration?.title = "Save"
        btn.isEnabled = false
        return btn
    }()
    
    let deleteBtn: UIButton = {
        let btn = UIButton(configuration: .tinted())
        btn.configuration?.baseBackgroundColor = .systemPink
        btn.configuration?.title = "Remove API key"
        return btn
    }()
    
    init(withNavBar: Bool = false) {
        self.withNavBar = withNavBar
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
        apiKeyTf.delegate = self
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Api key Settings"
        backBtn.isHidden = withNavBar
        titleLbl.isHidden = withNavBar
        
        saveBtn.addTarget(self, action: #selector(saveBtnPressed), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleteBtnPressed), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(backBtnPressed), for: .touchUpInside)
    }
    
    private func configAutolayout() {
        view.addSubviews(backBtn, titleLbl, apiKeyTf, saveBtn, deleteBtn)
        
        NSLayoutConstraint.activate([
            backBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: Margins.standard),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.standard),
            backBtn.widthAnchor.constraint(equalToConstant: 24),
            backBtn.heightAnchor.constraint(equalToConstant: 24),
            
            titleLbl.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            apiKeyTf.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Margins.standard),
            apiKeyTf.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Margins.standard),
            apiKeyTf.heightAnchor.constraint(equalToConstant: UIConstants.standardTF),
            
            saveBtn.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight),
            saveBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Margins.standard),
            saveBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Margins.standard),
            saveBtn.topAnchor.constraint(equalTo: apiKeyTf.bottomAnchor, constant: 2 * Margins.standard),
            
            deleteBtn.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight),
            deleteBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Margins.standard),
            deleteBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Margins.standard),
            deleteBtn.topAnchor.constraint(equalTo: saveBtn.bottomAnchor, constant: Margins.standard)
        ])
        
        if withNavBar {
            apiKeyTf.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3*Margins.standard).isActive = true
        } else {
            apiKeyTf.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 3*Margins.standard).isActive = true
        }
    }
    
    @objc private func saveBtnPressed() {
        let oldKey = try? SecureStore.shared.getValue(for: Constants.openAiApiKey)
        let newApiKey = apiKeyTf.text ?? ""
        if oldKey == nil {
            do {
                try SecureStore.shared.save(value: newApiKey, for: Constants.openAiApiKey)
                delegate?.apiKeyStatus(status: .save)
                backToPreviesScreen()
            } catch {
                print("Save API KEY Error")
                AlertFactory.createSheetAlert(for: self, with: "Ups something was wrong", message: "Try again or write to support", buttons: [])
            }
        } else {
            do {
                try SecureStore.shared.updateValue(value: newApiKey, for: Constants.openAiApiKey)
                delegate?.apiKeyStatus(status: .save)
                backToPreviesScreen()
            } catch {
                print("update API KEY Error")
                AlertFactory.createSheetAlert(for: self, with: "Ups something was wrong", message: "Try again or write to support", buttons: [])
            }
        }
    }
    
    @objc private func deleteBtnPressed() {
        do {
            try SecureStore.shared.deleteValue(for: Constants.openAiApiKey)
            delegate?.apiKeyStatus(status: .delete)
            backToPreviesScreen()
        } catch {
            print("Delete API KEY Error")
            AlertFactory.createSheetAlert(for: self, with: "Ups something was wrong", message: "Try again or write to support", buttons: [])
        }
    }
    
    private func backToPreviesScreen() {
        if withNavBar {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func backBtnPressed() {
        backToPreviesScreen()
    }
}
//MARK: -UITextFieldDelegate
extension OpenAiApiKeyInputVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveBtnPressed()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveBtn.isEnabled = true
    }
}

