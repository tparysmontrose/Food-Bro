//
//  AlertFactory.swift
//  Food Bro
//
//  Created by Tomasz Parys on 27/06/2024.
//

import UIKit

struct AlertButtonTitlteColor {
    let name: String
    var color: UIColor?
}

class AlertFactory: NSObject {
   
    static func createSheetAlert(for viewController: UIViewController,
                                  with title: String?,
                                  message: String?,
                                  buttons: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message:message , preferredStyle: .alert)
        for b in buttons {
            alert.addAction(b)
        }
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
        }))
        viewController.present(alert, animated: true)
    }
}
