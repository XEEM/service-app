//
//  AppDelegate.swift
//  xeem-service-app
//
//  Created by Anh-Tu Hoang on 12/29/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func goToLoginPage(){
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let rootVC = storyBoard.instantiateViewControllerWithIdentifier("LoginNavigationController") as! UINavigationController
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
    }
    
    func goToMainPage(){
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewControllerWithIdentifier("RequestsNavigationViewController") as! UINavigationController
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()

    }
    
    let defaultEmail = "tuangiao@gmail.com"
    let defaultPassword = "123"
    
    func doLogin(email: String, password: String) -> () {
        XEEMService.sharedInstance.login(email, passwd: password) { (token, error) -> () in
            if let token = token {
                XEEMService.sharedInstance.getUserProfile(token) { (user, error) -> () in
                    print(user)
                    if let user = user {
                        User.currentUser = user
                        
                        // create viewController code...
                        self.goToMainPage()
                    } else {
                        // Error from get user data
                    }
                }
            } else {
                // Error from login
            }
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        if (User.currentUser == nil) {
            // auto loggin as Tuan Giao
            doLogin(defaultEmail, password: defaultPassword)
            // store user's information
        } else {
            self.goToMainPage()
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

