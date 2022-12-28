//
//  DogsListCollectionViewCell.swift
//  DogsApp
//
//  Created by Vítor Rocha on 27/12/2022.
//

import UIKit

final class DogsListCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DogsListCollectionViewCell"
    
    private var viewModel: DogsListCellViewModelProtocol?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        titleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
    }
    
    private func setupOutputEvents() {
        viewModel?.outputEvents.displayImage = { [weak self] image in
            self?.imageView.image = image
        }
    }
    
    func configureCell(viewModel: DogsListCellViewModelProtocol) {
        self.viewModel = viewModel
        setupOutputEvents()
        viewModel.fetchImage()
        titleLabel.text = viewModel.title
    }
}
