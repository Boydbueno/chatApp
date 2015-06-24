//
//  CategoryPrefViewController.swift
//  SlowChat
//
//  Created by Nigelbueno on 24-06-15.
//  Copyright (c) 2015 boydbueno. All rights reserved.
//

import UIKit

class CategoryPrefViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var categoryPicker: UIPickerView!

    var categories = ["Sport", "Games", "Finance", "Animals"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Listen to changes in the settings
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "defaultsChanged:",
            name: NSUserDefaultsDidChangeNotification,
            object: nil
        )
        
        updatePickerWithActive()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func defaultsChanged(notification : NSNotification) {
        updatePickerWithActive()
    }
    
    func updatePickerWithActive() {
        // Do any additional setup after loading the view.
        var category = NSUserDefaults.standardUserDefaults().integerForKey("fav_category_pref")
        categoryPicker.selectRow(category, inComponent: 0, animated: false)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return categories[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(row, forKey: "fav_category_pref")
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
