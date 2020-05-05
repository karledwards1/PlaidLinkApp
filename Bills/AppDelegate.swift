//
//  AppDelegate.swift
//  Bills
//
//  Created by Karl Edwards on 4/30/20.
//  Copyright © 2020 Karl Edwards. All rights reserved.
//

import UIKit
import CoreData
import LinkKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        #if USE_CUSTOM_CONFIG
                setupPlaidWithCustomConfiguration()
        #else
                setupPlaidLinkWithSharedConfiguration()
        #endif
        return true
    }

    // MARK: Plaid Link setup with shared configuration from Info.plist
    func setupPlaidLinkWithSharedConfiguration()
    {
        // SMARTDOWN_SETUP_SHARED
        // With shared configuration from Info.plist
        PLKPlaidLink.setup { (success, error) in
            if (success)
            {
                // Handle success here, e.g. by posting a notification
                NSLog("Plaid Link setup was successful")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PLDPlaidLinkSetupFinished"), object: self)
            }
            else if let error = error
            {
                NSLog("Unable to setup Plaid Link due to: \(error.localizedDescription)")
            }
            else
            {
                NSLog("Unable to setup Plaid Link")
            }
        }
    }
    
    // MARK: Plaid Link setup with custom configuration
    func setupPlaidWithCustomConfiguration()
    {
        // SMARTDOWN_SETUP_CUSTOM
        // With custom configuration
        let linkConfiguration = PLKConfiguration(key: "<#YOUR_PLAID_PUBLIC_KEY#>", env: .development, product: .auth)
        linkConfiguration.clientName = "Link Demo"
        PLKPlaidLink.setup(with: linkConfiguration) { (success, error) in
            if (success)
            {
                // Handle success here, e.g. by posting a notification
                NSLog("Plaid Link setup was successful")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PLDPlaidLinkSetupFinished"), object: self)
            }
            else if let error = error
            {
                NSLog("Unable to setup Plaid Link due to: \(error.localizedDescription)")
            }
            else
            {
                NSLog("Unable to setup Plaid Link")
            }
        }
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>)
    {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentCloudKitContainer =
        {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "Bills")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError?
            {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext ()
    {
        let context = persistentContainer.viewContext
        if context.hasChanges
        {
            do
            {
                try context.save()
            }
            catch
            {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

