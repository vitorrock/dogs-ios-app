//
//  SearchTableViewCell.swift
//  DogsApp
//
//  Created by Vítor Rocha on 28/12/2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SearchTableViewCell"
    
    private enum Constants {
        static let breedNameTitle: String = "Name:"
        static let breedGroupTitle: String = "Group:"
        static let originTitle: String = "Origin:"
    }
    
    private let breedNameTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = Constants.breedNameTitle
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private let breedNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private let breedGroupTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = Constants.breedGroupTitle
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private let breedGroupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private let originTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = Constants.originTitle
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private let originLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        addSubview(breedNameTitleLabel)
        breedNameTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        breedNameTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        
        addSubview(breedNameLabel)
        breedNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        breedNameLabel.leftAnchor.constraint(equalTo: breedNameTitleLabel.rightAnchor, constant: 5).isActive = true
        breedNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 5).isActive = true
        

        addSubview(breedGroupTitleLabel)
        breedGroupTitleLabel.topAnchor.constraint(equalTo: breedNameTitleLabel.bottomAnchor, constant: 5).isActive = true
        breedGroupTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        
        addSubview(breedGroupLabel)
        breedGroupLabel.topAnchor.constraint(equalTo: breedNameTitleLabel.bottomAnchor, constant: 5).isActive = true
        breedGroupLabel.leftAnchor.constraint(equalTo: breedGroupTitleLabel.rightAnchor, constant: 5).isActive = true
        breedGroupLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 5).isActive = true

        addSubview(originTitleLabel)
        originTitleLabel.topAnchor.constraint(equalTo: breedGroupTitleLabel.bottomAnchor, constant: 5).isActive = true
        originTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        bottomAnchor.constraint(equalTo: originTitleLabel.bottomAnchor, constant: 5).isActive = true
        
        addSubview(originLabel)
        originLabel.topAnchor.constraint(equalTo: breedGroupTitleLabel.bottomAnchor, constant: 5).isActive = true
        originLabel.leftAnchor.constraint(equalTo: originTitleLabel.rightAnchor, constant: 5).isActive = true
        originLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 5).isActive = true
        bottomAnchor.constraint(greaterThanOrEqualTo: originLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    func configureCell(viewModel: SearchCellViewModelProtocol) {
        breedNameLabel.text = viewModel.name
        breedGroupLabel.text = viewModel.group
        originLabel.text = viewModel.origin
    }
}
