//
//  GamesController.swift
//  SlowChat
//
//  Created by Nigelbueno on 27-06-15.
//  Copyright (c) 2015 boydbueno. All rights reserved.
//

import UIKit
import CoreData

class GamesController: ChatroomController {
    
    @IBAction func createChatroom(sender: AnyObject) {
        var alert = UIAlertController(title: "New chatroom", message: "Enter the title of the chatroom", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Create", style: .Default) { (action: UIAlertAction!) -> Void in
            let textField = alert.textFields![0] as! UITextField
            self.saveChatroom(textField.text, category: "games")
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
