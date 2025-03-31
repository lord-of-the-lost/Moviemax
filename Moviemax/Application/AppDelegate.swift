//
//  AppDelegate.swift
//  Moviemax
//
//  Created by Николай Игнатов on 30.03.2025.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let dependency = DI()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let appRouter = AppRouter(window: window, dependency: dependency)
        appRouter.start()
        
        window?.makeKeyAndVisible()
        return true
    }
}

