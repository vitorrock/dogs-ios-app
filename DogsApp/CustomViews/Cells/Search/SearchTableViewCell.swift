//
//  SearchTableViewCell.swift
//  DogsApp
//
//  Created by Vítor Rocha on 28/12/2022.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SearchTableViewCell"
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var breedNameTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = labels.getLabel(for: LocalizationKeys.Search.breadNameTitle)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.numberOfLines = 0
        return label
    }()
    
    private let breedNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var breedGroupTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = labels.getLabel(for: LocalizationKeys.Search.breadGroupTitle)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let breedGroupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var originTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = labels.getLabel(for: LocalizationKeys.Search.originTitle)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let originLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let labels: LabelsProtocol
    
    init(labels: LabelsProtocol = Labels()) {
        self.labels = labels
        super.init(style: .default, reuseIdentifier: Self.reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        breedNameLabel.text = ""
        breedGroupLabel.text = ""
        originLabel.text = ""
    }
    
    private func setupConstraints() {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        
        let nameStackView = makeLabelsStackView()
        nameStackView.addArrangedSubview(breedNameTitleLabel)
        nameStackView.addArrangedSubview(breedNameLabel)
        stackView.addArrangedSubview(nameStackView)
        
        let groupStackView = makeLabelsStackView()
        groupStackView.addArrangedSubview(breedGroupTitleLabel)
        groupStackView.addArrangedSubview(breedGroupLabel)
        stackView.addArrangedSubview(groupStackView)
        
        let originStackView = makeLabelsStackView()
        originStackView.addArrangedSubview(originTitleLabel)
        originStackView.addArrangedSubview(originLabel)
        stackView.addArrangedSubview(originStackView)
    }
    
    private func makeLabelsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .horizontal
        return stackView
    }
    
    func configureCell(viewModel: SearchCellViewModelProtocol) {
        breedNameLabel.text = viewModel.name
        breedGroupLabel.text = viewModel.group
        originLabel.text = viewModel.origin
    }
}
