//
//  NewGameViewController.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 6/7/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//

import UIKit
import Firebase

class NewGameViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var sportPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    

    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    @IBOutlet weak var defaultLabel: UILabel! //explains default values for each entry or other tips
    
    @IBOutlet weak var homeNameField: UITextField!
    @IBOutlet weak var awayNameField: UITextField!
    @IBOutlet weak var homeScoreField: UITextField!
    @IBOutlet weak var awayScoreField: UITextField!
    
    var selection:String!
    
    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle?

    
    var sports = [String]()
    var sportsTitles = Dictionary<String,String>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultLabel.text = "Please select the sport above"
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        
        datePicker.date = Date.today()
        
        
        fillSports()
        
        self.hideKeyboardWhenTappedAround()

        
        
    }

    func fillSports(){
        
        sports = ["Football","Boys Soccer", "Girls Soccer", "Boys Basketball", "Girls Basketball", "Volleyball"]
        sportsTitles = ["Football":"Football","Boys Soccer":"BSoccer", "Girls Soccer":"GSoccer", "Boys Basketball":"BBasketball", "Girls Basketball":"GBasketball", "Volleyball":"Volleyball"]
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
        
        ref = FIRDatabase.database().reference()
        
        let date = Int(datePicker.date.timeIntervalSince1970)
        let homeTeam = homeNameField.text
        let awayTeam = awayNameField.text
        var homeScore = Int(homeScoreField.text!)
        var awayScore = Int(awayScoreField.text!)
        
        let title = sports[sportPicker.selectedRow(inComponent: 0)]
        
        let newGameRef = self.ref.child("Sports").child(sportsTitles[title]!).childByAutoId()
        
        
        let timeStamp = Int(NSDate.timeIntervalSinceReferenceDate*1000) //Will give you a unique id every second or even millisecond if you want..
        
        if homeScore == nil {
            
            homeScore = 0
            
        } else  if awayScore == nil {
            
            
            awayScore = 0
            
        }
        
        if homeTeam == "" || awayTeam == "" || homeScoreField.text == "" || awayScoreField.text == ""
        {
            
            let alert = UIAlertController(title: "Some Items are Empty", message: "Please fill in every field before creating a new game", preferredStyle: UIAlertControllerStyle.alert)
            
            let action = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            var newGameData = [
                "game": timeStamp,
                "homeTeam": homeTeam! as NSString,
                "homeScore": homeScore! as Int,
                "awayTeam": awayTeam! as NSString,
                "awayScore": awayScore! as Int,
                "date": date,
                "editing": false,
                "time": "Upcoming"
                
                ] as [String : Any]
            
            
            if sportsTitles[title]! == "Football" {
                
                newGameData = [
                    "game": timeStamp,
                    "homeTeam": homeTeam! as NSString,
                    "homeScore": homeScore! as Int,
                    "awayTeam": awayTeam! as NSString,
                    "awayScore": awayScore! as Int,
                    "date": date,
                    "editing": false,
                    "time": "Upcoming",
                    "possession": "None"
                    
                    ] as [String : Any]
            } else if sportsTitles[title]! == "Volleyball" {
                
                newGameData = [
                    "game": timeStamp,
                    "homeTeam": homeTeam! as NSString,
                    "homeScore": [0,0,0,0,0,0],
                    "awayTeam": awayTeam! as NSString,
                    "awayScore": [0,0,0,0,0,0],
                    "date": date,
                    "editing": false,
                    "time": "Upcoming",
                    "possession": "None"
                    
                    ] as [String : Any]
            } else if sportsTitles[title]! == "BSoccer" {
                
                newGameData = [
                    "game": timeStamp,
                    "homeTeam": homeTeam! as NSString,
                    "homeScore": homeScore! as Int,
                    "awayTeam": awayTeam! as NSString,
                    "awayScore": awayScore! as Int,
                    "date": date,
                    "editing": false,
                    "time": "Upcoming"
                    
                    ] as [String : Any]
            }  else if sportsTitles[title]! == "GSoccer" {
                
                newGameData = [
                    "game": timeStamp,
                    "homeTeam": homeTeam! as NSString,
                    "homeScore": homeScore! as Int,
                    "awayTeam": awayTeam! as NSString,
                    "awayScore": awayScore! as Int,
                    "date": date,
                    "editing": false,
                    "time": "Upcoming"
                    
                    ] as [String : Any]
            } else if sportsTitles[title]! == "BBasketball" {
                
                newGameData = [
                    "game": timeStamp,
                    "homeTeam": homeTeam! as NSString,
                    "homeScore": homeScore! as Int,
                    "awayTeam": awayTeam! as NSString,
                    "awayScore": awayScore! as Int,
                    "date": date,
                    "editing": false,
                    "time": "Upcoming"
                    
                    ] as [String : Any]
            } else if sportsTitles[title]! == "GBasketball" {
                
                newGameData = [
                    "game": timeStamp,
                    "homeTeam": homeTeam! as NSString,
                    "homeScore": homeScore! as Int,
                    "awayTeam": awayTeam! as NSString,
                    "awayScore": awayScore! as Int,
                    "date": date,
                    "editing": false,
                    "time": "Upcoming"
                    
                    ] as [String : Any]
            
            }
            
            
            
            
            self.ref.child("Sports").child(sportsTitles[title]!).child(String(timeStamp)).setValue(newGameData)
            
            self.navigationController?.popToRootViewController(animated: true)
            
        }
        
        
    }
    
    func back(){
        
        clear()
        //self.navigationController?.dismiss(animated: true, completion: nil)
        
        //self.navigationItem.
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selection = sports[row]
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
    @IBAction func didTapHome(_ sender: Any) {
        
        homeNameField.text = "North Broward Prep"
        
        if awayNameField.text == "North Broward Prep"{
            
            awayNameField.text = ""
        }
        
    }
    
    @IBAction func didTapAway(_ sender: Any) {
        
        awayNameField.text = "North Broward Prep"
        if homeNameField.text == "North Broward Prep"{
            
            homeNameField.text = ""
        }
        
    }
    deinit {
        
        ref.removeAllObservers()
    }
}


