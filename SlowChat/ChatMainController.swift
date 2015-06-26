//
//  ChatMainController.swift
//  SlowChat
//
//  Created by Nigelbueno on 26-06-15.
//  Copyright (c) 2015 boydbueno. All rights reserved.
//

import UIKit
import IJReachability

class ChatMainController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !IJReachability.isConnectedToNetwork() {
            var noConnAlert = UIAlertController(title: "No internet connection", message: "Unable to view chatrooms without connection. Please check your connection and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            
            noConnAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            
            self.presentViewController(noConnAlert, animated: true, completion: nil)
        }
        
        // If not logged in and no autologin enabled, alert
        var isAutoLoginEnabled = NSUserDefaults.standardUserDefaults().boolForKey("auto_login_pref")
        var isLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("is_logged_in")
        println(isLoggedIn)
        if !isAutoLoginEnabled && !isLoggedIn {
            var alert = UIAlertController(title: "Auto login is disabled", message: "You need to login to view the chat rooms.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
                action in self.performSegueWithIdentifier("chatUserSegue", sender: self)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        // If not logged in, try to login with credentials
        if isAutoLoginEnabled && !isLoggedIn {
            var loginService = LoginService()
            var isLoginSuccess = loginService.login()
            
            if !isLoginSuccess {
                var unableToLoginAlert = UIAlertController(title: "Unable to login", message: "Please check your credentials and try again.", preferredStyle: UIAlertControllerStyle.Alert)
                
                unableToLoginAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
                    action in self.performSegueWithIdentifier("chatUserSegue", sender: self)
                }))
                
                self.presentViewController(unableToLoginAlert, animated: true, completion: nil)
            } else {
                var favoriteCategory = NSUserDefaults.standardUserDefaults().integerForKey("fav_category_pref")
                
                selectedIndex = favoriteCategory
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
