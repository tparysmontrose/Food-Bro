//
//  TitleRowView.swift
//  Food Bro
//
//  Created by Tomasz Parys on 28/06/2024.
//

import UIKit

protocol TitleRowViewDelegate: NSObject {
    func btnPressed(tag: Int)
}

class TitleRowView: UIView {

    weak var delegate: TitleRowViewDelegate?
    
    let arrow                          = UIImageView()
    let mainStackView                  = UIStackView()
    
    private lazy var titleLbl: UILabel = {
        let lbl                        = UILabel()
        lbl.textAlignment              = .left
        return lbl
    }()
    
    private lazy var descLbl: UILabel  = {
        let lbl                        = UILabel()
        lbl.textColor                  = .secondaryLabel
        lbl.textAlignment              = .right
        return lbl
    }()
    
    private lazy var actionButton: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUIElements()
        configAutolayout()
    }
    
    init(title: String, desc: String?, tag: Int = 0) {
        super.init(frame: .zero)
        self.titleLbl.text = title
        self.descLbl.text  = desc
        actionButton.tag   = tag
        configUIElements()
        configAutolayout()
    }
    
    private func configUIElements() {
        arrow.image                 = UIImage(systemName: "chevron.right")
        arrow.tintColor             = .gray
        arrow.contentMode           = .scaleAspectFit
        
        actionButton.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
    
        mainStackView.axis          = .horizontal
        mainStackView.spacing       = Margins.standard
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 0)
       
        if titleLbl.text != nil { mainStackView.addArrangedSubview(titleLbl) }
        if descLbl.text  != nil { mainStackView.addArrangedSubview(descLbl) }
    }
    
    private func configAutolayout() {
        addSubviews(arrow, mainStackView, actionButton)
        actionButton.pinToEdges(of: self)
        
        NSLayoutConstraint.activate([
            arrow.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrow.widthAnchor.constraint(equalToConstant: UIConstants.chevronSize),
            arrow.heightAnchor.constraint(equalToConstant: UIConstants.chevronSize),
            arrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.standard),
            
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.standard),
            mainStackView.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: -Margins.standard),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @objc func btnPressed() {
        delegate?.btnPressed(tag: actionButton.tag)
    }
    
    func updateDescription(_ desc: String?) {
        guard descLbl.text != nil else {return}
        descLbl.text = desc
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
