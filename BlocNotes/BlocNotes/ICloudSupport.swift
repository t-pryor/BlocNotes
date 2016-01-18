//
//  ICloudSupport.swift
//  BlocNotes
//
//  Created by Tim Pryor on 2016-01-15.
//  Copyright © 2016 Tim Pryor. All rights reserved.
//

import UIKit
import CoreData


class ICloudSupport: NSObject {
    
    let moc = NoteStore.sharedInstance().managedObjectContext
    // &*investigate-why weak? // should this be weak??
    var psc = NoteStore.sharedInstance().persistentStoreCoordinator
    
  
//---
    func subscribeToICloudNotifications() {

        let dc = NSNotificationCenter.defaultCenter()
        dc.addObserver(
            self,
            selector: "storesWillChange",
            name: NSPersistentStoreCoordinatorStoresWillChangeNotification,
            object: psc)
        
        dc.addObserver(
            self,
            selector: "storesDidChange",
            name: NSPersistentStoreCoordinatorStoresDidChangeNotification,
            object: psc)
        
        dc.addObserver(
            self,
            selector: "persistentStoreDidImportUbiquitousContentChanges",
            name: NSPersistentStoreDidImportUbiquitousContentChangesNotification,
            object: psc)
    }
    
////---
//    // Subscribe to NSPersistentStoreDidImportUbiquitousContentChangesNotification
//    func persistentStoreDidImportUbiquitousContentChanges(notification: NSNotification) { // check note type
//        // NSLog(@"%s", __PRETTY_FUNCTION__)
//        
//        if let userInfo = notification.userInfo { print(userInfo.description); }
//        
//        moc.performBlock {
//            self.moc.mergeChangesFromContextDidSaveNotification(notification)
//        }
//    }
//    
////---
//    // Subscribe to NSPersistentStoreCoordinatorStoresWillChangeNotification
//    // most likely to be called if the user enables/disables iCloud
//    // (either globally, or just for your app) or if the user chantes iCloud accounts
//    func storesWillChange(note: NSNotification) {
//        moc.performBlockAndWait {
//            if self.moc.hasChanges {
//                do {
//                    try self.moc.save()
//                } catch {
//                    // error handling code &*-talk to Falko
//                }
//            }
//            self.moc.reset()
//        } // end closure
//        
//    }
//    
////---
//    // Subscribe to NSPersistentStoreCoordinatorStoresDidChangeNotification
//    func storesDidChange(note: NSNotification) {
//        // Here is when you can refresh your UI and
//        // load new data from the new store
//    }
//    
   
    

}
