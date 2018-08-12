//
//  ResetPassword.swift
//  FP
//
//  Copyright © 2018 Mr. East. All rights reserved.
//

import UIKit
import Parse

class ResetPassword: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBAction func resetButton(_ sender: UIButton) {
        if emailTextfield.text == "" {
            let alert = UIAlertController(title: "Empty", message: "Please enter a valid email address", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            PFUser.requestPasswordResetForEmail(inBackground: emailTextfield.text!) { (success, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                    let retry = UIAlertAction(title: "Retry", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(retry)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: "Success", message: "Please check your email to reset your password.", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    self.performSegue(withIdentifier: "goBackToLoginPage", sender: self)
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        UIApplication.shared.isStatusBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //It will hide the status bar again after dismiss
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override open var prefersStatusBarHidden: Bool {
        return true
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

}
