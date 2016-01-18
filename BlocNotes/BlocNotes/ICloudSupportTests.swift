//
//  ICloudSupportTests.swift
//  BlocNotes
//
//  Created by Tim Pryor on 2016-01-18.
//  Copyright © 2016 Tim Pryor. All rights reserved.
//

import UIKit
@testable import BlocNotes

class ICloudSupportTests: NSObject {

    let si = NoteStore.sharedInstance()
    
    func testSubscribeToICloudNotifications() {
        let ics = ICloudSupport()
        ics.subscribeToICloudNotifications()
        
        
    }
    
    
}
