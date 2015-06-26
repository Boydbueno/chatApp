import UIKit
import IJReachability

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var automaticLoginSwitch: UISwitch!
    
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

        // Check for internet connection
        if !IJReachability.isConnectedToNetwork() {
            var noConnAlert = UIAlertController(title: "No internet connection", message: "Unable to login with internet connection. Please check your connection and try again.", preferredStyle: UIAlertControllerStyle.Alert)
        
            noConnAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        
            self.presentViewController(noConnAlert, animated: true, completion: nil)
        }
        
        // Todo: Check credentials
        // Seperate login class
        var loginService = LoginService()
        
        var isLoginSuccess = loginService.login()
        
        if !isLoginSuccess {
            var invalidCredentialsAlert = UIAlertController(title: "Incorrect credentials", message: "The credentials are incorrect. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            
            invalidCredentialsAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            
            self.presentViewController(invalidCredentialsAlert, animated: true, completion: nil)
        } else {
            var loginSuccessAlert = UIAlertController(title: "Login succeeded", message: "You have successfully logged in.", preferredStyle: UIAlertControllerStyle.Alert)
            
            loginSuccessAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            
            self.presentViewController(loginSuccessAlert, animated: true, completion: nil)
        
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "is_logged_id")
        }
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

