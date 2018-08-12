//
//  SearchScene.swift
//  FP
//
//  Copyright © 2018 Mr. East. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class SearchScene: UIViewController {
    
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let query = PFQuery(className: "_User")
        if searchTextfield.text != "" {
            SVProgressHUD.show(withStatus: "Searching")
            UIApplication.shared.beginIgnoringInteractionEvents()
            query.whereKey("username", equalTo: searchTextfield.text!)
            query.getFirstObjectInBackground { (user, error) in
                if error == nil && user != nil {
                    if let users = user {
                        SVProgressHUD.dismiss()
                        print(users.objectId!)
                        if let image = users["profilePicture"] as? PFFile {
                            image.getDataInBackground { (image, error) in
                                if let imageData = image {
                                    if let photo = UIImage(data: imageData) {
                                        self.profilePicture.image = photo
                                    }
                                }
                            }
                        }
                        
                        self.username.text = users["username"] as? String
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.addButton.isHidden = false
                        
                    }
                    if let userID = user?.objectId {
                        if userID == PFUser.current()?.objectId {
                            self.addButton.isHidden = true
                            self.userEmail.text = "You found yourself!"
                        }
                        else {
                            self.userEmail.text = ""
                        }
                    }
                    
            }
                else {
                    SVProgressHUD.showError(withStatus: "\(error!.localizedDescription)")
                    self.profilePicture.image = UIImage(named: "user")
                    self.username.text = "Username"
                    self.userEmail.text = ""
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.addButton.isHidden = true
                    print(error!.localizedDescription)
//                    let alert = UIAlertController(title: "Sorry", message: "There was no match with this email address, please try again", preferredStyle: UIAlertControllerStyle.alert)
//                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
//                    alert.addAction(ok)
//                    self.present(alert, animated: true, completion: nil)
                }
            }
                }
        
        
        else {
            
            UIApplication.shared.endIgnoringInteractionEvents()
            let alert = UIAlertController(title: "Empty", message: "Please enter a valid email address", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Friend Request", message: "Are you sure you want to send this user a friend request? \n\nNote: each user can only add a limited amount of friends in their Fampack.", preferredStyle: UIAlertControllerStyle.alert)
        let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (friendRequest) in
            print("Send Friend Request")
        }
        let no = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(no)
        alert.addAction(yes)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.isHidden = true
        self.hideKeyboardWhenTappedAround()
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width/2
        profilePicture.clipsToBounds = true
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

}
