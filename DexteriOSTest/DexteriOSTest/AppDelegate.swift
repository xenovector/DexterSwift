//
//  AppDelegate.swift
//  DexteriOSTest
//
//  Created by ETC0018 on 02/05/2020.
//  Copyright © 2020 xenovector. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("---AppStatus: Will Enter Foreground.---")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("---AppStatus: Did Become Active.---")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("---AppStatus: Will Resign Active.---")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("---AppStatus: Did Enter Backgorund.---")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("---AppStatus: Will Terminate.---")
    }

}

