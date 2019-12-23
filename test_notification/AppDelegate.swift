//
//  AppDelegate.swift
//  test_notification
//
//  Created by Alexander Orlov on 16.12.2019.
//  Copyright © 2019 Alexander Orlov. All rights reserved.
//

import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "test.refresh",
            using: DispatchQueue.global()
        ) { task in
            self.handleAppRefresh(task)
        }
        scheduleAppRefresh()
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    private func handleAppRefresh(_ task: BGTask) {
        
        UserDefaults.standard.set("has", forKey: "background")
        task.setTaskCompleted(success:true)
        scheduleAppRefresh()
    }
    
    
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "test.refresh")
        print( UserDefaults.standard.string(forKey: "background") ?? "not")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 10 * 60)
        
        do {
            BGTaskScheduler.shared.cancelAllTaskRequests()
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
}
