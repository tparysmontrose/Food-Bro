//
//  UIStackView+Ext.swift
//  Food Bro
//
//  Created by Tomasz Parys on 26/06/2024.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
