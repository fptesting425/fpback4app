//
//  EditProfile.swift
//  FP
//
//  Copyright © 2018 Mr. East. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class EditProfile: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var currentUsername: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBAction func saveProfile(_ sender: UIBarButtonItem) {
        let user = PFUser.current()!
        if let image = profilePicture.image {
            if let imageData = UIImagePNGRepresentation(image) {
                let profilePic = PFFile(name: "profilePic.png", data: imageData)
                user["profilePicture"] = profilePic
                user.saveInBackground { (success, error) in
                    if error != nil {
                        SVProgressHUD.showError(withStatus: "\(error!.localizedDescription)")
                    }
                }
            }
        }
        user["username"] = usernameTextfield.text
        if usernameTextfield.text!.count <= 3 {
            let alert = UIAlertController(title: "Length", message: "Username must be at least 4 characters", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            SVProgressHUD.show(withStatus: "Uploading")
            UIApplication.shared.beginIgnoringInteractionEvents()
            user.saveInBackground { (saved, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: "\(error!.localizedDescription)")
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                else {
                    SVProgressHUD.showSuccess(withStatus: "Saved!")
                    self.performSegue(withIdentifier: "backAfterSaved", sender: self)
                    UIApplication.shared.endIgnoringInteractionEvents()

                }
            }
        }
        
    }
    
    @IBAction func profilePicture(_ sender: UIButton) {
        let alert = UIAlertController(title: "Photo", message: "Please choose a method", preferredStyle: UIAlertControllerStyle.alert)
        let library = UIAlertAction(title: "Library", style: UIAlertActionStyle.default) { (library) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (camera) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profilePicture.image = image
        }
        else {
            print("Error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = PFUser.current()!
        currentUsername.text = "Current Username: \(user["username"]!)"
        usernameTextfield.text = user["username"]! as? String
        self.hideKeyboardWhenTappedAround()
        if let image = PFUser.current()?["profilePicture"] as? PFFile {
            image.getDataInBackground { (image, error) in
                if let imageData = image {
                    if let photo = UIImage(data: imageData) {
                        self.profilePicture.image = photo
                    }
                }
            }
        }
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
