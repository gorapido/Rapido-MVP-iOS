//
//  AppDelegate.swift
//  Rapido
//
//  Created by Alexander Hernandez on 4/10/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Parse.enableLocalDatastore()
    
    Parse.setApplicationId("cJa6opkW95Jqat6TYQ92UHCqimkZwm8Wdb40kxAY",
      clientKey: "mpdNC6SshAPwaY8DvDRQp1v8YxKIjAn1C3W8Nz07")
    
    let userNotificationTypes = (UIUserNotificationType.Alert |
      UIUserNotificationType.Badge |
      UIUserNotificationType.Sound);
    
    let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
    
    application.registerUserNotificationSettings(settings)
    application.registerForRemoteNotifications()
    
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
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    let user = PFUser.currentUser()
    
    if user != nil {
      let installation = PFInstallation.currentInstallation()
    
      installation["user"] = user
      
      installation.setDeviceTokenFromData(deviceToken)
      installation.saveInBackgroundWithBlock { (success: Bool, err: NSError?) -> Void in
      
      }
    }
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    
    completionHandler(UIBackgroundFetchResult.NewData)
  }
  
}

