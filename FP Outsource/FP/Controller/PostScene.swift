//
//  PostScene.swift
//  FP
//
//  Copyright © 2018 Mr. East. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class PostScene: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postComments: UITextField!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imagePost.image = image
        }
        else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imagePost.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImage (_ sender: UIButton) {
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
    
    @IBAction func post(_ sender: UIBarButtonItem) {
        if imagePost.image == UIImage(named: "round-help-button") {
            let alert = UIAlertController(title: "Picture", message: "Please choose an image", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else if postTitle.text == "" {
            let alert = UIAlertController(title: "Empty", message: "Title can not be empty", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else if postTitle.text != "" && imagePost.image != UIImage(named: "round-help-button") {
            UIApplication.shared.beginIgnoringInteractionEvents()
            let post = PFObject(className: "Post")
            post.setObject(PFUser.current()!, forKey: "toUser")
            post["userID"] = PFUser.current()?.objectId
            post["toUser"] = PFUser.current()
            post["title"] = postTitle.text
            if postComments.text != nil {
            post["comments"] = postComments.text
            }
            else {
            post["comments"] = ""
            }
            if let image = imagePost.image {
                SVProgressHUD.show(withStatus: "Posting")
                if let imageData = UIImagePNGRepresentation(image) {
                    let imageFile = PFFile(name: "image.png", data: imageData)
                    post["imageFile"] = imageFile
                    
            post.saveInBackground { (success, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: "\(error!.localizedDescription)")
                    UIApplication.shared.endIgnoringInteractionEvents()
                    print("\(error!.localizedDescription)")
                }
                else {
                    SVProgressHUD.showSuccess(withStatus: "Posted!")
                    self.imagePost.image = UIImage(named: "round-help-button")
                    self.postTitle.text = ""
                    self.postComments.text = ""
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
               }
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
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
