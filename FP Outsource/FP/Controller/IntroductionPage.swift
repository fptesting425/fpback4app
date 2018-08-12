//
//  IntroductionPage.swift
//  FP
//
//  Copyright © 2018 Mr. East. All rights reserved.
//

import UIKit

class IntroductionPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //It will show the status bar again after dismiss
        UIApplication.shared.isStatusBarHidden = true
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
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
