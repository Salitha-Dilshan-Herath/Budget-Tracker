//
//  MainSplitVC.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-05.
//

import UIKit

class MainSplitVC: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        svc.presentsWithGesture = displayMode != .oneBesideSecondary
    }
}
