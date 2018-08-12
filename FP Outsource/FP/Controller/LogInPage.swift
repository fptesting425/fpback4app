//
//  LogInPage.swift
//  FP
//
//  Copyright © 2018 Mr. East. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class LogInPage: UIViewController {
    
    @IBOutlet weak var emailLogInTextfield: UITextField!
    @IBOutlet weak var passwordLogInTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {

        if emailLogInTextfield.text!.isEmpty {
            let alert = UIAlertController(title: "Oops", message: "Your email is empty, just like my wallet", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else if passwordLogInTextfield.text!.isEmpty {
            let alert = UIAlertController(title: "Oops", message: "Your password is empty, just like my fridge", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            SVProgressHUD.show(withStatus: "Logging In...")
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            PFUser.logInWithUsername(inBackground: emailLogInTextfield.text!, password: passwordLogInTextfield.text!) { (user, error) in
                if error != nil {
                    SVProgressHUD.dismiss()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    let alert = UIAlertController(title: "Oops", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "Retry", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    SVProgressHUD.dismiss()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.performSegue(withIdentifier: "logInToHomePage", sender: self)
                    UserDefaults.standard.set(self.emailLogInTextfield.text!, forKey: "userloggedin")
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    
    @IBAction func pauseApp(_ sender: UIButton) {
//        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
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
//          UIApplication.shared.beginIgnoringInteractionEvents()
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
    
}


// This is the function to let the keyboard dissappear when the user that anywhere else. To use it type self.hideKeyboardWhenTappedAround() in the viewDidLoad of any page.
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
