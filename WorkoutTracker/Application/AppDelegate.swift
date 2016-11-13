//
//  AppDelegate.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 16/10/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import UIKit
import CoreData
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if WCSession.isSupported() {
            session = WCSession.default()
        }
        // Override point for customization after application launch.
        
//        let t = Datamodel.allExercises()
//        let j = Datamodel.allExercises(Datamodel.sharedInstance.binaryContainer)
        
//        session?.transferFile(Datamodel.sharedInstance.binaryUrl, metadata: nil)
        var newURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        newURL = newURL.appendingPathComponent("dbackup.sqlite")

        if let nuStore = Datamodel.sharedInstance.container.persistentStoreCoordinator.persistentStores.first {
            //https://developer.apple.com/library/content/qa/qa1809/_index.html
            try! Datamodel.sharedInstance.container.persistentStoreCoordinator.migratePersistentStore(nuStore, to: newURL, options: nil, withType: NSSQLiteStoreType)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

extension AppDelegate: WCSessionDelegate {
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    
    /** ------------------------- iOS App State For Watch ------------------------ */
    
    /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession) {}
    
    
    /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
    @available(iOS 9.3, *)
    public func sessionDidDeactivate(_ session: WCSession){}
    
//    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Swift.Void) {
//        
//        print("getting it done")
//        replyHandler(["exercises": Datamodel.allExercises().flatMap {$0.toData()}])
//    }
    
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        //create a new url migrate it
        
//        var x = FileManager.default.containerURL(
//                        forSecurityApplicationGroupIdentifier: PersistentContainer.sharedAppGroup)
//                        x = x!.appendingPathComponent("dbackup.sqlite")
//        var newURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//        newURL = newURL.appendingPathComponent("dbackup.sqlite")
//       // do {
//       
//        if let nuStore = Datamodel().container.persistentStoreCoordinator.persistentStores.first {
//            //https://developer.apple.com/library/content/qa/qa1809/_index.html
//            nuStore
//           try! Datamodel().container.persistentStoreCoordinator.migratePersistentStore(nuStore, to: newURL, options: nil, withType: NSSQLiteStoreType)
//        }
        
        if let url = Datamodel.sharedInstance.container.persistentStoreCoordinator.persistentStores.first?.url {
            
//            do {
//                let filePath: String = newURL.absoluteString
//                var fileSize : UInt64
//                let attr:NSDictionary? = try FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary?
//                if let _attr = attr {
//                    fileSize = _attr.fileSize();
//                    print(fileSize)
//                }
//                
//            } catch {
//                print(error)
//            }
            session.transferFile(url, metadata: nil)
        }
//        } catch {
//            print(error)
//        }
    }
    
}

