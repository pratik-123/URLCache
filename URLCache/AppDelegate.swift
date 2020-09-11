//
//  AppDelegate.swift
//  URLCache
//
//  Created by Pratik on 11/09/20.
//  Copyright © 2020 Pratik Lad. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory,
                                                       .userDomainMask, true)
        print("app directory path - \(path)")
        return true
    }
}

