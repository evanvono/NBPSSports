//
//  LoginViewController.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 4/14/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//

import UIKit
import Firebase
import SwiftSpinner


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var keyboardShowing = false
    
    var ref: FIRDatabaseReference!

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            self.hideKeyboardWhenTappedAround()
        }
        
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
            
        }

        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if keyboardShowing == false {
            
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
            keyboardShowing = true
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardShowing == true {
            
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0{
                    self.view.frame.origin.y += keyboardSize.height
                }
            }
            keyboardShowing = false
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
   
    
    @IBAction func loginPressed(_ sender: Any) {
    
        
        
        
        if emailField.text != ""{
            
            if passwordField.text != ""{
                
                SwiftSpinner.show("Logging in...", animated: true)
                
                let email = emailField.text
                let password = passwordField.text
                
                FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
                    if let error = error {
                        
                       
                        
                        let alertController = UIAlertController(title: "Error", message: "Login failed. Please make sure that you have entered your email and password correctly", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                        
                            alertController.addAction(UIAlertAction(title: "iForgot", style: UIAlertActionStyle.default, handler: { (action) in
                                
                                let prompt = UIAlertController.init(title: nil, message: "Email:", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default) { (action) in
                                    let userInput = prompt.textFields![0].text
                                    prompt.textFields![0].placeholder = "Go.Eagles@mynbps.org"
                                    if (userInput!.isEmpty) {
                                        return
                                    }
                                    FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!) { (error) in
                                        if let error = error {
                                            print(error.localizedDescription)
                                            return
                                        }
                                    }
                                }
                                prompt.addTextField(configurationHandler: nil)
                                prompt.addAction(okAction)
                                self.present(prompt, animated: true, completion: nil)
                                
                            }))
                        
                        SwiftSpinner.hide({
                            self.present(alertController, animated: true, completion: nil)
                        })
                        
                        
                        
                        return
                    }
                    
                    SwiftSpinner.hide()
                    
                    self.signedIn(user!)
                    
                })
                
            } else {
                
                let alertController = UIAlertController(title: "Error", message: "Please enter a password", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
            }
        } else {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter your email address", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func applyPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Apply", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let applyMessage:String = "Submit your email address below to apply for an editor position"
        
        alert.message = applyMessage
        
        
        var textField1:UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "Go.Eagles@mynbps.org"
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
                
                let loc = self.ref.child("Editors")
                
                
                
                
                let newGameRef = loc.childByAutoId()
                
                let newGameID = newGameRef.key
                
                
                loc.child(String(newGameID)).setValue(text, withCompletionBlock: { (error, ref) in
                    
                    
                    if error == nil {
                        
                        self.pressedApply()

                        
                    } else {
                        
                        
                        let errorContr = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let applyMessage1:String = "There was an error submitting your email."
                        
                        errorContr.message = applyMessage1
                        
                        
                        let cancell = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil)
                        
                        errorContr.addAction(cancell)
                        
                        self.present(errorContr, animated: true, completion: nil)
                    }
                    
                })
                
                
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
    
    func signedIn(_ user: FIRUser?) {
        
        AppState.sharedInstance.displayName = String(user?.displayName ?? (user?.email)!).components(separatedBy: "@")[0]        //AppState.sharedInstance.photoUrl = user?.photoURL
        
        Constants.UserDetails.email = String(user!.email!)
        AppState.sharedInstance.signedIn = true
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NotificationKeys.SignedIn), object: nil, userInfo: nil)
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Base") as! UIViewController
        self.present(vc, animated: true, completion: nil)
        
        print("successfully signed in")
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
