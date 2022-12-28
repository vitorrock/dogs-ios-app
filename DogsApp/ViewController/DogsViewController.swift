//
//  DogsViewController.swift
//  DogsApp
//
//  Created by Vítor Rocha on 26/12/2022.
//

import UIKit

final class DogsViewController: UIViewController, UICollectionViewDelegate {
    
    enum Constants {
        static let listViewCellHeight: CGFloat = 300
        static let gridViewCellHeight: CGFloat = 150
        static let collectionViewMargin: CGFloat = 50
        static let collectionViewSpacing: CGFloat = 50
        static let listViewTitle: String = "List View"
        static let gridViewTitle: String = "Grid View"
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
            title: Constants.gridViewTitle,
            style: .plain,
            target: self,
            action: #selector(switchCollectionView)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupOutputEvents()
        viewModel.setup()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
    }
    
    private func setupViews() {
        navigationItem.rightBarButtonItem = collectionViewBarButton
        
        collectionView.delegate = self
        collectionView.collectionViewLayout = listCollectionViewLayout
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
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
            collectionViewBarButton.title = Constants.gridViewTitle
        } else {
            collectionViewBarButton.title = Constants.listViewTitle
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
