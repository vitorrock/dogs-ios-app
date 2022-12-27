//
//  DogsViewController.swift
//  DogsApp
//
//  Created by Vítor Rocha on 26/12/2022.
//

import UIKit

final class DogsViewController: UIViewController, UICollectionViewDelegate {
    
    enum Constants {
        static let cellHeight: CGFloat = 300
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Breed>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Breed>
    
    private lazy var dataSource: DataSource = makeDataSource()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(
            DogsListCollectionViewCell.self,
            forCellWithReuseIdentifier: DogsListCollectionViewCell.reuseIdentifier
        )
        return cv
    }()
    
    private var viewModel: DogsListViewModelProtocol
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
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
        collectionView.delegate = self
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
    
}

extension DogsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: Constants.cellHeight)
    }
}
