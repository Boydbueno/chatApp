//
//  ChatroomController.swift
//  SlowChat
//
//  Created by Nigelbueno on 27-06-15.
//  Copyright (c) 2015 boydbueno. All rights reserved.
//

import UIKit
import IJReachability
import SwiftHTTP
import CoreData

class ChatroomController: UITableViewController {
    
    var chatrooms = [NSManagedObject]()
    
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
            loginService.login(
                NSUserDefaults.standardUserDefaults().stringForKey("username_pref")!,
                password: NSUserDefaults.standardUserDefaults().stringForKey("password_pref")!,
                successCallback: loginSuccess,
                errorCallback: loginFail
            )
        } else {
            getChatrooms()
        }
        
        loadChatrooms()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    private func getChatrooms() {
        
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context: NSManagedObjectContext = appDel.managedObjectContext!

        var request = HTTPTask()
        request.GET("http://178.62.135.117/chatrooms/games", parameters: nil, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            if let data = response.responseObject as? NSData {
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                let chatrooms = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSArray

                if chatrooms.count > 0 {
                    var request = NSFetchRequest(entityName: "Chatroom")
                    
                    request.returnsObjectsAsFaults = false
                    
                    var results = context.executeFetchRequest(request, error: nil)!
                    
                    if results.count > 0 {
                        
                        for result in results {
                            
                            context.deleteObject(result as! NSManagedObject)
                            
                            context.save(nil)
                            
                        }
                        
                    }
                    
                    for chatroom in chatrooms {
                        
                        if let title = chatroom["title"] as? String {
                            
                            if let category = chatroom["category"] as? String {
                                
                                if let id = chatroom["id"] as? Int {
                                
                                    var newChatroom: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Chatroom", inManagedObjectContext: context) as! NSManagedObject
                                
                                    newChatroom.setValue(title, forKey: "title")
                                    newChatroom.setValue(category, forKey: "category")
                                    newChatroom.setValue(id, forKey: "id")
                                
                                    context.save(nil)
                                }
                                
                            }
                            
                        }
                        
                    }
                    self.loadChatrooms()
                }
            }
        })
    }
    
    private func loadChatrooms() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Chatroom")
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest, error: nil) as? [NSManagedObject]
        
        if let results = fetchedResults {
            chatrooms = results
        } else {
            println("Could not fetch chatrooms")
        }
    }
    
    private func loginSuccess() {
        getChatrooms()
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "is_logged_in")
    }
    
    private func loginFail() {
        var unableToLoginAlert = UIAlertController(title: "Unable to login", message: "Please check your credentials and try again.", preferredStyle: UIAlertControllerStyle.Alert)
        
        unableToLoginAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            action in self.performSegueWithIdentifier("chatUserSegue", sender: self)
        }))
        
        self.presentViewController(unableToLoginAlert, animated: true, completion: nil)
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "is_logged_in")
    }
    
    func saveChatroom(title: String, category: String) {
        
        // We try to post this data
        var request = HTTPTask()
        //we have to add the explicit type, else the wrong type is inferred. See the vluxe.io article for more info.
        let params: Dictionary<String,AnyObject> = ["category": category, "title": title]
        request.POST("http://178.62.135.117/chatrooms", parameters: params, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            if let res: AnyObject = response.responseObject {
                println("response: \(res)")
            }
        })
        
        
        // On success callback, we'll throw it in coredata
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity =  NSEntityDescription.entityForName("Chatroom",
            inManagedObjectContext:
            managedContext)
        
        let chatroom = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        chatroom.setValue(title, forKey: "title")
        chatroom.setValue(category, forKey: "category")
        // Id is what we get back after post request
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }  

        chatrooms.append(chatroom)
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatrooms.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        let chatroom = chatrooms[indexPath.row]
        cell.textLabel!.text = chatroom.valueForKey("title") as? String
        
        return cell
    }
    
}
