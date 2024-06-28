//
//  ActivityLevelCell.swift
//  Food Bro
//
//  Created by Tomasz Parys on 28/06/2024.
//

import UIKit

class ActivityLevelCell: UITableViewCell {
    
    var titleLbl           = UILabel()
    var separatorLine      = UIView()
    
    func configCell(title: String) {
        configAutolayout()
        
        selectionStyle     = .none
        backgroundColor    = .secondarySystemBackground
        titleLbl.text      = title
        titleLbl.font      = .systemFont(ofSize: 15)
        titleLbl.textColor = .label
        accessoryType      = isSelected ? .checkmark : .none
    }
    
    func setSeparator(isLastCell: Bool) {
        separatorLine.backgroundColor = isLastCell ? .clear : .systemGray5
    }
    
    func setSelectedCell(_ selected: Bool) {
        isSelected         = selected
        accessoryType      = selected ? .checkmark : .none
    }
    
    private func configAutolayout() {
        addSubviews(separatorLine, titleLbl)
        titleLbl.fit(for: contentView, edges: UIEdgeInsets(top: 0, left: Margins.standard, bottom: 0, right: Margins.standard))
        
        NSLayoutConstraint.activate([
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.standard),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.standard),
            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
