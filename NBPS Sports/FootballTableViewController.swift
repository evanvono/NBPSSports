// Version 0.030

//  FootballTableViewController.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 3/5/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//

import UIKit
import Firebase
import Timepiece
import Social
import TwitterKit
import SwiftSpinner

class FootballTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    //Editor View
    @IBOutlet weak var editField: UITextField!
    @IBOutlet weak var editorLabel: UILabel!
    @IBOutlet var editorView: UIView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var awayLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    @IBOutlet weak var homeScoreStepper: UIStepper!
    @IBOutlet weak var awayScoreStepper: UIStepper!
    @IBOutlet weak var gameDatePicker: UIDatePicker!
    @IBOutlet weak var isEditingSwitch: UISwitch!
    @IBOutlet weak var editorNavigationBar: UINavigationBar!
    @IBOutlet weak var editorProgress: UIActivityIndicatorView!
    @IBOutlet weak var timePicker: UIPickerView!
    
    
    
    //Spectator View
    @IBOutlet weak var spectatorView: UIView!
    
    
    
    var homeScoreVal: Int!
    var awayScoreVal: Int!
    var gameDateVal: Date!
    
    var selectedPath = [Int]()
    
    var blurEffect: UIBlurEffect!
    var blurEffectView: UIVisualEffectView!
    var tintView:UIView!
    
    var currentGame: String!
    var checkTimer:Timer!
    
    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle?
    var connectedRef: FIRDatabaseReference!
    

    var  pastGame = true
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var editorOpen:Bool!
    
    
    
    var pickerComponents = [Dictionary<String,String>]()
    
    var timePickerComponents = [Dictionary<String,String>]()
    
    var pickerSelection = 0
    
    var todaySection = -1
    
    var hidden = false
    
 //   var games: [[Dictionary<String,String>]]?
    var gamesArray = [FIRDataSnapshot]()
    var games = [[Dictionary<String, Any>]]()
    
    //var games = [[["Game":0, "Year":2016,"Month":3,"Day":12]],[["Game":1, "Year":2017,"Month":3,"Day":18]]]
    
    var gamesCount = 0
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    @IBOutlet weak var homeFootball: UIButton!
    @IBOutlet weak var awayFootball: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false

        AppState.sharedInstance.displayName = "Football"
        AppState.sharedInstance.databaseRef = "Football"
        
        self.hideKeyboardWhenTappedAround()
        
        
        
        tintView = UIView(frame: CGRect(x: 0 , y: 0, width: self.view.bounds.width, height: self.view.bounds.height + 200))
        self.tintView.backgroundColor = UIColor.darkGray
        self.tintView.isUserInteractionEnabled = false
        self.tintView.alpha = 0.0

        editorOpen = false

        
        self.navigationController?.view.addSubview(tintView)
        
        
        if AppState.sharedInstance.signedIn {
            
            self.tableView.allowsSelection = true
            
        } else {
            
            self.tableView.allowsSelection = false

        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Football-Blurred"))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        tableView.backgroundView = imageView
        
        
        self.title = "Football"
        
        SwiftSpinner.show("Loading Football Games...")
        
        
        self.hideKeyboardWhenTappedAround()

        
        ref = FIRDatabase.database().reference()
        
        
        
        
        
        editorView.layer.cornerRadius = 10
        editorView.layer.masksToBounds = true

        
        
        editorOpen = false
        
        fillPicker()
        
        picker.reloadComponent(0)
        
        //navigationController?.hidesBarsOnSwipe = true
        checkTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.checkConnection), userInfo: nil, repeats: true)
        
        
        if self.revealViewController() != nil {
            print("not nil")
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
        }
        
        
        /*
        let when = DispatchTime.now() + 5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.checkConnection()
        }*/
        
        //timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false

        
        
        homeScoreStepper.minimumValue = 0
        awayScoreStepper.minimumValue = 0
        homeScoreStepper.maximumValue = 200
        awayScoreStepper.maximumValue = 200
        
        
        
        getNewData()
        
        getChangedData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FootballTableViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FootballTableViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    public func getSport() -> String {
        
        return "Football"
        
        
        
    }
  /*  deinit {
        
        
        

        if let refHandle = _refHandle {
            
            
            self.ref.child("Sports").removeObserver(withHandle: refHandle)
            
            FIRDatabase.database().reference(withPath: ".info/connected").removeAllObservers()
            
            
        }
        
        
        
        self.ref.child("Sports").removeAllObservers()
        self.ref.child("Sports").child("Football").removeAllObservers()
    }
    */
    override func viewDidDisappear(_ animated: Bool) {
        
        ref.removeAllObservers()
        checkTimer.invalidate()
        
        
    }
    
    
    func checkConnection(){
        
        
        
        connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
        _refHandle = connectedRef.observe(.value, with: { snapshot in
            
            
            if let connected = snapshot.value as? Bool, connected {
                
                //SwiftSpinner.appearance().tintColor = UIColor.green
                
                if self.hidden {
                    
                    print("hidden")
                    
                } else {
                    SwiftSpinner.show("Downloading Data...").addTapHandler({
                        
                        
                        SwiftSpinner.hide()
                        self.hidden = true
                        
                        
                        
                    }, subtitle: "Tap anywhere to cancel.")
                    
                    self.tableView.reloadData()
                }
                self.title = "Football"
                self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
            } else {
                self.title = "Football"
                    
                    
                self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.red]
                    
                if self.hidden {
                        
                       // print("hidden")
                        
                } else {
                        
                    
                    SwiftSpinner.appearance().tintColor = UIColor.red
                    SwiftSpinner.show("Failed to connect, tap to dismiss.", animated: false).addTapHandler({
                    
                        
                        SwiftSpinner.hide()
                    
                        self.hidden = true
                    
                    
                    }, subtitle: "Please check your connection; your content will load automatically.")
                }
                    
            }
        })
        
    }
    
    func fillPicker(){
        
        pickerComponents.append(["Title":"Home Team", "Value":"homeTeam"])
        pickerComponents.append(["Title":"Away Team", "Value":"awayTeam"])
        
        let times = ["Upcoming","Pregame","Delayed","Q1","Q2","Half","Q3","Q4","OT","Final","Canceled"]
        
        for i in times {
            
            timePickerComponents.append(["Title":i,"Value":i])
        }
        
        //pickerComponents.append(["Title":"Date", "Value":"date"])
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    
    
    
    func keyboardWillShow(_ notification: NSNotification){
        
        print("keyboard is here")
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        
        if editorOpen == false {
            
            self.editorView.transform = CGAffineTransform( translationX: 0.0, y: -keyboardHeight)
            
            editorOpen = true
            
        }
        
    }
    
    func keyboardWillHide(_ notification: NSNotification){
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        
        if editorOpen == true {
            
            self.editorView.transform = CGAffineTransform( translationX: 0.0, y: 0.0)
            
            editorOpen = false
        }
        
        
        print("keyboard gone")
    }

    
    
    func animateIn(){
        
        editorOpen = true
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: false)
        //self.navigationController?.navigationBar.isHidden = true
        
        //navigationController?.hidesBarsOnSwipe = false
        //blurView.
        
        
        //editorView.frame = CGRect(x: self.view.bounds.width/2 , y: self.view.bounds.height/2+60, width: self.view.bounds.width-30, height: self.view.bounds.height-300)
        
        editField.text = ""
        
        editorView.frame = CGRect(x: self.view.bounds.width/2 , y: self.view.bounds.height/2-40, width: self.view.bounds.width-30, height: 380)
        
        self.navigationController?.view.addSubview(editorView)
        editorView.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 40)
            
            //self.view.center
        
        
        editorView.transform = CGAffineTransform.init(scaleX: 0.6, y:0.6)
        
       // NSLayoutConstraint(item: editorView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 20.0).isActive = true
        
        //NSLayoutConstraint(item: editorView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: 20.0).isActive = true
        let currGame = games[selectedPath[0]][selectedPath[1]]
        gameDatePicker.date = currGame["Date"] as! Date!
        let time = (currGame["Snapshot"] as! FIRDataSnapshot).childSnapshot(forPath: "time").value as! String
        
        let possession = (currGame["Snapshot"] as! FIRDataSnapshot).childSnapshot(forPath: "possession").value as! String
        
        if possession == "Home" {
            
            homeFootball.tintColor = UIColor.green
            
            awayFootball.tintColor = UIColor.black
            
            
            
        } else if possession == "Away" {
            
            awayFootball.tintColor = UIColor.green
            
            homeFootball.tintColor = UIColor.black
            
        } else {
            
            
            homeFootball.tintColor = UIColor.black
            
            awayFootball.tintColor = UIColor.black
            
        }
        
        
        for i in 0..<timePickerComponents.count {
            
            let temp = timePickerComponents[i]["Title"]
            
            if temp == time {
                
                
                timePicker.selectRow(i, inComponent: 0, animated: true)
                
                break
            }
            
        }
        
        
        let boolState = (currGame["Snapshot"] as! FIRDataSnapshot).childSnapshot(forPath: "editing").value as! Bool
        
        isEditingSwitch.setOn(boolState, animated: true)
        
        
        
        
        
        
        editorView.alpha = 0
        
        self.tintView.frame = CGRect(x: 0 , y: 0, width: self.view.bounds.width, height: self.view.bounds.height + 200)
        
        
        self.tintView.isUserInteractionEnabled = true
        
        /*
        self.blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        
        self.blurEffectView = UIVisualEffectView(effect: self.blurEffect)
        self.blurEffectView.frame = CGRect(x: 0 , y: 0, width: self.view.bounds.width, height: self.view.bounds.height + 200)
        
        
        self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(self.blurEffectView, at: self.view.subviews.count - 2)
       // self.blurEffectView.alpha = 0.0
        */
        
        self.tableView.isScrollEnabled = false

        //self.blurEffectView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.4) {
            
            
            
            
            self.editorView.alpha = 1
            
            self.tintView.alpha = 0.5
            
            self.editorView.transform = CGAffineTransform.identity
            
            
        }
        
        editorView.layer.borderWidth = 1
        editorView.layer.borderColor = UIColor.black.cgColor
        
    }
    func animateOut(){
        
        editorOpen = false
        
        self.tableView.scrollToRow(at: IndexPath(row: selectedPath[1], section: selectedPath[0]), at: UITableViewScrollPosition.top, animated: false)

        
                self.tintView.isUserInteractionEnabled = false
        
        //self.blurEffectView.isUserInteractionEnabled = false
        
        //self.navigationController?.navigationBar.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            
            self.editorView.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
            
            self.editorView.alpha = 0
            
         //   self.blurEffectView.effect = nil
            
            self.tintView.alpha = 0.0

            
            self.tableView.isScrollEnabled = true
            
        }) { (success:Bool) in
            
            
            self.editorView.removeFromSuperview()
          //  self.blurEffectView.removeFromSuperview()

            self.editorView.transform = CGAffineTransform.init(scaleX: 1, y:1)
        
        }
       // navigationController?.hidesBarsOnSwipe = true
        
        //self.navigationController?.navigationBar.isTranslucent = false
        
        self.tableView.reloadData()

    }
    @IBAction func didChangeSwitch(_ sender: Any) {
        
        var gameDict = games[selectedPath[0]][selectedPath[1]]
        let pastSnapshot = gameDict["Snapshot"] as! FIRDataSnapshot
        
        ref = FIRDatabase.database().reference()
        let gameDirec = ref.child("Sports").child("Football").child(currentGame)
        
        
        gameDirec.child("editing").setValue(isEditingSwitch.isOn)
        
        pastSnapshot.setValue(isEditingSwitch.isOn, forKey: "editing")
        //bookmark
        
        
        if isEditingSwitch.isOn {
            
            
            
        }
    }

    
    func getNewData(){
        
        ref = FIRDatabase.database().reference()
        // self.ref.child("Sports").child("Football").observe(FIRDataEventType.value, with: { (snapshot) in
        
        ref.child("Sports").child("Football").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let count = snapshot.childrenCount
            print("database count: \(count)")
            /*
             ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
             // Get user value
             let value = snapshot.value as? NSDictionary
             let username = value?["username"] as? String ?? ""
             let user = User.init(username: username)
             
             // ...
             }) { (error) in
             print(error.localizedDescription)
             }
             */
            
            self._refHandle = self.ref.child("Sports").child("Football").observe(FIRDataEventType.childAdded, with: { (snapshot) in
                
                //let date:Int = snapshot.childSnapshot(forPath: "date").value as! Int
                
                
                if self.gamesArray.count == 0 {
                    if !self.gamesArray.contains(snapshot){
                        self.gamesArray.append(snapshot)
                    }
                    
                    
                } else {
                    var didInsert = false
                    for i in stride(from: self.gamesArray.count-1, to: 0, by: -1){
                        print("Stride \(i)")
                        print(self.gamesArray[i])
                        print("\n\n\n")
                        let temp = self.gamesArray[i].childSnapshot(forPath: "date").value as! Int
                        
                       // print("Next to new date: \(snapshot.childSnapshot(forPath: "date").value)")
                        let newDate = snapshot.childSnapshot(forPath: "date").value as! Int
                        if temp > newDate {
                            if !self.gamesArray.contains(snapshot){
                                self.gamesArray.insert(snapshot, at: i)
                                didInsert = true
                            }
                        }
                    }
                    if didInsert == false {
                        if !self.gamesArray.contains(snapshot){
                            self.gamesArray.append(snapshot)
                        }
                    }
                    
                }
                print("Games array count \(self.gamesArray.count)")
                
                if Int(count) == Int(self.gamesArray.count) {
                    
                    print("\n\n\ngamesArray\n\n\(self.gamesArray)\n\n\n")
                    
                    
                    for j in 0..<self.gamesArray.count {
                        
                        var isInserted = false
                        
                        let i = self.gamesArray[j]
                        
                        let date = Date(timeIntervalSince1970: TimeInterval(i.childSnapshot(forPath: "date").value as! Int))
                        
                        if j > 0 {
                            
                            let tempDate = Date(timeIntervalSince1970: TimeInterval(self.gamesArray[j-1].childSnapshot(forPath: "date").value as! Int))
                            
                            if date.day == tempDate.day && date.month == tempDate.month && date.year == tempDate.year {
                                
                                
                                for y in 0..<self.games.count {
                                    
                                    var gam = self.games[y]
                                    for u in 0..<gam.count {
                                        
                                        
                                        var w = gam[u]
                                        
                                        let wDate = w["Date"] as! Date
                                        
                                        
                                        if wDate.day == date.day && wDate.month == date.month && wDate.year == date.year {
                                            
                                            if u == gam.count - 1 {
                                                
                                                if wDate > date {
                                                    
                                                    if !isInserted {
                                                        isInserted = true
                                                    
                                                        self.games[y].insert(self.gameForm(gameDate: date, snapshot: i), at: u)
                                                    }
                                                } else {
                                                    if !isInserted {
                                                        isInserted = true
                                                        self.games[y].append(self.gameForm(gameDate: date, snapshot: i))
                                                    }
                                                }
                                            } else {
                                                if wDate > date {
                                                    if !isInserted {
                                                        isInserted = true
                                                        self.games[y].insert(self.gameForm(gameDate: date, snapshot: i), at: u)
                                                    }
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    
                                }
                                
                                
                            }
                        }
                        
                        
                        
                        
                        
                        
                        if j == 0{
                            if self.games.count == 0{
                                if !isInserted {
                                    isInserted = true
                                    
                                    print("Inserted \(i) at point")
                                    self.games.append([self.gameForm(gameDate: date, snapshot: i)])
                                }
                            }
                            
                            
                        } else {
                            
                           // let prevGameDate = self.games[self.games.count-1][0]["Date"] as! Date
                            
                            let today = Date.today()
                            
                            if date.year == today.year && date.month == today.month && date.day == today.day {
                                
                                let last = self.games[self.games.count - 1][0]["Date"] as! Date
                                
                                if last.day == today.day && last.month == today.month && last.year == today.year {
                                    if !isInserted {
                                        isInserted = true
                                        self.games[self.games.count - 1].append(self.gameForm(gameDate: date, snapshot: i))
                                    }
                                } else if (last.year == today.year && (last.month > today.month || (last.month == today.month && last.day > today.day)) || last.year > today.year){
                                    
                                    if self.games.count > 1 {
                                        
                                        let prev = self.games[self.games.count - 2][0]["Date"] as! Date
                                        
                                        if prev.day == today.day && prev.month == today.month && prev.year == today.year {
                                            if !isInserted {
                                                isInserted = true
                                                self.games[self.games.count - 2].append(self.gameForm(gameDate: date, snapshot: i))
                                            }
                                        } else {
                                            if !isInserted {
                                                isInserted = true
                                                self.games.insert([self.gameForm(gameDate: date, snapshot: i)], at: self.games.count-1)
                                            }
                                        }

                                    } else {
                                        if !isInserted {
                                            isInserted = true
                                            self.games.insert([self.gameForm(gameDate: date, snapshot: i)], at: self.games.count-1)
                                        }
                                    }
                                } else {
                                    if !isInserted {
                                        isInserted = true
                                        self.games.append([self.gameForm(gameDate: date, snapshot: i)])
                                    }
                                }
                                
                                
                            } else if (date.year == today.year && (date.month > today.month || (date.month == today.month && date.day > today.day)) || date.year > today.year) {
                                
                                let last =  self.games[self.games.count - 1][0]["Date"] as! Date
                                
                                if (last.year >= today.year && last.month > today.month) || (last.year >= today.year && last.month >= today.month && last.day > today.day) {
                                    
                                    let tempCount = self.games[self.games.count-1].count
                                    for p in 0..<tempCount {
                                        
                                        let tempGame = self.games[self.games.count-1][p]
                                        
                                        if (tempGame["Date"] as! Date) > date {
                                            if !isInserted {
                                                isInserted = true
                                                self.games[self.games.count-1].insert(self.gameForm(gameDate: date, snapshot: i), at: p)
                                            }
                                            break
                                        }
                                        if !isInserted {
                                            isInserted = true
                                            self.games[self.games.count - 1].append(self.gameForm(gameDate: date, snapshot: i))
                                        }
                                    }
                                    
                                } else {
                                    if !isInserted {
                                        isInserted = true
                                        self.games.append([self.gameForm(gameDate: date, snapshot: i)])
                                    }
                                }
                                
                            } else if (date.year < today.year || date.year == today.year && (date.month < today.month || (date.month == today.month && date.day < today.day))) {
                                
                                for k in 0..<self.games.count {
                                    
                                    let tempDate = self.games[k][0]["Date"] as! Date
                                    
                                    if tempDate.year > date.year || tempDate.year == date.year && (tempDate.month > date.month || (tempDate.month == date.month && tempDate.day > date.day)){
                                        if !isInserted {
                                            isInserted = true
                                            self.games.insert([self.gameForm(gameDate: date, snapshot: i)], at: k)
                                        }
                                        break
                                        
                                    } else if k == self.games.count - 1 {
                                        if !isInserted {
                                            isInserted = true
                                            self.games.append([self.gameForm(gameDate: date, snapshot: i)])
                                        }
                                        break
                                    }
                                    
                                }
                                
                                
                            }
                            
                            
                            /*
                            if prevGameDate.year == date.year && prevGameDate.day == date.day && prevGameDate.month == date.month {
                                
                                self.games[self.games.count - 1].append(self.gameForm(gameDate: date, snapshot: i))
                            } else {
                                
                                self.games.append([self.gameForm(gameDate: date, snapshot: i)])
                            }*/
                            
                        }
                        
                        
                    }
                    
                    print("\n\n\nGames\n\n\(self.games)\n\n\n")
                    self.tableView.reloadData()
                    self.spinner.stopAnimating()
                    SwiftSpinner.hide()
                    self.hidden = true
                    
                    //self.tableView.scrollToRow(at: IndexPath(row: 0, section: self.todaySection), at: UITableViewScrollPosition.top, animated: true)
                }
                
                
            })
            
        })
        
        
        
        
        
        
    }

    
    func dateComparison(dat: Date, secDate: Date) -> String {
        
        
        print(dat.compare(Date.today()))
        
        
        return "sup"
        
    }
    
    func gameForm(gameDate: Date, snapshot: FIRDataSnapshot) -> Dictionary<String,Any>{
        
        return ["Date":gameDate, "Snapshot":snapshot]
    }
    
    func getChangedData(){
        
        
        ref = FIRDatabase.database().reference()
        
        _refHandle = self.ref.child("Sports").child("Football").observe(FIRDataEventType.childChanged, with: { (snapshot) in
            
            var section: Int!
            var row: Int!
            
            
            for i in 0..<self.games.count {
                
                for j in 0..<self.games[i].count {
                    
                    if (self.games[i][j]["Snapshot"] as! FIRDataSnapshot).childSnapshot(forPath: "game").value as! Int == snapshot.childSnapshot(forPath: "game").value as! Int {
                        
                        self.games[i][j]["Snapshot"] = snapshot
                        
                        if self.editorOpen == false {
                            
                            self.tableView.reloadData()
                            
                            
                        }
                        /*
                        section = i
                        row = j
                        
                        
                        self.games[section][row]["snapshot"] = snapshot
                        
                        
                        let cell = (self.navigationController?.viewControllers[0] as! UITableViewController).tableView.cellForRow(at: IndexPath(row: Int(row), section: Int(section)))
                        
                        let homeTeam = snapshot.childSnapshot(forPath: "homeTeam").value as! String
                        
                        let awayTeam = snapshot.childSnapshot(forPath: "awayTeam").value as! String
                        
                        let homeScore = String(snapshot.childSnapshot(forPath: "homeScore").value as! Int)
                        
                        let awayScore = String(snapshot.childSnapshot(forPath: "awayScore").value as! Int)
                        
                        let possession = String(snapshot.childSnapshot(forPath: "possession").value as! String)
                        
                        
                        if possession == "Home" {
                            
                            (cell?.contentView.viewWithTag(22) as! UIImageView).image = #imageLiteral(resourceName: "small-Football")
                            (cell?.contentView.viewWithTag(21) as! UIImageView).image = UIImage(named: "")

                        } else if possession == "Away" {
                            
                            (cell?.contentView.viewWithTag(21) as! UIImageView).image = #imageLiteral(resourceName: "small-Football")
                            (cell?.contentView.viewWithTag(22) as! UIImageView).image = UIImage(named: "")

                            
                        } else {
                            
                            (cell?.contentView.viewWithTag(22) as! UIImageView).image = UIImage(named: "")
                            (cell?.contentView.viewWithTag(21) as! UIImageView).image = UIImage(named: "")

                        }
                        
                        (cell?.contentView.viewWithTag(4) as! UILabel).text = homeTeam
                        
                        (cell?.contentView.viewWithTag(3) as! UILabel).text = awayTeam
                        
                        (cell?.contentView.viewWithTag(2) as! UILabel).text = "\(homeScore)"
                        (cell?.contentView.viewWithTag(1) as! UILabel).text = "\(awayScore)"
                        
                        
                        
                        
                        cell?.reloadInputViews()

                        */
                        
                        break
                    }

                    
                }
                
                
            }
            
        
            
        })
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        //var sections = 0
        
        print("The amount of games: \(games.count)")
        //sections = games.count
        
            
        
        
        //return sections
        //return games.count
        
        return games.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("games in section: \(games[section].count)")
        
        var count = games[section].count
        
        if section == games.count - 1{
            
            if AppState.sharedInstance.signedIn {
                
                count += 1
            }
        }
        return count
            
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height:CGFloat = 60
        
        
        if indexPath.section == games.count - 1 && indexPath.row == games[games.count - 1].count {
            
            height = CGFloat(28)
            
        }
        
        
        return height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
      
        if indexPath.row <= games[indexPath.section].count - 1 {
        
            cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        
        
        
        
            let section = indexPath.section
            
            let row = indexPath.row
        
            let snapshot = games[section][row]["Snapshot"] as! FIRDataSnapshot
        
            let date = games[section][row]["Date"] as! Date
            
            
            
        
        
            let homeTeam = snapshot.childSnapshot(forPath: "homeTeam").value as! String
        
            let awayTeam = snapshot.childSnapshot(forPath: "awayTeam").value as! String
        
            let homeScore = (snapshot.childSnapshot(forPath: "homeScore").value as! Int)
        
            let awayScore = (snapshot.childSnapshot(forPath: "awayScore").value as! Int)
        
            let gameTime = (snapshot.childSnapshot(forPath: "time").value as! String)
            
            
            let ballState = (snapshot.childSnapshot(forPath: "possession").value as! String)
            
            let game = String(snapshot.childSnapshot(forPath: "game").value as! Int)
            
            
        
            (cell.contentView.viewWithTag(4) as! UILabel).text = homeTeam
        
            (cell.contentView.viewWithTag(3) as! UILabel).text = awayTeam
        
            (cell.contentView.viewWithTag(2) as! UILabel).text = "\(homeScore)"
            (cell.contentView.viewWithTag(1) as! UILabel).text = "\(awayScore)"
        
            let today = Date.today()
            
            
            let someDate = NSDate()
            let calender = NSCalendar.current
            let todayHour = calender.component(Calendar.Component.hour, from: someDate as Date)
            let todayMinute = calender.component(Calendar.Component.minute, from: someDate as Date)

            
            
            
            var state = "Default"
            //Past
            
            /*
            
            if date.year < today.year {
                //past
                 state = "Past"
                
            } else if date.year == today.year {
                
                if date.month < today.month {
                    //past
                    state = "Past"
                    
                } else if date.month == today.month {
                    if date.day < today.day {
                        //past
                        state = "Past"
                        
                        
                    } else if today.day == date.day {
                        
                        state = "Today"
                        
                        
                    } else if today.day < date.day {
                        //future
                        state = "Future"
                        
                    }
                    
                } else if date.month > today.month {
                    //future
                    state = "Future"
                    
                }
                
            } else if date.year > today.year {
                //future
                state = "Future"
                
            }*/
            
            if Int(date.timeIntervalSinceNow) > 0 {
                
                state = "Future"
                
            } else if Int(date.timeIntervalSinceNow) == 0{
                
                
                state = "Today"
            } else if Int(date.timeIntervalSinceNow) < 0 {
                
                if date.year == today.year && date.month == today.month && date.year == today.year {
                    
                    state = "Today"
                    
                } else {
                    
                    state = "Past"
                }
                
            }
        
            
            if gameTime == "Delayed" || gameTime == "Canceled" {
                
                (cell.contentView.viewWithTag(1) as! UILabel).alpha = 0.0
                (cell.contentView.viewWithTag(2) as! UILabel).alpha = 0.0
                
                (cell.contentView.viewWithTag(22) as! UIImageView).image = UIImage(named: "")
                
                (cell.contentView.viewWithTag(21) as! UIImageView).image = UIImage(named: "")
                
                (cell.contentView.viewWithTag(3) as! UILabel).textColor = UIColor.black
                
                (cell.contentView.viewWithTag(1) as! UILabel).textColor = UIColor.black
                
                (cell.contentView.viewWithTag(4) as! UILabel).textColor = UIColor.black
                
                (cell.contentView.viewWithTag(2) as! UILabel).textColor = UIColor.black
                
                
            } else  if state == "Past"{
                
                (cell.contentView.viewWithTag(1) as! UILabel).alpha = 1.0
                (cell.contentView.viewWithTag(2) as! UILabel).alpha = 1.0
                
                ref = FIRDatabase.database().reference()
                ref.child("Sports").child("Football").child(game).child("possession").setValue("None")
                
                ref.child("Sports").child("Football").child(game).child("time").setValue("Final")
                
                print("\n\n\(homeTeam) vs \(awayTeam)\n\(date)\nPast\n\n")
                
                (cell.contentView.viewWithTag(7) as! UILabel).text = "Final"
                (cell.contentView.viewWithTag(7) as! UILabel).alpha = 1.0
                
                (cell.contentView.viewWithTag(15) as! UILabel).alpha = 0.0
                
                (cell.contentView.viewWithTag(16) as! UILabel).alpha = 0.0
                
                (cell.contentView.viewWithTag(22) as! UIImageView).image = UIImage(named: "")
                
                (cell.contentView.viewWithTag(21) as! UIImageView).image = UIImage(named: "")
                
                

                
                if (homeScore > awayScore){
                    
                    (cell.contentView.viewWithTag(6) as! UIImageView).image = UIImage(named: "triangleLeft")
                    (cell.contentView.viewWithTag(5) as! UIImageView).image = UIImage(named: "")
                    
                    (cell.contentView.viewWithTag(3) as! UILabel).textColor = UIColor.lightGray
                    
                    (cell.contentView.viewWithTag(1) as! UILabel).textColor = UIColor.lightGray
                    
                    (cell.contentView.viewWithTag(4) as! UILabel).textColor = UIColor.black
                    
                    (cell.contentView.viewWithTag(2) as! UILabel).textColor = UIColor.black
                    
                    print("\(homeTeam) is beating \(awayTeam) \(homeScore) to \(awayScore)")
                    
                } else if (awayScore > homeScore){
                    
                    (cell.contentView.viewWithTag(5) as! UIImageView).image = UIImage(named: "triangleLeft")
                    (cell.contentView.viewWithTag(6) as! UIImageView).image = UIImage(named: "")
                    
                    
                    (cell.contentView.viewWithTag(4) as! UILabel).textColor = UIColor.lightGray
                    
                    (cell.contentView.viewWithTag(2) as! UILabel).textColor = UIColor.lightGray
                    
                    (cell.contentView.viewWithTag(3) as! UILabel).textColor = UIColor.black
                    
                    (cell.contentView.viewWithTag(1) as! UILabel).textColor = UIColor.black
                    
                    print("\(awayTeam) is beating \(homeTeam) \(awayScore) to \(homeScore)")
                    
                }
                
                
                
            } else if state == "Today" {
                
                
                
                print("\n\n\(homeTeam) vs \(awayTeam)\n\(date)\nToday\n\n")

                
                
                var hour = date.hour
                var post = "am"
                
                if hour > 12 {
                    
                    hour -= 12
                    post = "pm"
                }
                
                
                print("\n\n\nToday")
                print("\n\n happens at \(date.hour):\(date.minute) and today is \(todayHour):\(todayMinute)\n\n\n")
                
                (cell.contentView.viewWithTag(5) as! UIImageView).image = UIImage(named: "")
                (cell.contentView.viewWithTag(6) as! UIImageView).image = UIImage(named: "")
                
                if date.hour < todayHour || (date.hour == todayHour && date.minute <= todayMinute) {
                    
                    (cell.contentView.viewWithTag(2) as! UILabel).alpha = 1.0
                    (cell.contentView.viewWithTag(1) as! UILabel).alpha = 1.0
                    
                    print("game has started")
                    
                    (cell.contentView.viewWithTag(7) as! UILabel).alpha = 1.0
                    (cell.contentView.viewWithTag(15) as! UILabel).alpha = 0.0
                    (cell.contentView.viewWithTag(16) as! UILabel).alpha = 0.0
                    
                    (cell.contentView.viewWithTag(7) as! UILabel).text = gameTime
                    
                    if (cell.contentView.viewWithTag(7) as! UILabel).text == "Final" || (cell.contentView.viewWithTag(7) as! UILabel).text == "final" {
                        
                        (cell.contentView.viewWithTag(21) as! UIImageView).image = UIImage(named: "")
                        
                        (cell.contentView.viewWithTag(22) as! UIImageView).image  = UIImage(named: "")
                        
                        
                        if (homeScore > awayScore){
                            
                            (cell.contentView.viewWithTag(6) as! UIImageView).image = UIImage(named: "triangleLeft")
                            (cell.contentView.viewWithTag(5) as! UIImageView).image = UIImage(named: "")
                            
                            (cell.contentView.viewWithTag(3) as! UILabel).textColor = UIColor.lightGray
                            
                            (cell.contentView.viewWithTag(1) as! UILabel).textColor = UIColor.lightGray
                            
                            (cell.contentView.viewWithTag(4) as! UILabel).textColor = UIColor.black
                            
                            (cell.contentView.viewWithTag(2) as! UILabel).textColor = UIColor.black
                            
                            print("\(homeTeam) is beating \(awayTeam) \(homeScore) to \(awayScore)")
                            
                        } else if (awayScore > homeScore){
                            
                            (cell.contentView.viewWithTag(5) as! UIImageView).image = UIImage(named: "triangleLeft")
                            (cell.contentView.viewWithTag(6) as! UIImageView).image = UIImage(named: "")
                            
                            
                            (cell.contentView.viewWithTag(4) as! UILabel).textColor = UIColor.lightGray
                            
                            (cell.contentView.viewWithTag(2) as! UILabel).textColor = UIColor.lightGray
                            
                            (cell.contentView.viewWithTag(3) as! UILabel).textColor = UIColor.black
                            
                            (cell.contentView.viewWithTag(1) as! UILabel).textColor = UIColor.black
                            
                            print("\(awayTeam) is beating \(homeTeam) \(awayScore) to \(homeScore)")
                            
                        }
                        
                        
                        
                    } else {
                        
                        if ballState == "Home" {
                            
                            (cell.contentView.viewWithTag(22) as! UIImageView).image = #imageLiteral(resourceName: "small-Football")
                            
                            (cell.contentView.viewWithTag(21) as! UIImageView).image  = UIImage(named: "")
                            
                        } else if ballState == "Away" {
                            
                            (cell.contentView.viewWithTag(21) as! UIImageView).image = #imageLiteral(resourceName: "small-Football")
                            
                            (cell.contentView.viewWithTag(22) as! UIImageView).image  = UIImage(named: "")
                            
                        } else {
                            
                            (cell.contentView.viewWithTag(21) as! UIImageView).image = UIImage(named: "")
                            
                            (cell.contentView.viewWithTag(22) as! UIImageView).image  = UIImage(named: "")
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                } else {
                    
                    (cell.contentView.viewWithTag(2) as! UILabel).alpha = 1.0
                    (cell.contentView.viewWithTag(1) as! UILabel).alpha = 1.0
                    
                    (cell.contentView.viewWithTag(7) as! UILabel).alpha = 0.0
                    (cell.contentView.viewWithTag(15) as! UILabel).alpha = 1.0
                    (cell.contentView.viewWithTag(16) as! UILabel).alpha = 1.0
                    
                    
                    
                    (cell.contentView.viewWithTag(15) as! UILabel).text = "\(hour):"+String(format: "%02d", date.minute)+" \(post)"
                    
                    (cell.contentView.viewWithTag(16) as! UILabel).text = "Tonight"
                }
                
                
            } else if state == "Future" {
                
                ref.child("Sports").child("Football").child(game).child("possession").setValue("None")
                
                ref.child("Sports").child("Football").child(game).child("time").setValue("Upcoming")
                
                print("\n\n\(homeTeam) vs \(awayTeam)\n\(date)\nFuture\n\n")

                
                (cell.contentView.viewWithTag(7) as! UILabel).alpha = 0.0
                
                (cell.contentView.viewWithTag(2) as! UILabel).alpha = 0.0
                (cell.contentView.viewWithTag(1) as! UILabel).alpha = 0.0
                
                
                (cell.contentView.viewWithTag(15) as! UILabel).alpha = 1.0
                
                (cell.contentView.viewWithTag(16) as! UILabel).alpha = 1.0
                
                var hour = date.hour
                var post = "am"
                
                if hour > 12 {
                    
                    hour -= 12
                    post = "pm"
                }
                
                (cell.contentView.viewWithTag(15) as! UILabel).text = "\(hour):"+String(format: "%02d", date.minute)+" \(post)"
                
                (cell.contentView.viewWithTag(16) as! UILabel).text = "\(date.month)/"+String(format: "%02d", date.day)
                
                
                (cell.contentView.viewWithTag(5) as! UIImageView).image = UIImage(named: "")
                (cell.contentView.viewWithTag(6) as! UIImageView).image = UIImage(named: "")
                (cell.contentView.viewWithTag(4) as! UILabel).textColor = UIColor.black
                
                (cell.contentView.viewWithTag(2) as! UILabel).textColor = UIColor.black
                
                (cell.contentView.viewWithTag(3) as! UILabel).textColor = UIColor.black
                
                (cell.contentView.viewWithTag(1) as! UILabel).textColor = UIColor.black
                
            }
        
        
            print(homeTeam + "\n" + awayTeam + "\n")
        
        
        
        } else if indexPath.row >= games[indexPath.section].count {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "AddGame", for: indexPath)
        }

        return cell
    }
    
  //  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //let dateHeader = tableView.dequeueReusableCell(withIdentifier: "header")! as UIView
        
        
       // let headerView = tableView.viewWithTag(1)
      /*
        headerView = dequeueReusableHeaderFooterView(withIdentifier: "Hi")
     */
        /*
        let view = UIView()
        view.backgroundColor = UIColor.lightText
        
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        
        
        label.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
        
        label.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
            
        label.adjustsFontSizeToFitWidth = true
        
        let textSnap = games[section][0]["Date"] as! Date
        
        let text = textSnap.dateString(in: .medium)
        
        print("adding section \(section)")
        
        label.text = text
        
        view.addSubview(label)
        */
        
        
        
        //(dateHeader.viewWithTag(2) as! UILabel).text = "Friday mar \(section)"
        
        //let headerView = self.headerView
        //return headerView
  //  }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //let section = tableView.dequeueReusableHeaderFooterViewWithIdentifier("header")
        
        let header = tableView.dequeueReusableCell(withIdentifier: "header")!
        
        let datee = games[section][0]["Date"] as! Date!
        
        let newFormatter = DateFormatter()
        let oldFormatter = DateFormatter()
        
        newFormatter.dateFormat = "EEEE, MMMM d"
        oldFormatter.dateFormat = "EEEE MMMM d, yyyy"
        
        if (datee?.year)! < Date.today().year {
            
            (header.contentView.viewWithTag(1) as! UILabel).text = oldFormatter.string(from: (datee)!)
        } else if (datee?.year)! == Date.today().year {
            
            if (datee?.month)! < Date.today().month {
                
                (header.contentView.viewWithTag(1) as! UILabel).text = newFormatter.string(from: (datee)!)
                
            } else if (datee?.month)! == Date.today().month {
                
                if (datee?.day)! < Date.today().day {
                    
                    (header.contentView.viewWithTag(1) as! UILabel).text = newFormatter.string(from: (datee)!)
                    
                } else if (datee?.day)! == Date.today().day {
                    
                    (header.contentView.viewWithTag(1) as! UILabel).text = "Today"
                    
                    todaySection = section
                    
                } else {
                    
                    (header.contentView.viewWithTag(1) as! UILabel).text = "Upcoming"
                    
                    if todaySection == -1 {
                        
                        todaySection = section
                    }
                }
            } else if (datee?.month)! > Date.today().month {
                
                (header.contentView.viewWithTag(1) as! UILabel).text = "Upcoming"
                if todaySection == -1 {
                    
                    todaySection = section
                }
            }
            
        } else if (datee?.year)! > Date.today().year {
            
            (header.contentView.viewWithTag(1) as! UILabel).text = "Upcoming"
            if todaySection == -1 {
                
                todaySection = section
            }
         
        }
        
            
            //games[section][0]["Date"] as! String
        
        //section
        
        return header
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
 
    /*
    func dequeueReusableHeaderFooterView(withIdentifier identifier: String) -> UITableViewHeaderFooterView? {
        
        let headerView = tableView.viewWithTag(1) as! UITableViewHeaderFooterView
        
        (headerView.viewWithTag(2) as! UILabel).text = "Thu mar 1"
        
        return headerView
    }*/
    
    
    
    @IBAction func tweetTapped(_ sender: UIBarButtonItem) {
        
        
        
        if (Twitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            
            
            // App must have at least one logged-in user to compose a Tweet
            
            
            let composer = TWTRComposer()
            
            composer.setText("@NBPSAthletics #NBPSportsApp ")
            
            // Called from a UIViewController
            
            composer.show(from: self, completion: { result in
                print(result)
                if (result == TWTRComposerResult.cancelled) {
                    print("Tweet composition cancelled")
                }
                else {
                    print("Sending tweet!")
                }
                
            })
            
        } else {
            // Log in, and then check again
            Twitter.sharedInstance().logIn { session, error in
                if session != nil { // Log in succeeded
                    
                    let composer = TWTRComposerViewController.emptyComposer()
                    self.present(composer, animated: true, completion: nil)
                    
                } else {
                    
                    let alert = UIAlertController(title: "No Twitter Accounts Available", message: "You must log in using the Twitter app to use this functionality.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))

                    self.present(alert, animated: false, completion: nil)
                    
                }
            }
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        
        return 0.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     
            
            
         
        
        
        if indexPath.row < games[indexPath.section].count {
            
            
        
        
        selectedPath = [indexPath.section, indexPath.row]
        
        editorLabel.text = games[indexPath.section][indexPath.row]["Date"] as? String
        
        let snapshot = games[indexPath.section][indexPath.row]["Snapshot"] as? FIRDataSnapshot
        
        let game = String(snapshot?.childSnapshot(forPath: "game").value as! Int)
        
        currentGame = game
        
        homeScoreVal = snapshot?.childSnapshot(forPath: "homeScore").value as! Int
        
        awayScoreVal = snapshot?.childSnapshot(forPath: "awayScore").value as! Int

            
        let homeTeamStr = snapshot?.childSnapshot(forPath: "homeTeam").value as! String
        
        homeLabel.text = "Home"
            
        let awayTeamStr = snapshot?.childSnapshot(forPath: "awayTeam").value as! String
        
        awayLabel.text = "Away"
        
        let homeVal = snapshot?.childSnapshot(forPath: "homeScore").value as! Int
        
        let awayVal = snapshot?.childSnapshot(forPath: "awayScore").value as! Int
        
        homeScoreLabel.text = "\(homeVal)"
        awayScoreLabel.text = "\(awayVal)"
        
        

        homeScoreStepper.value = Double(homeVal)
        
        
        awayScoreStepper.value = Double(awayVal)
        
        editorLabel.text = "\(homeTeamStr) vs \(awayTeamStr)"
        
        if AppState.sharedInstance.signedIn {
            
            animateIn()

        }
            
        } else if AppState.sharedInstance.signedIn {
            
            self.performSegue(withIdentifier: "ShowGameCreator", sender: self)
            
            
            
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    @IBAction func doneTapped(_ sender: Any) {
        
        animateOut()
        
    }
    
    func changePopup(){
        
        let currGame = games[selectedPath[0]][selectedPath[1]]
        gameDatePicker.date = currGame["Date"] as! Date!
        
        let boolState = (currGame["Snapshot"] as! FIRDataSnapshot).childSnapshot(forPath: "editing").value as! Bool

        isEditingSwitch.setOn(boolState, animated: true)
        
        
    }
    
    @IBAction func changeTapped(_ sender: Any) {
        
        ref = FIRDatabase.database().reference()
        
        var gameDict = games[selectedPath[0]][selectedPath[1]]
        let pastSnapshot = gameDict["Snapshot"] as! FIRDataSnapshot
        currentGame = String(pastSnapshot.childSnapshot(forPath: "game").value as! Int)
        
        editorProgress.startAnimating()
        
      //  let gameDirec = ref.child("Sports").child("Football").child(currentGame)
        
        
        /*
        if Int(homeScoreStepper.value) != (origHomeScore){
            
            gameDirec.child("homeScore").setValue(Int(self.homeScoreStepper.value))
            
            
            homeScoreVal = Int(homeScoreStepper.value)
            
        }
        
        let awayStepperVal = Int(awayScoreStepper.value)
        if awayStepperVal != (pastSnapshot.childSnapshot(forPath: "awayScore").value as! Int){
            
            gameDirec.child("awayScore").setValue(Int(awayStepperVal))
            awayScoreVal = Int(awayScoreStepper.value)
            
        }
        
        if Int(gameDatePicker.date.timeIntervalSince1970) != (pastSnapshot.childSnapshot(forPath: "date").value as! Int) {
            
            gameDirec.child("date").setValue(Int(gameDatePicker.date.timeIntervalSince1970))
            games[selectedPath[0]][selectedPath[1]]["Date"] = gameDatePicker.date
            
            
        }
        */
        
        
        
        let date = gameDatePicker.date
        let dateInt = Int(date.timeIntervalSince1970)
        
        let homeScore = Int(homeScoreStepper.value)
        let awayScore = Int(awayScoreStepper.value)
        
        var homeTeam = pastSnapshot.childSnapshot(forPath: "homeTeam").value as! String
        var awayTeam = pastSnapshot.childSnapshot(forPath: "awayTeam").value as! String
        var possession = pastSnapshot.childSnapshot(forPath: "possession").value as! String
        
        let game = pastSnapshot.childSnapshot(forPath: "game").value as! Int
        
        let isEditing = isEditingSwitch.isOn
        
        
        if editField.text != "" {
            
            if picker.selectedRow(inComponent: 0) == 0 {
                
                homeTeam = editField.text!
                
            } else {
                
                awayTeam = editField.text!
                
            }
        }
        
        let time = timePickerComponents[timePicker.selectedRow(inComponent: 0)]["Title"]!
        
        
        
        let updatedData = [
            "game": game,
            "homeTeam": homeTeam as String,
            "homeScore": homeScore as Int,
            "awayTeam": awayTeam as String,
            "awayScore": awayScore as Int,
            "date": dateInt as Int,
            "editing": isEditing as Bool,
            "time": time as String,
            "possession": possession as String
            
            
            ] as [String : Any]
        
        
        
        self.ref.child("Sports").child("Football").child(currentGame).setValue(updatedData) { (error, ref) in
            
            if error == nil{
                
                print("completed change, trying to edit app data...")
                
                self._refHandle = self.ref.child("Sports").child("Football").child(self.currentGame).observe(FIRDataEventType.value, with: { (snapshot) in
                    
                    
                    self.games[self.selectedPath[0]][self.selectedPath[1]
                        ] = self.gameForm(gameDate: date, snapshot: snapshot)
                    
                    self.tableView.reloadData()
                    
                    
                    //self.blurEffectView.removeFromSuperview()
                    
                    //self.view.insertSubview(self.blurEffectView, at: self.view.subviews.count-2)
                    print("completed supposed tableView update")
                    
                    self.editorProgress.stopAnimating()
                })
                
            } else {
                
                print("error")
                
            }
            
        }
        
        
        
        
        
        
        
        
        /*
        if editField.text != ""{
            
            let path = pickerComponents[pickerSelection]["Value"]
            
            
            ref = FIRDatabase.database().reference()
            let gameDirec = ref.child("Sports").child("Football").child(currentGame)
            gameDirec.child(path!).setValue(editField.text)
            
            gameDirec.child(path!).setValue(editField.text, withCompletionBlock: { (error, ref) in
                
                if error != nil {
                    
                    print(error?.localizedDescription ?? "Sorry, your connection didn't work")
                } else {
                    
                    print("success in posting")
                }
                
            })
            
            var homeTeam = ""
            var awayTeam = ""
            
            
            _refHandle = self.ref.child("Sports").child("Football").child(currentGame).observe(FIRDataEventType.value, with: { (snapshot) in
                
                let newVal = snapshot.childSnapshot(forPath: path!).value as! String
                
                print("Edited the value to \(newVal)")
                
                homeTeam = snapshot.childSnapshot(forPath: "homeTeam").value as! String
                awayTeam = snapshot.childSnapshot(forPath: "awayTeam").value as! String
                
                self.editorLabel.text = "\(homeTeam) vs \(awayTeam)"
                
                
                
                let homeScore = Double(snapshot.childSnapshot(forPath: "homeScore").value as! String)
                let awayScore = Double(snapshot.childSnapshot(forPath: "awayScore").value as! String)
                /*
                if self.homeScoreStepper.value != homeScore {
                    
                    let gameDirec = self.ref.child("Sports").child("Football").child(self.currentGame)
                    gameDirec.child("homeScore").setValue(String(self.homeScoreStepper.value))
                    
                    self.homeScoreVal = Int(self.homeScoreStepper.value)
                    

                    
                    
                }
                if self.awayScoreStepper.value != awayScore{
                    
                    let gameDirec = self.ref.child("Sports").child("Football").child(self.currentGame)
                    gameDirec.child("awayScore").setValue(String(self.awayScoreStepper.value))
                    
                    self.awayScoreVal = Int(self.awayScoreStepper.value)
                    
                    
                }
                */
                if Int(self.gameDatePicker.date.timeIntervalSince1970) != (snapshot.childSnapshot(forPath: "date").value as! Int){
                    
                    let gameDirec = self.ref.child("Sports").child("Football").child(self.currentGame)
                    
                    gameDirec.child("date").setValue(Int(self.gameDatePicker.date.timeIntervalSince1970), withCompletionBlock: { (error, ref) in
                        
                        self.homeScoreVal = Int(self.homeScoreStepper.value)
                        self.homeScoreLabel.text = String(Int(self.homeScoreStepper.value))
                        
                        
                    })

                    
                }
                
                
            })
            
            
        
            editField.text = ""
            
            
        }
        if Double(homeScoreVal) != homeScoreStepper.value {
            
            ref = FIRDatabase.database().reference()
            let gameDirec = ref.child("Sports").child("Football").child(currentGame)
            
            gameDirec.child("homeScore").setValue(String(Int(homeScoreStepper.value)), withCompletionBlock: { (error, ref) in
                
                self.homeScoreVal = Int(self.homeScoreStepper.value)
                self.homeScoreLabel.text = String(Int(self.homeScoreStepper.value))
                
                
            })
            
        }
        if Double(awayScoreVal) != awayScoreStepper.value {
            
            ref = FIRDatabase.database().reference()
            let gameDirec = ref.child("Sports").child("Football").child(currentGame)
            
            
            gameDirec.child("awayScore").setValue(String(Int(awayScoreStepper.value)), withCompletionBlock: { (error, ref) in
                
                self.awayScoreVal = Int(self.awayScoreStepper.value)
                self.awayScoreLabel.text = String(Int(self.awayScoreStepper.value))
                
                
            })
            
            
        }
        
      /*  if (Date(year: year, month: month, day: day) != games[selectedPath[0]][selectedPath[1]]["Date"] as! Date) {
            
            print("new date")
            
        }
        */
        
        if Double(awayScoreVal) != awayScoreStepper.value {
            
            ref = FIRDatabase.database().reference()
            let gameDirec = ref.child("Sports").child("Football").child(currentGame)
            
            
            gameDirec.child("awayScore").setValue(String(Int(awayScoreStepper.value)), withCompletionBlock: { (error, ref) in
                
                self.awayScoreVal = Int(self.awayScoreStepper.value)
                self.awayScoreLabel.text = String(Int(self.awayScoreStepper.value))
                
                
            })
            
            
        }
        
        
        ref = FIRDatabase.database().reference()
        let gameDirec = ref.child("Sports").child("Football").child(currentGame)
        
        let newDate = Int(gameDatePicker.date.timeIntervalSince1970)
        gameDirec.child("date").setValue(newDate)
        
 
        tableView.reloadData()
        */
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var cnt = 0
        if pickerView.tag == 1{
            
            cnt = pickerComponents.count
            
        } else if pickerView.tag == 2 {
            
            cnt = timePickerComponents.count
            
        }
        return cnt
    }
    
    // Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var title = ""
        
        if pickerView.tag == 1 {
            
            if pickerComponents.count != 0 {
                
                title = pickerComponents[row]["Title"]!
                
            }
            
        } else if pickerView.tag == 2 {
            
            if timePickerComponents.count != 0 {
                
                title = timePickerComponents[row]["Title"]!
                
            }
            
            
        }
        
        
        return title
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerSelection = row
        
    }
    
    @IBAction func awayStepperChanged(_ sender: UIStepper) {
        awayScoreLabel.text = Int(sender.value).description
        
        
    }
    
    @IBAction func homeStepperChanged(_ sender: UIStepper) {
        homeScoreLabel.text = Int(sender.value).description
        
        
        
    }
    
    func greenText(label: UILabel){
        
        label.textColor = UIColor.green
        
        
    }
    /*open func headerView(forSection section: Int) -> UITableViewHeaderFooterView? {
        
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as! UITableViewHeaderFooterView
        //let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        
        (header.contentView.viewWithTag(1) as! UILabel).text = "Thu Mar 2"
        
        return header
    }*/
    
    
    

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
    
    func error() {
        
        let alert = UIAlertController(title: "Error", message: "There was an error processing your request", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancel = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func didTapAwayFootball(_ sender: Any) {
        
        ref = FIRDatabase.database().reference()
        let currentGameSnap = games[selectedPath[1]][selectedPath[0]]["Snapshot"] as! FIRDataSnapshot
        let currentGame = String(currentGameSnap.childSnapshot(forPath: "game").value as! Int)
        
        if self.awayFootball.imageView?.tintColor != UIColor.green {
        
            ref.child("Sports").child("Football").child(currentGame).child("possession").setValue("Away") { (error, reff) in
                
                if error != nil {
                    
                    self.error()
                    print("Error setting away to possession")
                    
                } else {
                    
                    self.awayFootball.imageView?.tintColor = UIColor.green
                    
                    self.homeFootball.imageView?.tintColor = UIColor.black
                    
                    
                    let cell = self.tableView.cellForRow(at: IndexPath(row: self.selectedPath[1], section: self.selectedPath[0]))
                    (cell?.contentView.viewWithTag(21) as! UIImageView).image = #imageLiteral(resourceName: "small-Football")
                    
                    (cell?.contentView.viewWithTag(22) as! UIImageView).image  = UIImage(named: "")
                    
                    self.ref.child("Sports").child("Football").child(currentGame).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                        
                        self.tableView.beginUpdates()
                        self.games[self.selectedPath[1]][self.selectedPath[0]]["Snapshot"] = snapshot
                        self.tableView.endUpdates()
                        
                    })
                    


                    
                }
                
                
                
            }
            
        
        } else {
            
            ref.child("Sports").child("Football").child(currentGame).child("possession").setValue("None") { (error, ref) in
                
                if error != nil {
                    
                    
                } else {
                    
                    self.awayFootball.imageView?.tintColor = UIColor.black
                    
                    self.homeFootball.imageView?.tintColor = UIColor.black
                    
                    let cell = self.tableView.cellForRow(at: IndexPath(row: self.selectedPath[1], section: self.selectedPath[0]))
                    
                    (cell?.contentView.viewWithTag(22) as! UIImageView).image  = UIImage(named: "")
                    
                    (cell?.contentView.viewWithTag(21) as! UIImageView).image  = UIImage(named: "")
                    
                    
                    self.ref.child("Sports").child("Football").child(currentGame).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                        
                        self.tableView.beginUpdates()
                        self.games[self.selectedPath[1]][self.selectedPath[0]]["Snapshot"] = snapshot
                        self.tableView.endUpdates()
                        
                    })
                    
                    
                }
                
            }
            
        }
    }
    
    @IBAction func didTapHomeFootball(_ sender: Any) {
        
        ref = FIRDatabase.database().reference()
        let currentGameSnap = games[selectedPath[1]][selectedPath[0]]["Snapshot"] as! FIRDataSnapshot
        let currentGame = String(currentGameSnap.childSnapshot(forPath: "game").value as! Int)
        
        if self.homeFootball.imageView?.tintColor != UIColor.green {
            
            ref.child("Sports").child("Football").child(currentGame).child("possession").setValue("Home") { (error, reff) in
                
                if error != nil {
                    
                    self.error()
                    print("Error setting away to possession")
                    
                } else {
                    
                    self.homeFootball.imageView?.tintColor = UIColor.green
                    
                    self.awayFootball.imageView?.tintColor = UIColor.black
                    
                    
                    let cell = self.tableView.cellForRow(at: IndexPath(row: self.selectedPath[1], section: self.selectedPath[0]))
                    (cell?.contentView.viewWithTag(22) as! UIImageView).image = #imageLiteral(resourceName: "small-Football")
                    
                    (cell?.contentView.viewWithTag(21) as! UIImageView).image  = UIImage(named: "")
                    
                    self.ref.child("Sports").child("Football").child(currentGame).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                        
                        self.tableView.beginUpdates()
                        self.games[self.selectedPath[1]][self.selectedPath[0]]["Snapshot"] = snapshot
                        self.tableView.endUpdates()
                        
                    })
                    
                    
                    
                    
                }
                
                
                
            }
            
            
        } else {
            
            ref.child("Sports").child("Football").child(currentGame).child("possession").setValue("None") { (error, ref) in
                
                if error != nil {
                    
                    
                } else {
                    
                    self.awayFootball.imageView?.tintColor = UIColor.black
                    
                    self.homeFootball.imageView?.tintColor = UIColor.black
                    
                    let cell = self.tableView.cellForRow(at: IndexPath(row: self.selectedPath[1], section: self.selectedPath[0]))
                    
                    (cell?.contentView.viewWithTag(22) as! UIImageView).image  = UIImage(named: "")
                    
                    (cell?.contentView.viewWithTag(21) as! UIImageView).image  = UIImage(named: "")
                    
                    
                    self.ref.child("Sports").child("Football").child(currentGame).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                        
                        self.tableView.beginUpdates()
                        self.games[self.selectedPath[1]][self.selectedPath[0]]["Snapshot"] = snapshot
                        self.tableView.endUpdates()
                        
                    })
                    
                    
                }
                
            }
            
        }
    }
    
   

}


