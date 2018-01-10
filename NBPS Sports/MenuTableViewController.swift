// Version 0.021
//  MenuTableViewController.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 3/5/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    var menuItems: [String]!
    
    @IBOutlet weak var swimmingHeight: NSLayoutConstraint!
    @IBOutlet weak var golfHeight: NSLayoutConstraint!
    
    @IBOutlet weak var basketballHeight: NSLayoutConstraint!
    @IBOutlet weak var soccerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var swimmingView: UIView!
    @IBOutlet weak var volleyballView: UIView!
    @IBOutlet weak var golfView: UIView!
    
    @IBOutlet weak var basketballView: UIView!
    @IBOutlet weak var soccerView: UIView!
    
    var blurContainer = UIVisualEffectView()
    
    //@IBOutlet weak var genderButton: UIView!
    
    @IBOutlet var detailView: UIView!
    
    
    var selectedIndex = 100
    
    var didModifyRow = false
    
    var fallGenderPopped = false
    var winterGenderPopped = false
    var springGenderPopped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let blurEffect = UIBlurEffect(style: .regular)
        blurContainer = UIVisualEffectView(effect: blurEffect)
        
        blurContainer.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(self.blurContainer)
        blurContainer.layer.opacity = 0.0

        
        detailView.layer.cornerRadius = 5.0
        detailView.layer.masksToBounds = true
        print("loaded")
        
        //genderButton.layer.cornerRadius = 5
     //   closeMenu(index: 1)
       // closeMenu(index: 2)
        
       // menuItems = ["Menu","Football","Basketball","Soccer","Editors","Volleyball","Twitch"]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
/*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var cellNum = 0
        if section == 0 {
            
            cellNum = 1
            
        } else if section == 1 {
            
            cellNum = menuItems.count
        }
        return cellNum
    }*/

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath)
        if indexPath.section == 1 {
            
            if indexPath.row == 1 {
                
            } else if indexPath.row == 2 {
                
                if selectedIndex == indexPath.row {
                    
                    self.tableView.beginUpdates()
                    selectedIndex = 100
                    self.tableView.endUpdates()
                    didModifyRow = false
                    
                } else {
                    
                    self.tableView.beginUpdates()
                    fallGenderPopped = false
                    selectedIndex = indexPath.row
                    self.tableView.endUpdates()
                    didModifyRow = false
                }
            } else {
                
                self.tableView.beginUpdates()
                selectedIndex = 100
                self.tableView.endUpdates()
                
            }
            
            
            
            
            
            
            
            
            /*
            let sport = (self.tableView.cellForRow(at: indexPath)?.contentView.viewWithTag(2) as! UILabel).text
            if sport == "Baseball" || sport == "baseball" {
                
                self.performSegue(withIdentifier: "ComingSoon", sender: self.tableView.cellForRow(at: IndexPath(row: 7, section: 1)))
                
                AppState.sharedInstance.comingSoonImage = #imageLiteral(resourceName: "Baseball-Blurred")

                AppState.sharedInstance.sportDescription = "Returning This Spring"

                
            } else if sport == "Soccer" || sport == "soccer" {
                
                print("tappedSoccer")
                
                if selectedIndex == indexPath.row {
                    
                    self.tableView.beginUpdates()
                    selectedIndex = 100
                    self.tableView.endUpdates()
                    
                } else {
                    
                    self.tableView.beginUpdates()
                    selectedIndex = indexPath.row
                    self.tableView.endUpdates()
                }
                
                
            } else if sport == "Basketball" || sport == "basketball" {
                
                print("tappedBasketball")
                
                if selectedIndex == indexPath.row {
                    
                    self.tableView.beginUpdates()
                    selectedIndex = 100
                    self.tableView.endUpdates()
                    
                } else {
                    
                    self.tableView.beginUpdates()
                    selectedIndex = indexPath.row
                    self.tableView.endUpdates()
                }
                
                
            } else {
                
                self.tableView.beginUpdates()
                selectedIndex = 100
                self.tableView.endUpdates()
            }
            */
        }
        
 
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItem")
        
        return cell!
    }*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "top")
        
        if indexPath.section == 0{
     
            cell = tableView.dequeueReusableCell(withIdentifier: "top", for: indexPath)
            (cell?.contentView.viewWithTag(1) as! UIImageView).image = UIImage(named: "NBP-Icon-Border")
            
            
            
        } else if indexPath.section == 1{
            cell = tableView.dequeueReusableCell(withIdentifier: "mainButton", for: indexPath)
            let text:String = menuItems[indexPath.row]
            
            (cell?.contentView.viewWithTag(2) as! UILabel).text = text
        }
        

        return cell!
    }*/
    
    func collapseGenders() {
       
        self.tableView.beginUpdates()
        
        golfHeight.constant = 44
        swimmingHeight.constant = 44
        basketballHeight.constant = 44
        soccerHeight.constant = 44
        
        self.tableView.endUpdates()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*
        var height:Int = 44
        
        if indexPath.section == 0{
            
            height = 110
        } else {
            
            if selectedIndex == indexPath.row {
                
                height = 80
                
            } else {
                
                height = 44
            }
            
        }
        return CGFloat(height)*/
        
        
         var height:Int = 44
         
         if indexPath.section == 0{
         
            height = 110
            
         } else {
         
            if selectedIndex == indexPath.row {
         
            
            
                if selectedIndex == 1 {
                
                
                    //print("Resizing Fall Sports")
                
                    
                
                   /* let views = cell?.subviews
                
                    for view:UIView in views! {
                    
                        view.frame = CGRect(x: Int(view.frame.minX), y: Int(view.frame.minY), width: Int(self.tableView.frame.width), height: 44)
                    }*/
                    //306 vs
                    if fallGenderPopped {
                        
                        height = 306
                        
                    } else {
                        height = 270
                        
                        
                    }
                   // height = 270
                
                
                } else if selectedIndex == 2 {
                
                    
                    if winterGenderPopped {
                        
                        height = 170
                        
                    } else {
                        
                        height = 134
                    }
                    
                    
                
                
                    //let cell = tableView.cellForRow(at: indexPath)
                /*
                    let views = cell?.subviews
                
                    for view:UIView in views! {
                    
                        view.frame = CGRect(x: Int(view.frame.minX), y: Int(view.frame.minY), width: Int(self.tableView.frame.width), height: 44)
                    
                    
                    }*/
                
             
                } else if selectedIndex == 3{
                    
                    if springGenderPopped {
                        
                        height = 306
                    } else {
                        
                        
                        height = 270
                    }
                    
                } else {
                    
                    height = 80
                    
                    
                }
            
            } else {
             
                height = 44
            }

            
        }
    
    
            
    
         return CGFloat(height)
        
        
    }
    @IBAction func didTapFallSports(_ sender: Any) {
        
        print("Selected Fall Sports")
        if selectedIndex == 1 {
            
            closeMenu(index: 1)
        } else {
            
            
             //swimmingHeight = NSLayoutConstraint(item: swimmingHeight.firstItem, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 44)
            
            let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 1))
            
            
            
            self.tableView.beginUpdates()
           
            collapseGenders()
            
            selectedIndex = 1
            self.tableView.endUpdates()
            didModifyRow = false
        }

        
    }
    
    @IBAction func didTapWinterSports(_ sender: Any) {
        
        
        print("Selected Fall Sports")
        if selectedIndex == 2 {
            
            closeMenu(index: 2)
            
        
            
        } else {
            
            
            //swimmingHeight = NSLayoutConstraint(item: swimmingHeight.firstItem, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 44)
            /*
            let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 1))
            
            for i in 1..<(cell?.contentView.subviews.count)! {
                
                
                let view1 = cell!.contentView.subviews[i] as UIView
                if i == 0 {
                    
                    view1.frame = CGRect(x: 0, y: Int(view1.frame.minY), width: Int(view1.frame.width), height: 44)
                    
                } else {
                    
                    let prevView = cell!.contentView.subviews[i-1] as UIView
                    
                    
                    view1.frame = CGRect(x: 0, y: Int(prevView.frame.maxY)+2, width: Int(view1.frame.width), height: 44)
                }
                
                
            }
            
            */
 
 

            
            
            
            self.tableView.beginUpdates()
            
            collapseGenders()
            
            selectedIndex = 2
            self.tableView.endUpdates()
            didModifyRow = false
        }
    }
    
    @IBAction func didTapSpringSports(_ sender: UIButton){
        
        
        if selectedIndex == 3{
            
            closeMenu(index: 3)
            
        } else {
            
            openMenu(index: 3)
            
            
        }
        
        
    }
    /*
 
     (cell.contentView.viewWithTag(2) as! UILabel).textColor = UIColor.lightGray
     (cell.contentView.viewWithTag(4) as! UILabel).textColor = UIColor.lightGray
     
     (cell.contentView.viewWithTag(1) as! UILabel).textColor = UIColor.black
     (cell.contentView.viewWithTag(3) as! UILabel).textColor = UIColor.black
 
 */
   /*
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let revealViewController:SWRevealViewController = self.revealViewController()
        
        
        
        if indexPath.section > 0 {
            
           
                
            self.performSegue(withIdentifier: menuItems[indexPath.row], sender: self)
          
            
        }
        
        
        let cell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        
        
        if cell.contentView.viewWithTag(2) != nil {
            
            let label = cell.contentView.viewWithTag(2) as! UILabel
            
            if label.text == "Football" {
                print("selected Football")
                //let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                /*let desController = mainStoryboard.instantiateViewController(withIdentifier: "Football-main") as! UITableViewController
                let newFrontViewController = UINavigationController.init(rootViewController:desController)
                //revealViewController.pushFrontViewController(newFrontViewController, animated: true)*/
                
                let cell = tableView.cellForRow(at: indexPath)
                self.performSegue(withIdentifier: "tappedFootball", sender: cell)
            }
        }
    }
    */
    /*
    override var prefersStatusBarHidden: Bool {
        return true
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
    
   
    @IBAction func didTapBoysVarsitySoccer(_ sender: Any) {
        
        

        
        /*
        self.tableView.beginUpdates()
        selectedIndex = 100
        self.tableView.endUpdates()
        self.performSegue(withIdentifier: "Football", sender: self.tableView.cellForRow(at: IndexPath(row: 8, section: 1)))
        */
        
        
        self.performSegue(withIdentifier: "ComingSoon", sender: self.tableView.cellForRow(at: IndexPath(row: 7, section: 1)))
        
        AppState.sharedInstance.comingSoonImage = #imageLiteral(resourceName: "Soccer-Blurred")
        AppState.sharedInstance.sportDescription = "Returning This Winter"

        closeMenu(index: 1)

        
    }
    @IBAction func didTapBoysVarsityBasketball(_ sender: Any) {
        /*
        self.tableView.beginUpdates()
        selectedIndex = 100
        self.tableView.endUpdates()
        self.performSegue(withIdentifier: "BBasketball", sender: self.tableView.cellForRow(at: IndexPath(row: 7, section: 1)))
 */
        
        self.tableView.beginUpdates()
        selectedIndex = 100
        self.tableView.endUpdates()
        self.performSegue(withIdentifier: "ComingSoon", sender: self.tableView.cellForRow(at: IndexPath(row: 7, section: 1)))
        AppState.sharedInstance.comingSoonImage = #imageLiteral(resourceName: "Gym-Blurred.jpg")
        AppState.sharedInstance.sportDescription = "Returning This Winter"

        
    }
    @IBAction func didTapGirlsVarsitySoccer(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "ComingSoon", sender: self.tableView.cellForRow(at: IndexPath(row: 7, section: 1)))
        AppState.sharedInstance.sportDescription = "Returning This Winter"
        AppState.sharedInstance.comingSoonImage = #imageLiteral(resourceName: "Girls-Soccer-Blurred.jpg")

        closeMenu(index: 1)
        
    }
    @IBAction func didTapGirlsVarsityBasketball(_ sender: Any) {
        
        self.tableView.beginUpdates()
        selectedIndex = 100
        self.tableView.endUpdates()
        self.performSegue(withIdentifier: "ComingSoon", sender: self.tableView.cellForRow(at: IndexPath(row: 7, section: 1)))
        AppState.sharedInstance.comingSoonImage = #imageLiteral(resourceName: "Gym-Blurred.jpg")
        AppState.sharedInstance.sportDescription = "Returning This Winter"


    }
    @IBAction func didTapSwimming(_ sender: UIButton) {
        
        print("tappedSwimming")
        
        openGenderOption(sender: sender)
        
       
        
        
        
        
        
    }
    func dismissDetailView(){
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.detailView.transform = CGAffineTransform.init(scaleX: 0.6, y:0.6)
            
            self.blurContainer.layer.opacity = 0.0
            
        }) { (completion) in
            
            
            self.detailView.removeFromSuperview()
            self.detailView.transform = CGAffineTransform.identity
            
            
        }
        blurContainer.isUserInteractionEnabled = false
        
    }
    @IBAction func didTapCancel(_ sender: UIButton) {
        
        dismissDetailView()
        
    }
    
    func openGenderOption(sender: UIButton){
        
        
        if let sportTitle:String = sender.currentTitle {
            
            
            
           // let menuWidth = AppState.sharedInstance.openView.frame.origin.x
            
            let menuWidth = CGFloat(260)
            
            print("\n\n\n\nmenuWidth: \(menuWidth)")
                
            let xCoord = Double((menuWidth/2) - (detailView.frame.width/2))
            
            detailView.frame = CGRect(x: xCoord, y: Double(self.view.frame.midY-detailView.frame.height), width: 240.0, height: 110.0)
            
            blurContainer.isUserInteractionEnabled = true

            
            (detailView.viewWithTag(1) as! UILabel).text = "Varsity \(sportTitle)"

            
            detailView.transform = CGAffineTransform.init(scaleX: 0.6, y: 0.6)
            UIView.animate(withDuration: 0.25, animations: {
                
                self.blurContainer.layer.opacity = 1.0
                
                
                self.view.addSubview(self.detailView)
                
                
                self.detailView.transform = CGAffineTransform.identity
                
                
                /*
 editorView.transform = CGAffineTransform.init(scaleX: 0.6, y:0.6)
 self.editorView.transform = CGAffineTransform.identity
 */
            })
            
                
            
            
            
            
            
            
            
                        //self.view.addSubview(detailView)
            
        } else {
            
            print("Couldn't get the button's title")
        }
        
       // let detailView = UIView(frame: CGRect(x: (sender.frame.minX)+15, y: sender.frame.minX, width: 100, height: sender.frame.height))
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    @IBAction func didTapGolf(_ sender: UIButton) {
        
        
        
        
        openGenderOption(sender: sender)
        
        print("tappedGolf")
        
        /*
        if Int(golfView.frame.height) == 44 {
            
            //collapseGenders()
            
            if fallGenderPopped {
                
                UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut,animations: {
                    
                    
                    
                    /// self.myView.backgroundColor = .orange
                    // self.swimmingView.transform = CGAffineTransform(scaleX: 1, y: (80/44))
                    
                    self.golfView.frame = CGRect(x: 0, y: Int(self.golfView.frame.minY), width: Int(self.golfView.frame.width), height: 80)
                    
                    self.swimmingView.frame = CGRect(x: 0, y: Int(self.swimmingView.frame.minY)+36, width: Int(self.swimmingView.frame.width), height: 44)
                    
                    //self.volleyballView.frame = CGRect(x: 0, y: Int(self.volleyballView.frame.minY)-36, width: Int(self.swimmingView.frame.width), height: 44)
                    //self.swimmingHeight.constant = 80
                    
                },completion: nil)
                
                
            } else {
                
                
                self.tableView.beginUpdates()
                
                fallGenderPopped = true
                // self.view.reloadInputViews()
                self.tableView.endUpdates()
                
                
                UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut,animations: {
                    
                    
                    
                    /// self.myView.backgroundColor = .orange
                    // self.swimmingView.transform = CGAffineTransform(scaleX: 1, y: (80/44))
                    
                    self.golfView.frame = CGRect(x: 0, y: Int(self.golfView.frame.minY), width: Int(self.golfView.frame.width), height: 80)
                    
                    self.swimmingView.frame = CGRect(x: 0, y: Int(self.swimmingView.frame.minY)+36, width: Int(self.swimmingView.frame.width), height: 44)
                    
                    
                    
                    self.volleyballView.frame = CGRect(x: 0, y: Int(self.volleyballView.frame.minY)+36, width: Int(self.volleyballView.frame.width), height: 44)
                    //self.swimmingHeight.constant = 80
                    
                },completion: nil)
                
            }
            
            
            
        } else {
            self.tableView.beginUpdates()
            fallGenderPopped = false
            UIView.animate(withDuration: 0.255, delay: 0,options: UIViewAnimationOptions.curveEaseInOut,animations: {
                
                /// self.myView.backgroundColor = .orange
                //self.swimmingView.transform = CGAffineTransform(scaleX: 1, y: (44/80))
                self.golfView.frame = CGRect(x: 0, y: Int(self.golfView.frame.minY), width: Int(self.golfView.frame.width), height: 44)
                
                self.swimmingView.frame = CGRect(x: 0, y: Int(self.swimmingView.frame.minY)-36, width: Int(self.swimmingView.frame.width), height: 44)
                
                self.volleyballView.frame = CGRect(x: 0, y: Int(self.volleyballView.frame.minY)-36, width: Int(self.swimmingView.frame.width), height: 44)
                // self.swimmingHeight.constant = 44
                
            },completion: nil)
            self.view.reloadInputViews()
            self.tableView.endUpdates()
            
        }
 */
        
    
        
    }
    
    func comingSoon(){
        
        self.performSegue(withIdentifier: "MenuToComingSoon", sender: nil)
        
        
    }
    @IBAction func didTapVolleyball(_ sender: Any) {
        
        AppState.sharedInstance.ArticleURL = URL(string: "http://www.nbpsathletics.org/teams/787683-Varsity-Volleyball-volleyball-team-website/events?view_mode=list")!
        
        closeAndWeb()
        
        
        
    }
    @IBAction func didTapCrossCountry(_ sender: Any) {
        
        
        AppState.sharedInstance.ArticleURL = URL(string: "http://www.nbpsathletics.org/clubs/4564/events?view_mode=list")!
        
        closeAndWeb()
        
        
    }
    
    @IBAction func didTapFootball(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "Football", sender: self)
        
        self.tableView.beginUpdates()
        selectedIndex = 100
        
        fallGenderPopped = false
        self.tableView.endUpdates()

        
        
    }
    
    @IBAction func didTapSoccer(_ sender: UIButton) {
        
        openGenderOption(sender: sender)

        
    }
    
    @IBAction func didTapBasketball(_ sender: UIButton) {
        
        openGenderOption(sender: sender)
        
    }
    
    @IBAction func didTapBaseball(_ sender: UIButton) {
        comingSoon()
        
    }
    @IBAction func didTapLacrosse(_ sender: UIButton) {
        
        comingSoon()
    }
    @IBAction func didTapSoftball(_ sender: UIButton) {
        
        comingSoon()
    }
    @IBAction func didTapTennis(_ sender: UIButton) {
        comingSoon()
        
    }
    @IBAction func didTapTrackAndField(_ sender: UIButton) {
        comingSoon()
        
    }
    
    
    func openMenu(index: Int){
        
        self.tableView.beginUpdates()
        
        
        selectedIndex = index
        
        self.tableView.endUpdates()

        
    }
    
    func closeMenu(index: Int){
        
        
        self.tableView.beginUpdates()
        
        
            selectedIndex = 100
        
        self.tableView.endUpdates()
    }
    
    @IBAction func didTapBoys(_ sender: UIButton) {
        
        let sport = (sender.superview?.viewWithTag(1) as! UILabel).text?.components(separatedBy: "arsity ")[1] as! String
        
        print("tapped boys \(sport)")
        
        
        if sport == "Soccer" {
            
            AppState.sharedInstance.databaseRef = "BSoccer"
            AppState.sharedInstance.fullTitle = "Boys Soccer"
            
            closeAndSoccer()
        } else if sport == "Basketball" {
            
            AppState.sharedInstance.databaseRef = "BBasketball"
            AppState.sharedInstance.fullTitle = "Boys Basketball"
            
            closeAndSoccer()
            
        } else if sport == "Golf" {
            

            AppState.sharedInstance.ArticleURL = URL(string: "http://www.nbpsathletics.org/teams/787689-Golf-Varsity-Boys-golf-team-website/events?view_mode=list")!
            
            closeAndWeb()
            
        } else if sport == "Swimming" {
            
            AppState.sharedInstance.ArticleURL = URL(string: "http://www.nbpsathletics.org/teams/787785-Swimming-Boys-Varsity-swimming-team-website/events?view_mode=list")!
            
            closeAndWeb()
            
        }
        
    }
    
    func closeAndSoccer(){
        
        dismissDetailView()
        self.tableView.beginUpdates()
        selectedIndex = 100
        
        self.tableView.endUpdates()
        
        self.performSegue(withIdentifier: "Soccer", sender: nil)
        
    }
    
    func closeAndWeb(){
        
        dismissDetailView()
        self.tableView.beginUpdates()
        selectedIndex = 100
        
        self.tableView.endUpdates()
        
        self.performSegue(withIdentifier: "MenuToWebView", sender: nil)
        
    }
    
    @IBAction func didTapGirls(_ sender: UIButton) {
       
        let sport = (sender.superview?.viewWithTag(1) as! UILabel).text?.components(separatedBy: "arsity ")[1] as! String
        
        
        print("tapped girls \(sport)")

        
        
        if sport == "Soccer" {
            
            AppState.sharedInstance.databaseRef = "GSoccer"
            AppState.sharedInstance.fullTitle = "Girls Soccer"
            
            closeAndSoccer()
        } else if sport == "Basketball" {
            
            AppState.sharedInstance.databaseRef = "GBasketball"
            AppState.sharedInstance.fullTitle = "Girls Basketball"
            
            closeAndSoccer()
            
        } else if sport == "Golf" {
            
            AppState.sharedInstance.ArticleURL = URL(string: "http://www.nbpsathletics.org/teams/787690-Golf-Varsity-Girls-golf-team-website/events?view_mode=list")!

            closeAndWeb()

            
        } else if sport == "Swimming" {
            
            AppState.sharedInstance.ArticleURL = URL(string: "http://www.nbpsathletics.org/teams/787784-Swimming-Girls-Varsity-swimming-team-website/events?view_mode=list")!
            
            closeAndWeb()
            
        }
        
        
        
    }
    
    
}
