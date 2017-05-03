//
//  LoginViewController.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 4/14/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    
    
    
    var ref: FIRDatabaseReference!

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            print("not nil")
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        print("Logged in")
        
        
    }
    
    
    @IBAction func applyPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Apply", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let applyMessage:String = "Submit your email address below to apply for an editor position"
        
        alert.message = applyMessage
        
        
        var textField1:UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "John.Appleseed@mynbps.org"
            textField.keyboardType = UIKeyboardType.emailAddress
            textField1 = textField
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        let submit = UIAlertAction(title: "Submit", style: UIAlertActionStyle.default) { (action) in
            
          //  let textField1 = self.alert.textFields?[0].text
            
            if (textField1?.text == "") {
                
                print("No text here. try again")
                
                
            } else {
                
                
                
                let text:String = textField1!.text!
                
                print("entered: \(text)")
                
                self.ref = FIRDatabase.database().reference()
                
               // let loc = self.ref.child("pendingEditors")
                
               // loc.setValue(text, forKey: "newEmail")
                
                
                
                self.pressedApply()
            }
        
        }
        alert.addAction(cancel)

        alert.addAction(submit)
        
        self.present(alert, animated: true, completion: nil)
    }
    func pressedApply(){
        
        let confirmAlert = UIAlertController(title: "Success", message: "Your request has been submitted", preferredStyle: UIAlertControllerStyle.alert)
        
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        
        confirmAlert.addAction(dismiss)
        
        self.present(confirmAlert, animated: true, completion: nil)
        print("applied")
        
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
