import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Todo: Add checking the credentials and stuff
        
        var isAutoLoginEnabled = NSUserDefaults.standardUserDefaults().boolForKey("auto_login_pref")
        
        if isAutoLoginEnabled {
            if login() {
                // Show the categories
            } else {
                showCredentialsIncorrectAlert()
            }
        } else {
            showAutoLoginDisabledAlert()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showAutoLoginDisabledAlert() {
        var alert = UIAlertController(title: "Auto login is disabled", message: "Automatic login is not enabled. Do you wish to login manually now?", preferredStyle: UIAlertControllerStyle.Alert)
            
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
                
        }))
            
        alert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
            
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func showCredentialsIncorrectAlert() {
        
    }
    
    private func login() -> Bool {
        return true;
    }

}

