//
//  SignUpUserInfoPage.swift
//  FP
//
//  Copyright © 2018 Mr. East. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class SignUpUserInfoPage: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userInfoSave(_ sender: UIButton) {
        
        if username.text != "" && username.text!.count > 3 {
            SVProgressHUD.show(withStatus: "Saving Username..")
            let user = PFUser.current()!
            user.username = username.text! // attempt to change username
            user.saveInBackground { (success, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: "\(error!.localizedDescription)")
                }
                else {
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "goToHomePage", sender: self)
                }
            }
           
        }
        else if username.text! == "" {
            let alert = UIAlertController(title: "Oops", message: "Your username cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else if username.text!.count <= 3 {
            let alert = UIAlertController(title: "Length", message: "Username must be at least 4 characters", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func skip(_ sender: UIButton) {
        let alert = UIAlertController(title: "Skip", message: "Your username will be set as your email address, are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        let no = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
        let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (skip) in
            self.performSegue(withIdentifier: "goToHomePage", sender: self)
        }
        alert.addAction(no)
        alert.addAction(yes)
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
