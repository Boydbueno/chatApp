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

    override func viewWillAppear(animated: Bool) {
                setFavoriteCategory()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setFavoriteCategory() {
        var favoriteCategory = NSUserDefaults.standardUserDefaults().integerForKey("fav_category_pref")
        selectedIndex = favoriteCategory
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
