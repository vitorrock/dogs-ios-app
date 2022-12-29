//
//  SearchViewController.swift
//  DogsApp
//
//  Created by Vítor Rocha on 28/12/2022.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = labels.getLabel(for: LocalizationKeys.Search.searchBarPlaceholder)
        return searchController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.alwaysBounceVertical = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private var viewModel: SearchViewModelProtocol
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let labels: LabelsProtocol
    
    init(
        viewModel: SearchViewModelProtocol = SearchViewModel(),
        labels: LabelsProtocol = Labels()
    ) {
        self.viewModel = viewModel
        self.labels = labels
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupOutputEvents()
        setupNavigationBar()
        setupConstraints()
        viewModel.setup()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        title = labels.getLabel(for: LocalizationKeys.Search.title)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupNavigationBar() {
        view.backgroundColor = .white
        navigationItem.searchController = searchController
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupOutputEvents() {
        viewModel.outputEvents.displayDogs = { [weak self] breeds in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.outputEvents.displayLoading = { [weak self] isVisible in
            DispatchQueue.main.async {
                if isVisible {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier)
        
        if cell == nil {
            cell = SearchTableViewCell()
        }
        
        guard let cell = cell as? SearchTableViewCell else {
            preconditionFailure("CellWithReuseIdentifier not recognized")
        }
        
        cell.configureCell(viewModel: viewModel.makeCellViewModel(for: indexPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItem()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewModel = viewModel.makeDetailsViewModel(for: indexPath)
        let detailsVC = DogDetailsViewController(viewModel: detailsViewModel)
        
        present(detailsVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBreed(with: searchText)
    }
}
