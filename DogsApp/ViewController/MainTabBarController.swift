//
//  MainTabViewController.swift
//  DogsApp
//
//  Created by Vítor Rocha on 26/12/2022.
//

import Foundation
import UIKit

final class MainTabBarController: UITabBarController {
    
    private enum Constants {
        static let dogsListTitle = "Dogs List"
        static let serachTitle = "Search"
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
        let dogsViewController = UINavigationController(rootViewController: DogsViewController())
        dogsViewController.tabBarItem.title = Constants.dogsListTitle
        
        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        searchViewController.tabBarItem.title = Constants.serachTitle
        
        viewControllers = [
            dogsViewController,
            searchViewController
        ]
    }
}
