//
//  UIView+Ext.swift
//  Food Bro
//
//  Created by Tomasz Parys on 26/06/2024.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
    func fit(for superView: UIView, edges: UIEdgeInsets) {
        self.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: edges.top).isActive = true
        self.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: -edges.bottom).isActive = true
        self.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor, constant: edges.left).isActive = true
        self.trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor, constant: -edges.right).isActive = true
    }
    
    func pinToEdges(of superView: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
    }
    
    func addHideKeyboardButton(forControl control: AnyObject){
        let toolBarTextField = UIToolbar()
        toolBarTextField.sizeToFit()
        let symbol      = UIImage(systemName: "keyboard.chevron.compact.down")
        let doneButton    = UIBarButtonItem(image: symbol, style: .done, target: self, action: #selector(doneBtnPressed))
        doneButton.tintColor = .label
        let flexibleSpace  = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBarTextField.setItems([ flexibleSpace,doneButton,flexibleSpace], animated: true)
        
        if control.isKind(of: UITextView.self){
            guard let textView = control as? UITextView else {return}
            textView.inputAccessoryView = toolBarTextField
        }
        else if control.isKind(of: UITextField.self){
            guard let textField = control as? UITextField else {return}
            textField.inputAccessoryView = toolBarTextField
        }
    }
    
    @objc func doneBtnPressed() {
        self.endEditing(true)
    }
}


