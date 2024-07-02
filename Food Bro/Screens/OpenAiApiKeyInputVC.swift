//
//  OpenAiApiKeyInputVC.swift
//  Food Bro
//
//  Created by Tomasz Parys on 01/07/2024.
//

import UIKit
import SafariServices

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
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.isSecureTextEntry = true
        tf.keyboardType = .default
        tf.addHideKeyboardButton(forControl: tf)
        tf.placeholder = "Enter your OpenAI Api Key"
        return tf
    }()
    
    lazy var hideUnhideBtn: UIButton = {
        let btn = UIButton(configuration: .filled())
        btn.configuration?.baseBackgroundColor = .clear
        btn.configuration?.baseForegroundColor = .label
        btn.setImage(UIImage(systemName: "eye"), for: .normal)
        btn.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        btn.addTarget(self, action: #selector(hideUnhideApiKey), for: .touchUpInside)
        return btn
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
        btn.configuration?.baseForegroundColor = .systemPink
        btn.configuration?.title = "Remove API key"
        return btn
    }()
    
    let createBtn: UIButton = {
        let btn = UIButton(configuration: .tinted())
        btn.configuration?.baseBackgroundColor = .systemGreen
        btn.configuration?.baseForegroundColor = .systemGreen
        btn.configuration?.title = "Create OpenAI Api key"
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
        
        apiKeyTf.rightView = hideUnhideBtn
        apiKeyTf.rightViewMode = .always
        
        saveBtn.addTarget(self, action: #selector(saveBtnPressed), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleteBtnPressed), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(backBtnPressed), for: .touchUpInside)
        createBtn.addTarget(self, action: #selector(createApiKeyBtnPressed), for: .touchUpInside)
    }
    
    private func configAutolayout() {
        view.addSubviews(backBtn, titleLbl, apiKeyTf, saveBtn, deleteBtn, createBtn)
        
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
            deleteBtn.topAnchor.constraint(equalTo: saveBtn.bottomAnchor, constant: Margins.standard),
            
            createBtn.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight),
            createBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Margins.standard),
            createBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Margins.standard),
            createBtn.topAnchor.constraint(equalTo: deleteBtn.bottomAnchor, constant: Margins.standard)
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
    
    @objc private func createApiKeyBtnPressed() {
        
        guard let url = URL(string: "https://help.openai.com/en/articles/4936850-where-do-i-find-my-openai-api-key") else {
            AlertFactory.createSheetAlert(for: self, with: "Ups something was wrong", message: "The address you want to go to no longer exists.", buttons: [])
            return
        }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .formSheet
        present(safariVC, animated: true, completion: nil)
    }
    
    @objc private func backBtnPressed() {
        backToPreviesScreen()
    }
    
    @objc func hideUnhideApiKey() {
        apiKeyTf.isSecureTextEntry = !apiKeyTf.isSecureTextEntry
        hideUnhideBtn.isSelected = !hideUnhideBtn.isSelected
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

