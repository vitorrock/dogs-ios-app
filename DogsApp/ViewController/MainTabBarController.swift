//
//  MainTabViewController.swift
//  DogsApp
//
//  Created by Vítor Rocha on 26/12/2022.
//

import Foundation
import UIKit

final class MainTabBarController: UITabBarController {
    
    private let labels: LabelsProtocol
    
    init(labels: LabelsProtocol = Labels()) {
        self.labels = labels
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureViewControllers()
    }
    
    func configureAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    func configureViewControllers() {
        let dogsListViewController = UINavigationController(rootViewController: DogsListViewController())
        dogsListViewController.tabBarItem.title = labels.getLabel(for: LocalizationKeys.DogsList.title)
        
        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        searchViewController.tabBarItem.title = labels.getLabel(for: LocalizationKeys.Search.title)
        
        viewControllers = [
            dogsListViewController,
            searchViewController
        ]
    }
}
