//
//  ActivityLevelVC.swift
//  Food Bro
//
//  Created by Tomasz Parys on 28/06/2024.
//

import UIKit

enum ActivityLevel: Int, CaseIterable {
    case sedentary    = 0
    case lightly      = 1
    case moderately   = 2
    case veryActive   = 3
    case extraActive  = 4
    
    var cellTitle: String {
        switch self {
        case .sedentary:
            return "Little or no exercise"
        case .lightly:
            return "Sports 1-3 days​/week"
        case .moderately:
            return "Sports 3-5 days/week"
        case .veryActive:
            return "Sports 6-7 days a week"
        case .extraActive:
            return "Very hard exercise/sports"
        }
    }
}

protocol ActivityLevelDelegate: NSObject {
    func selectedActivityLevel(_ activityLevel: ActivityLevel?)
}

class ActivityLevelVC: UIViewController {
    
    private let mainStackView = UIStackView()
    private let tableView     = UITableView()
    private var activityLevel: ActivityLevel?
    
    weak var delegate: ActivityLevelDelegate?
    
    init(_ activityLevel: ActivityLevel?) {
        self.activityLevel = activityLevel
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
        view.backgroundColor = .systemBackground
        
        navigationItem.largeTitleDisplayMode = .never
        
        mainStackView.layer.cornerRadius = UIConstants.standardCornerRadius
        mainStackView.clipsToBounds = true
        
        tableView.separatorStyle  = .none
        tableView.isScrollEnabled = false
        tableView.dataSource      = self
        tableView.delegate        = self
        tableView.register(ActivityLevelCell.self, forCellReuseIdentifier: ActivityLevelCell.description())
        
        mainStackView.addArrangedSubview(tableView)
    }
    
    private func configAutolayout() {
        view.addSubviews(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Margins.standard),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Margins.standard),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Margins.standard),
            
            tableView.heightAnchor.constraint(equalToConstant: UIConstants.standardCellHeight * CGFloat(ActivityLevel.allCases.count))
        ])
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ActivityLevelVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActivityLevel.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.standardCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActivityLevelCell.description(), for: indexPath) as? ActivityLevelCell else {return UITableViewCell()}
        cell.configCell(title: ActivityLevel.allCases[indexPath.row].cellTitle)
        cell.setSeparator(isLastCell: indexPath.row == ActivityLevel.allCases.count - 1)
        cell.setSelectedCell(indexPath.row == activityLevel?.rawValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityLevel = ActivityLevel(rawValue: indexPath.row)
        delegate?.selectedActivityLevel(activityLevel)
        navigationController?.popViewController(animated: true)
    }
}
