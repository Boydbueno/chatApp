import UIKit
import IJReachability

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var automaticLoginSwitch: UISwitch!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func usernameChanged(sender: UITextField) {
        NSUserDefaults.standardUserDefaults().setValue(sender.text, forKey: "username_pref")
    }
    
    @IBAction func passwordChanged(sender: UITextField) {
        NSUserDefaults.standardUserDefaults().setValue(sender.text, forKey: "password_pref")
    }
    
    
    @IBAction func toggleAutomaticLogin(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(automaticLoginSwitch.on, forKey: "auto_login_pref")
    }
    
    @IBAction func login(sender: AnyObject) {

        if NSUserDefaults.standardUserDefaults().boolForKey("is_logged_in") {
            logout()
            return
        }
        
        // Check for internet connection
        if !IJReachability.isConnectedToNetwork() {
            var noConnAlert = UIAlertController(title: "No internet connection", message: "Unable to login with internet connection. Please check your connection and try again.", preferredStyle: UIAlertControllerStyle.Alert)
        
            noConnAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        
            self.presentViewController(noConnAlert, animated: true, completion: nil)
        }
        
        // Todo: Check credentials
        // Seperate login class
        var loginService = LoginService()
        
        loginService.login(
            usernameField.text,
            password: passwordField.text,
            successCallback: loginSuccess,
            errorCallback: loginFail
        )
        
    }
    
    private func loginFail() {
        // Not sure why, but this was required to make this work
        dispatch_async(dispatch_get_main_queue()) {
            var invalidCredentialsAlert = UIAlertController(title: "Incorrect credentials", message: "The credentials are incorrect. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
        
            invalidCredentialsAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        
            self.presentViewController(invalidCredentialsAlert, animated: true, completion: nil)
            
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "is_logged_in")
        }
    }

    private func loginSuccess() {
        // Not sure why, but this was required to make this work
        dispatch_async(dispatch_get_main_queue()) {
            var loginSuccessAlert = UIAlertController(title: "Login succeeded", message: "You have successfully logged in.", preferredStyle: UIAlertControllerStyle.Alert)
        
            loginSuccessAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        
            self.presentViewController(loginSuccessAlert, animated: true, completion: nil)
        
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "is_logged_in")
        }
    }
    
    private func logout() {
        var logoutSuccess = UIAlertController(title: "Logged out", message: "You have been succesfully logged out.", preferredStyle: UIAlertControllerStyle.Alert)
        
        logoutSuccess.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        
        self.presentViewController(logoutSuccess, animated: true, completion: nil)
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "is_logged_in")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var username = NSUserDefaults.standardUserDefaults().stringForKey("username_pref")
        var password = NSUserDefaults.standardUserDefaults().stringForKey("password_pref")
        var isAutomaticLoginActive = NSUserDefaults.standardUserDefaults().boolForKey("auto_login_pref")
        
        usernameField.text = username;
        passwordField.text = password;
        
        automaticLoginSwitch.setOn(isAutomaticLoginActive, animated: false)
        
        if NSUserDefaults.standardUserDefaults().boolForKey("is_logged_in") {
            loginButton.setTitle("Logout", forState: UIControlState.Normal)
        } else {
            loginButton.setTitle("Login", forState: UIControlState.Normal)
        }
        
        //Listen to changes in the settings
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "defaultsChanged:",
            name: NSUserDefaultsDidChangeNotification,
            object: nil
        )
    }
    
    func defaultsChanged(notification : NSNotification) {
        if NSUserDefaults.standardUserDefaults().boolForKey("is_logged_in") {
            loginButton.setTitle("Logout", forState: UIControlState.Normal)
        } else {
            loginButton.setTitle("Login", forState: UIControlState.Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

