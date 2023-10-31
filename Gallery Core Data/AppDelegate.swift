//
//  AppDelegate.swift
//  Gallery Core Data
//
//  Created by Artem Galiev on 31.10.2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        MainRouter.shared.showTmpMainScreen()
        
        return true
    }

}

