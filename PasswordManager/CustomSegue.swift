//
//  CustomSegue.swift
//  Password-manager-OS
//
//  Created by Kristina Mateva on 14.10.24.
//

import Cocoa

class CustomSegue: NSStoryboardSegue {
    override func perform() {
        if let fromViewController = sourceController as? NSViewController {
            if let toViewController = destinationController as? NSViewController {
                // no animation.
                fromViewController.view.window?.contentViewController = toViewController
            }
        }
    }
}
