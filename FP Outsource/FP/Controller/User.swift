//
//  User.swift
//  FP
//
//  Copyright © 2018 Mr. East. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class User: UICollectionViewController {

    @objc var refresher : UIRefreshControl!
    var page: Int = 6
    var pictureArray = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(User.refreseh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        loadPosts()
    }
    
    @objc func refreseh() {
        collectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    func loadPosts() {
        let query = PFQuery(className: "Post")
        query.whereKey("toUser", equalTo: PFUser.current()!)
        query.limit = page
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (object, error) in
            if error == nil && object != nil {
                self.pictureArray.removeAll(keepingCapacity: false)
                for objects in object! {
                    self.pictureArray.append(objects.value(forKey: "imageFile") as! PFFile)
                }
        }
            else {
                print(error!.localizedDescription)
                let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            self.collectionView?.reloadData()
        }
    }
    
    func loadMore() {
        if page <= pictureArray.count {
            page = page + 5
            loadPosts()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height * 2 {
            loadMore()
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // The number of sections you have to provide
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Number of Items in this section at least it should be 1
        return pictureArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UserCell
        
        pictureArray[indexPath.row].getDataInBackground { (data, error) in
            if error == nil && data != nil {
                cell.cellImage.image = UIImage(data: data!)
            }
            else {
                let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        // Configure the cell
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind:  UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! UserHeaderView
        header.userEmail.text = PFUser.current()!.email
        header.userChosenName.text = PFUser.current()!.username
        header.profilePicture.layer.cornerRadius = header.profilePicture.frame.size.width/2
        header.profilePicture.clipsToBounds = true
        if let image = PFUser.current()?["profilePicture"] as? PFFile {
            image.getDataInBackground { (image, error) in
                if let imageData = image {
                    if let photo = UIImage(data: imageData) {
                        header.profilePicture.image = photo
                    }
                }
            }
        }
        return header
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        let no = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
        let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (logout) in
            
            SVProgressHUD.show(withStatus: "Logging Out...")
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            PFUser.logOutInBackground { (error) in
                if error != nil {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Oops", message: "There's something wrong, please try again", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                else {
                    SVProgressHUD.dismiss()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.performSegue(withIdentifier: "logOut", sender: self)
                    UserDefaults.standard.set(nil, forKey: "userloggedin")
                    UserDefaults.standard.synchronize()
                }
            }
        }
        alert.addAction(no)
        alert.addAction(yes)
        self.present(alert, animated: true, completion: nil)
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
