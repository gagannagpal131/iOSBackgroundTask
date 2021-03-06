//
//  AppDelegate.swift
//  iOSBackgroundTask
//
//  Created by Nishant Yadav on 23/11/17.
//  Copyright © 2017 Nishant Yadav. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var timer: Timer!
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Get user permission for notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // MARK: Register Backgroundtask.
        self.registerBackgroundTask()
        self.applicationState()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// MARK: BackgroundTask
extension AppDelegate {
    
    func applicationState() {
        //call endBackgroundTask() on completion..
        switch UIApplication.shared.applicationState {
        case .active:
            print("App is active.")
        case .background:
            print("App is in background.")
            print("Background time remaining = \(UIApplication.shared.backgroundTimeRemaining) seconds")
            // PERFORM YOUR BACKGROUND TASK
            
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        case .inactive:
            break
        }
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
    @objc func update() {
        
        print("Background time remaining = \(UIApplication.shared.backgroundTimeRemaining) seconds")
        self.notify()
    }
    
    func notify() {
        
        let content = UNMutableNotificationContent()
        content.title = "Application entered in Background State"
        content.body = "Backgrround time remaining: \(UIApplication.shared.backgroundTimeRemaining) seconds"
        content.sound = .default()
        
        let request = UNNotificationRequest(identifier: "iOSBackgroundTask", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

