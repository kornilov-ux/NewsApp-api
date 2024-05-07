//
//  AppDelegate.swift
//  NewsApp-api
//
//  Created by Alex  on 04.05.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
					 [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = CustomTabBarController()
		window.makeKeyAndVisible()
		self.window = window
		return true
	}


}

