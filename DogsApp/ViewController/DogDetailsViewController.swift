//
//  DogDetailsViewController.swift
//  DogsApp
//
//  Created by Vítor Rocha on 29/12/2022.
//

import Foundation
import UIKit

final class DogDetailsViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    
    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()
    
    private let breedNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private let breedGroupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let originLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let temperamentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var viewModel: DogDetailsViewModelProtocol
    
    init(viewModel: DogDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutputEvents()
        setupUI()
        setupContraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        breedNameLabel.text = viewModel.name
        breedGroupLabel.text = viewModel.group
        originLabel.text = viewModel.origin
        temperamentLabel.text = viewModel.temperament
        
        viewModel.fetchImage()
    }
    
    private func setupContraints() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        scrollView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        
        scrollView.addSubview(labelsStackView)
        labelsStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        labelsStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        labelsStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20).isActive = true
        labelsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        labelsStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40).isActive = true
        
        labelsStackView.addArrangedSubview(breedNameLabel)
        labelsStackView.addArrangedSubview(breedGroupLabel)
        labelsStackView.addArrangedSubview(originLabel)
        labelsStackView.addArrangedSubview(temperamentLabel)
    }
    
    private func setupOutputEvents() {
        viewModel.outputEvents.displayImage = { [weak self] image in
            self?.imageView.image = image
        }
    }
}
