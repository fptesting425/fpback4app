//
//  SignUpPage.swift
//  FP
//
//  Copyright © 2018 Mr. East. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class SignUpPage: UIViewController {
    
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextfield: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    
    func userSignUp(){
        let user = PFUser()
        
        user.username = signUpEmailTextField.text
        user.password = signUpPasswordTextfield.text
        user.email = signUpEmailTextField.text

        user.signUpInBackground { (success, error) in
            if error != nil {
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                SVProgressHUD.dismiss()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.performSegue(withIdentifier: "registerUserInfo", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpRegisterButtonPressed(_ sender: UIButton) {
        
        if signUpEmailTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Oops", message: "Your email is empty, just like my wallet", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else if signUpPasswordTextfield.text!.isEmpty {
            let alert = UIAlertController(title: "Oops", message: "Your password is empty, just like my fridge", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else if retypePassword.text!.isEmpty {
            let alert = UIAlertController(title: "Retype Password", message: "Please retype your password to ensure it matches", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else if retypePassword.text != signUpPasswordTextfield.text {
            let alert = UIAlertController(title: "Password", message: "Your passwords do not match, please try again", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (reset) in
                self.retypePassword.text = ""
                self.signUpPasswordTextfield.text = ""
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else if signUpPasswordTextfield.text!.count < 8 {
            let alert = UIAlertController(title: "Password Length", message: "Password must be minimum 8 characters", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else if signUpEmailTextField.text! == signUpPasswordTextfield.text! {
            let alert = UIAlertController(title: "Password", message: "Password cannot be the same as your email address", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            SVProgressHUD.show(withStatus: "Registering...")
            UIApplication.shared.beginIgnoringInteractionEvents()
            userSignUp()
            UserDefaults.standard.set(self.signUpEmailTextField.text!, forKey: "userloggedin")
            UserDefaults.standard.synchronize()
        }
    }
   
    @IBAction func pauseApp(_ sender: UIButton) {
//        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//
//        activityIndicator.center = self.view.center
//
//        activityIndicator.hidesWhenStopped = true
//
//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//
//        view.addSubview(activityIndicator)
//
//        activityIndicator.startAnimating()
//
//        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //It will show the status bar again after dismiss
        UIApplication.shared.isStatusBarHidden = true
    }
    
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //It will hide the status bar again after dismiss
        UIApplication.shared.isStatusBarHidden = false
    }
    override open var prefersStatusBarHidden: Bool {
        return true
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
