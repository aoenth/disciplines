
//
//  AppDelegate.swift
//  Disciplines
//
//  Created by Kevin on 2017-09-12.
//  Copyright © 2017 Monorail Apps. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  let dataManager = DataManager.shared
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    
    let viewController = ViewController()
    viewController.tabBarItem = UITabBarItem(title: "Today", image: #imageLiteral(resourceName: "Today Icon"), tag: 0)
    let navigationController = UINavigationController(rootViewController: viewController)
    
    let archiveController = ArchiveController()
    archiveController.tabBarItem = UITabBarItem(title: "Achievements", image: #imageLiteral(resourceName: "Achievement Icon"), tag: 1)
    
    let graphController = GraphController()
    graphController.tabBarItem = UITabBarItem(title: "This Week", image: #imageLiteral(resourceName: "This Week Icon"), tag: 2)

    let tabBarController = UITabBarController()
    tabBarController.viewControllers = [archiveController, navigationController, graphController]
    window?.rootViewController = tabBarController
    window?.makeKeyAndVisible()
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    dataManager.saveContext()
  }
  
}

