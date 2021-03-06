//
//  AppDelegate.swift
//  SwiftySheetsDemo
//
//  Created by Agnes Vasarhelyi on 03/07/16.
//  Copyright © 2016 Agnes Vasarhelyi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		let splitViewController = self.window!.rootViewController as! UISplitViewController
		let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
		navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
		splitViewController.delegate = self

		do {
			let stylesheet = NSBundle.mainBundle().pathForResource("label", ofType: "style")
			let context = try SwiftyParser.sharedInstance.parseFile(stylesheet!)
			
			StyleProcessor.processContext(context)
		} catch {
			print("An error ocurred: \(error)")
		}

		return true
	}

	// MARK: - Split view

	func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
	    guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
	    guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
	    if topAsDetailController.detailItem == nil {
	        // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
	        return true
	    }
	    return false
	}

}

