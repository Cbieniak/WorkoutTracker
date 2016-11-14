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

    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        if message.keys.contains("session") {
            
            let session = Session(context: Datamodel.sharedInstance.container.viewContext)
            
            for (key,val) in (message["session"] as! [NSString : Any]) {
                if (key == "exercisePK") {
                    let exercise: Exercise = Datamodel.allExercises().first(where: { $0.primaryKey == (val as! String)})!
                    session.exercise = exercise
                    exercise.sessions = exercise.sessions.adding(session) as NSSet
                } else if key == "date" {
                    session.setValue(Date.init(timeIntervalSince1970: (val as! NSNumber).doubleValue), forKey: "date")
                } else if val is NSNumber {
                    session.setValue((val as! NSNumber).doubleValue, forKey: key as String)
                }
                
            }

        }
        
        do {
            try Datamodel.sharedInstance.container.viewContext.save()
        } catch {
            print(error)
        }
        
        if let url = Datamodel.sharedInstance.container.persistentStoreCoordinator.persistentStores.first?.url {
            
            var newURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            newURL = newURL.appendingPathComponent("dbackup.sqlite")
            
            do {
                try FileManager.default.removeItem(at: newURL)
            } catch {
                print(error)
            }
            
            if let nuStore = Datamodel.sharedInstance.container.persistentStoreCoordinator.persistentStores.first {
                //https://developer.apple.com/library/content/qa/qa1809/_index.html
                let persistentStore = try! Datamodel.sharedInstance.container.persistentStoreCoordinator.migratePersistentStore(nuStore, to: newURL, options: nil, withType: NSSQLiteStoreType)
                try! Datamodel.sharedInstance.container.persistentStoreCoordinator.remove(persistentStore)
                session.transferFile(newURL, metadata: nil)
                try! Datamodel.sharedInstance.container.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            }
            
        }
    }
    
}

