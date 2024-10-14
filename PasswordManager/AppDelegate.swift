//
//  ContentView.swift
//  Password-manager-OS
//
//  Created by Kristina Mateva on 14.10.24.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        TimerManager.manager.fireExistTimer()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        TimerManager.manager.stopTimer()
    }
}
