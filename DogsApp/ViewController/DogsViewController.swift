//
//  DogsViewController.swift
//  DogsApp
//
//  Created by Vítor Rocha on 26/12/2022.
//

import UIKit

final class DogsViewController: UIViewController {
    
    private enum Constants {
        static let listViewCellHeight: CGFloat = 300
        static let gridViewCellHeight: CGFloat = 150
        static let collectionViewMargin: CGFloat = 50
        static let collectionViewSpacing: CGFloat = 50
        static let title = "Dogs List"
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Breed>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Breed>
    
    private lazy var dataSource: DataSource = makeDataSource()
    
    private lazy var listCollectionViewLayout: UICollectionViewFlowLayout = {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.itemSize = CGSize(
            width: UIScreen.main.bounds.width - Constants.collectionViewMargin * 2,
            height: Constants.listViewCellHeight
        )
        collectionFlowLayout.minimumLineSpacing = Constants.collectionViewSpacing
        collectionFlowLayout.scrollDirection = .vertical
        return collectionFlowLayout
    }()

    private lazy var gridCollectionViewLayout: UICollectionViewFlowLayout = {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.itemSize = CGSize(
            width: (UIScreen.main.bounds.width - Constants.collectionViewMargin) / 2 ,
            height: Constants.gridViewCellHeight
        )
        collectionFlowLayout.minimumInteritemSpacing = Constants.collectionViewSpacing
        collectionFlowLayout.minimumLineSpacing = Constants.collectionViewSpacing
        collectionFlowLayout.scrollDirection = .vertical
        return collectionFlowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            DogsListCollectionViewCell.self,
            forCellWithReuseIdentifier: DogsListCollectionViewCell.reuseIdentifier
        )
        return collectionView
    }()
    
    private lazy var collectionViewBarButton: UIBarButtonItem = {
        return .init(
            image: UIImage(systemName: "square.grid.2x2"),
            style: .plain,
            target: self,
            action: #selector(switchCollectionView)
        )
    }()
    
    private lazy var sortListBarButton: UIBarButtonItem = {
        return .init(
            image: UIImage(systemName: "arrow.up.arrow.down")
        )
    }()
    
    private var viewModel: DogsListViewModelProtocol
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    private var isListView = true
    
    init(viewModel: DogsListViewModelProtocol = DogsListViewModel()) {
        self.viewModel = viewModel
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
        viewModel.fetchDogs()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
    }
    
    private func setupUI() {
        title = Constants.title
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [
            collectionViewBarButton,
            sortListBarButton
        ]
        
        collectionView.delegate = self
        collectionView.collectionViewLayout = listCollectionViewLayout
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        setupConstraints()
        setupSortMenu()
    }
    
    // MARK: - Private Methods
    
    private func setupSortMenu() {
        let menuItems = viewModel.makeMenuActionItems()
        let menu: UIMenu = .init(children: menuItems)
        sortListBarButton.menu = menu
    }
    
    private func setupConstraints() {
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupOutputEvents() {
        viewModel.outputEvents.displayDogs = { [weak self] breeds in
            DispatchQueue.main.async {
                self?.applySnapshot(items: breeds)
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
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item ->
                UICollectionViewCell? in
                return self?.configureCell(at: indexPath, item: item)
            })
        
        return dataSource
    }
    
    private func applySnapshot(items: [Breed]) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.zero])
        snapshot.appendItems(items)

        self.dataSource.apply(snapshot, animatingDifferences: true) {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func configureCell(at indexPath: IndexPath, item: Breed) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DogsListCollectionViewCell.reuseIdentifier, for: indexPath) as? DogsListCollectionViewCell else {
            preconditionFailure("CellWithReuseIdentifier not recognized")
        }
        
        cell.configureCell(viewModel: viewModel.makeCellViewModel(for: indexPath))
        return cell
    }
    
    @objc
    private func switchCollectionView() {
        collectionViewBarButton.isEnabled = false
        isListView = !isListView
        
        if isListView {
            collectionViewBarButton.image = UIImage(systemName: "square.grid.2x2")
        } else {
            collectionViewBarButton.image = UIImage(systemName: "line.3.horizontal")
        }
        
        collectionView.startInteractiveTransition(
            to: isListView ? listCollectionViewLayout : gridCollectionViewLayout
        ) { [weak self] completed, _ in
            if completed {
                self?.collectionViewBarButton.isEnabled = true
            }
        }
        collectionView.finishInteractiveTransition()
    }
}

// MARK: - UICollectionViewDelegate

extension DogsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRowIndex = collectionView.numberOfItems(inSection: 0) - 1
        
        if indexPath.row == lastRowIndex {
            viewModel.fetchDogs()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsViewModel = viewModel.makeDetailsViewModel(for: indexPath)
        let detailsVC = DogDetailsViewController(viewModel: detailsViewModel)
        
        present(detailsVC, animated: true)
    }
}
