//
//  NewGameViewController.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 6/7/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var sportPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var homeNameLabel: UILabel!
    @IBOutlet weak var awayNameLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    @IBOutlet weak var defaultLabel: UILabel! //explains default values for each entry or other tips
    
    @IBOutlet weak var homeNameField: UITextField!
    @IBOutlet weak var awayNameField: UITextField!
    @IBOutlet weak var homeScoreField: UITextField!
    @IBOutlet weak var awayScoreField: UITextField!
    
    var sports = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultLabel.text = "Please select the sport above"
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        
        datePicker.date = Date.today()
        
        
        fillSports()
        
    }

    func fillSports(){
        
        sports = ["Football","Boys Soccer", "Girls Soccer", "Boys Basketball", "Girls Basketball"]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    // returns the # of rows in each component..
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return sports.count
    }

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        return sports[row]
    }
    @IBAction func didTouchHTeam(_ sender: Any) {
        
        defaultLabel.text = "Location is tied to this game"
    }
    @IBAction func didTouchATeam(_ sender: Any) {
        
        defaultLabel.text = "Be sure to use consistent naming"
        
    }
    
    @IBAction func didTouchHScore(_ sender: Any) {
        
        defaultLabel.text = "Default is 0"
    }
    
    @IBAction func didTouchAScore(_ sender: Any) {
        
        defaultLabel.text = "Default is 0"
        
    }
    
    @IBAction func didTouchCancel(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let applyMessage:String = "All entered information will be lost"
        
        alert.message = applyMessage
        
        
        let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
        
        let submit = UIAlertAction(title: "I'm Sure", style: UIAlertActionStyle.default) { (action) in
            
            self.back()
            
        }
        alert.addAction(cancel)
        
        alert.addAction(submit)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func didTouchCreate(_ sender: Any) {
        
        let date = Int(datePicker.date.timeIntervalSince1970)
        let homeTeam = homeNameField.text
        let awayTeam = awayNameField.text
        let homeScore = homeScoreField.text
        let awayScore = awayScoreField.text
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    func back(){
        
        clear()
        //self.navigationController?.dismiss(animated: true, completion: nil)
        
        //self.navigationItem.
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func clear(){
        
        homeNameField.text = ""
        awayNameField.text = ""
        homeScoreField.text = ""
        awayScoreField.text = ""
        
        datePicker.date = Date.today()
        
        
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
