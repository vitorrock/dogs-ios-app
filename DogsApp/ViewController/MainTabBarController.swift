//
//  MainTabViewController.swift
//  DogsApp
//
//  Created by Vítor Rocha on 26/12/2022.
//

import Foundation
import UIKit

final class MainTabBarController: UITabBarController {
    
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
        let dogsViewController = DogsViewController()
        viewControllers = [dogsViewController]
    }
}
