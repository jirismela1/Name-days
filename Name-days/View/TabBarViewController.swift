//
//  TabBarViewController.swift
//  Name-days
//
//  Created by Jirka  on 19/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit

class MyTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    fileprivate func setupTabBar(){
        
        let firstViewController = CalendarViewController()
        firstViewController.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "calendar"), selectedImage: nil)
    
        let secondViewController = SearchViewController()
        secondViewController.tabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        
        let thirdViewController = FavoriteViewController()
        thirdViewController.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "star"), selectedImage: nil)
        
        let tabBarList = [firstViewController, secondViewController, thirdViewController]
        
        viewControllers = tabBarList.map{UINavigationController(rootViewController: $0)}
        
        tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        
        tabBar.tintColor = K.myDarkRed
        tabBar.unselectedItemTintColor = .gray
    }
}
