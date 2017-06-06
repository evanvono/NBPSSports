//
//  TransitionViewController.swift
//  Pods
//
//  Created by Evan Von Oehsen on 6/6/17.
//
//

import UIKit

class TransitionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if AppState.sharedInstance.signedIn{
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "AccountNC") as! UINavigationController
            self.present(vc, animated: false, completion: nil)
            
        } else {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "LoginNC") as! UINavigationController
            self.present(vc, animated: false, completion: nil)
        }
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
