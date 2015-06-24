import UIKit

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

