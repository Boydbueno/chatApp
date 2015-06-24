import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Todo: Add checking the credentials and stuff
        
        showAlertIfNotLoggedIn()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "defaultsChanged:",
            name: NSUserDefaultsDidChangeNotification,
            object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func defaultsChanged(notification : NSNotification) {
        showAlertIfNotLoggedIn()
    }
    
    private func showAlertIfNotLoggedIn() {
        var isLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("auto_login_pref")
        
        if !isLoggedIn {
            var alert = UIAlertController(title: "You're not logged in!", message: "Automatic login is not enabled. Do you wish to login manually now?", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
                
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }


}

