//
//  UIViewController+Ext.swift
//  Food Bro
//
//  Created by Tomasz Parys on 27/06/2024.
//

import UIKit

extension UIViewController {
    
    func presentDestVCinNC(goTo vc: UIViewController) {
            let newBtn = UIBarButtonItem()
            newBtn.title = ""
           
            navigationItem.backBarButtonItem = newBtn
            navigationController?.pushViewController(vc, animated: true)
        }
}
