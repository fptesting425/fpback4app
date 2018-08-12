//
//  Feed.swift
//  FP
//
//  Copyright © 2018 Mr. East. All rights reserved.
//

import UIKit
import Parse

class Feed: UITableViewController {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var post = 5
    var userNicknameArray = [String]()
    var userProfilePictureArray = [PFFile]()
    var pictureArray = [PFFile]()
    var postTitleArray = [String]()
    var postCommentArray = [String]()
    var userIDArray = [String]()
    var dateArray = [Date?]()
    
    @objc var refresher : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isStatusBarHidden = false
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(User.refreseh), for: UIControlEvents.valueChanged)
        tableView?.addSubview(refresher)
        loadPosts()
    }
    
    @objc func refreseh() {
        tableView?.reloadData()
        refresher.endRefreshing()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //It will hide the status bar again after dismiss
        UIApplication.shared.isStatusBarHidden = false
    }
    override open var prefersStatusBarHidden: Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPosts() {
        let query = PFQuery(className: "Post")
        query.limit = post
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (object, error) in
            if error == nil && object != nil {
                self.pictureArray.removeAll()
                self.postTitleArray.removeAll()
                self.postCommentArray.removeAll()
                self.dateArray.removeAll()
                for objects in object! {
                    self.pictureArray.append(objects.value(forKey: "imageFile") as! PFFile)
                    self.postTitleArray.append(objects.value(forKey: "title") as! String)
                    self.postCommentArray.append(objects.value(forKey: "comments") as! String)
                    self.dateArray.append(objects.createdAt!)
                }
            }
            else {
                print(error!.localizedDescription)
                let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            self.tableView?.reloadData()
            self.indicator.stopAnimating()
        }
    }

    // MARK: - Table view data source
    func loadMore() {
        
        // if posts on the server are more than shown
        if post <= pictureArray.count {
            
            // start animating indicator
            indicator.startAnimating()
            
            // increase page size to load +10 posts
            post = post + 5
            
            // STEP 1. Find posts realted to people who we are following
            loadPosts()
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height * 2 {
            loadMore()
        }
    }
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pictureArray.count
    }

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(422)
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width/2
        cell.profilePicture.clipsToBounds = true
//        cell.username.text = userNicknameArray[indexPath.row]
        cell.postTitle.adjustsFontSizeToFitWidth = true
//        cell.profilePicture.image = userProfilePictureArray[indexPath.row]
        cell.postTitle.text = postTitleArray[indexPath.row]
        cell.postComment.text = postCommentArray[indexPath.row]
        cell.postComment.adjustsFontSizeToFitWidth = true
        
        pictureArray[indexPath.row].getDataInBackground { (data, error) in
            if error == nil && data != nil {
                cell.postImage.image = UIImage(data: data!)
            }
            else {
                let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        let from = dateArray[indexPath.row]
        let now = Date()
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: from!, to: now)
        
        // logic what to show: seconds, minuts, hours, days or weeks
        if difference.second! <= 0 {
            cell.postDate.text = "now"
        }
        if difference.second! > 0 && difference.minute! == 0 {
            cell.postDate.text = "\(String(describing: difference.second!))s ago"
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            cell.postDate.text = "\(String(describing: difference.minute!))m ago"
        }
        if difference.hour! > 0 && difference.day! == 0 {
            cell.postDate.text = "\(String(describing: difference.hour!))h ago"
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            cell.postDate.text = "\(String(describing: difference.day!))d ago"
        }
        if difference.weekOfMonth! > 0 {
            cell.postDate.text = "\(String(describing: difference.weekOfMonth!))w ago"
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
