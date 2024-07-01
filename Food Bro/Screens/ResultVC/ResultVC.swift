//
//  ResultVC.swift
//  Food Bro
//
//  Created by Tomasz Parys on 27/06/2024.
//

import UIKit
import Combine

class ResultVC: UIViewController {
    
    let vm: ResultViewModel
    var token: AnyCancellable?
    
    let indicator = UIActivityIndicatorView(style: .large)
    
    let mealView : UITextView = {
        let tv = UITextView()
        tv.textColor = .label
        tv.isEditable = false
        tv.font = .systemFont(ofSize: 15)
        tv.textAlignment = .left
        return tv
    }()
    
    let shareBtn: UIButton = {
        let btn = UIButton(configuration: .tinted())
        btn.configuration?.baseBackgroundColor = .systemGreen
        btn.configuration?.title = "Share result"
        return btn
    }()
    
    let againBtn: UIButton = {
        let btn = UIButton(configuration: .tinted())
        btn.configuration?.baseBackgroundColor = .systemPink
        btn.configuration?.title = "Start again"
        return btn
    }()
    
    init(vm: ResultViewModel) {
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
        vm.getMealPlan()
        bindToMeal()
    }
    
    private func configUIElements() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        indicator.startAnimating()
        title = "Meal Plan"
        
        againBtn.addTarget(self, action: #selector(againBtnPressed), for: .touchUpInside)
        shareBtn.addTarget(self, action: #selector(shareBtnPressed), for: .touchUpInside)
    }
    
    private func configAutolayout() {
        view.addSubviews(againBtn, shareBtn, mealView, indicator)
        
        NSLayoutConstraint.activate([
            againBtn.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight),
            againBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Margins.standard),
            againBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Margins.standard),
            againBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Margins.standard),
            
            shareBtn.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight),
            shareBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Margins.standard),
            shareBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Margins.standard),
            shareBtn.bottomAnchor.constraint(equalTo: againBtn.topAnchor, constant: -Margins.standard),
            
            mealView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Margins.standard),
            mealView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Margins.standard),
            mealView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Margins.standard),
            mealView.bottomAnchor.constraint(equalTo: shareBtn.topAnchor, constant: -Margins.standard),
            
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindToMeal() {
        token = vm.meal
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else {return}
                
            switch completion {
            case .finished:
                indicator.isHidden = true
                break
            case .failure(let error):
                print(error)
                indicator.isHidden = true
                let msg = error == .invalidApiKey ? "Enter the correct API key and start again." : "Try again."
                AlertFactory.createSheetAlert(for: self, with: "Ups something was wrong", message: msg, buttons: [])
            }
            
        }, receiveValue: {[weak self] meal in
            guard let self = self else {return}
            indicator.isHidden = true
            self.mealView.text = meal
        })
    }
    
    @objc func againBtnPressed() {
        NotificationCenter.default.post(name: .startAgain, object: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func shareBtnPressed() {
        let meal = mealView.text ?? ""
        let shareAll = [meal] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}
