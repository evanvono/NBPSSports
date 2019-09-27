
//  Verson 0.030
//
//  ViewController.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 2/27/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//
/*
 *
 INSTALL pod 'AlamofireRSSParser' 
 PARSE NBPS SPORTS NEWS FEED TO TABLEVIEW
 CELLS TAPPED OPEN TO ARTICLES ON SEPARATE WEBVIEW
 https://github.com/AdeptusAstartes/AlamofireRSSParser
 *
 */
import UIKit
import Firebase
import SwiftSpinner

extension UIImageView {
    
    
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, activity: UIActivityIndicatorView, finished: () -> Void) {
        contentMode = mode
        
        let group = AppState.sharedInstance.myGroup
        group.enter()
        activity.startAnimating()
        activity.isHidden = false
        
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            
                //AppState.sharedInstance.articleImage = image
                
            
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                activity.stopAnimating()
                activity.isHidden = true
                group.leave()
                

            }
            }.resume()
        
        activity.stopAnimating()
        activity.isHidden = true
        
        finished()
        
        
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, activity1: UIActivityIndicatorView){
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode, activity: activity1){
            
        activity1.stopAnimating()
            return
        }
        
    }
}

struct  Sport {
    
    var sportTitle:String!
    var boysTitle:String!
    var girlsTitle:String!
    var color:UIColor!
    
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource/*, UIWebViewDelegate */{

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet var detailNavBar: UINavigationBar!
    @IBOutlet weak var tableContainer: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var popupImageView: UIImageView!
    @IBOutlet weak var titleText: UILabel!
   
    @IBOutlet weak var bodyText: UITextView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
   
    
    @IBOutlet var detailContainer: UIView!
    @IBOutlet weak var titleView: UIView!
    
    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle?
    
    
    var blurEffect: UIBlurEffect!
    var blurEffectView: UIVisualEffectView!
    
    var descriptions = [String]()
    var titles = [String]()
    var urlArr = [String]()
    var images = [String]()
    var times = [String]()
    
    var selectedRow = 0
    
    var amt:Int = 0
    
    var hasRepeated = 0
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bodyText.setContentOffset(CGPoint.zero, animated: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppState.sharedInstance.openView = self.view
        
        tableContainer.layer.cornerRadius = 5
        tableContainer.layer.masksToBounds = true
        
        checkForNew()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: self.view.tintColor]
        
        /*            //print("not nil")
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            */
            
        
        
        ref = FIRDatabase.database().reference()

        titleView.layer.cornerRadius = 10.0
        titleView.layer.masksToBounds = true
        activity.isHidden = false
        activity.startAnimating()
       
        let name = AppState.sharedInstance.displayName
        
        if AppState.sharedInstance.signedIn == true {
            
            self.title = "\(name)"
            
            
           // userLabel.text = "Welcome back, \(name)"
            logoutButton.tintColor = self.view.tintColor
            logoutButton.isEnabled = true

        } else {
            
            //userLabel.text = ""
            logoutButton.isEnabled = false
            logoutButton.tintColor = UIColor.clear
            
        }
        
        
        mainTableView.layer.cornerRadius = 10
        mainTableView.layer.masksToBounds = true
        
        getRSS(urlStr: "http://www.nbpsathletics.org/organizations/3072/announcements")
        

        
        
        
        
        //detailWebView.loadRequest(URLRequest(url: URL(string: "www.google.com")!))
        
    
        detailContainer.layer.cornerRadius = 10
        detailContainer.layer.masksToBounds = true
        
        setUpBlurView()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func checkForNew(){
        
        ref = FIRDatabase.database().reference()
        
        /*_refHandle = ref.child("Sports").observe(FIRDataEventType.value, with: { (snapshot) in
            
            self.amt = Int(snapshot.childSnapshot(forPath: "liveGames").childrenCount)
            
            if self.amt > 0 {
                self.mainTableView.reloadData()
            }
    
        })*/
    }

    func setUpBlurView(){
        
        self.blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        
        self.blurEffectView = UIVisualEffectView(effect: self.blurEffect)
        self.blurEffectView.frame = self.view.bounds
        self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(self.blurEffectView)
        
        
        self.blurEffectView.isUserInteractionEnabled = true
        
        self.blurEffectView.alpha = 0
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRSS(urlStr: String){
        
        
        let url = NSURL(string: urlStr)

        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
            
            if error == nil {
                //print("\n\n\nGettting data for web\n\n\n")
                
                let urlContent = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                //print("\n\n\n" + String(urlContent!) + "\n\n\n")
                
                let content = String(urlContent!)
                
               // print("\n\n\n\n\(content)\n\n\n\n")
                
                
                //var arr = [String]()
                
                var string = content.components(separatedBy: "<div id='post")
                string.remove(at: 0)
                
                //var i = arr[1]
                
                
                for j in string {
                    
                    
                
                var article = ""
                
                
                var array = j.components(separatedBy: "<p>")
                
                array.remove(at: 0)
                for str in array {
                        
                        
                    //let par = (i.components(separatedBy: "<p class='document'>")[0])
                    
                        
                    if str.contains("<p class='document'>"){
                        
                        let finalPar = str.components(separatedBy: "<p class='document'>")[0]
                        article.append("\(finalPar)")
                        
                        break
                        
                    } else if str.contains("</p>"){
                        
                       // let str1 = str.replacingOccurrences(of: "\n", with: "", options: .regularExpression, range: nil)
                        article.append("\(str)\n")
                        
                    }
                    
                        
                        
                }
                print(article)
                let str = article.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                let str1 = str.replacingOccurrences(of: "&amp;", with: "&", options: .regularExpression, range: nil)
                //let str2 = str1.replacingOccurrences(of: "\n", with: "", options: .regularExpression, range: nil)
               // let str2 = str1.replacingOccurrences(of: "more editing options", with: "", options: .regularExpression, range: nil)

                
                self.descriptions.append(str1)
        
                }
                
                var arr1 = [String]()
                
                arr1 = content.components(separatedBy: "'blog_title'><a href=\"")
                
                for i in arr1 {
                    
                    if i.contains("blog_body"){
                        
                        
                        self.urlArr.append( ("www.nbpsathletics.org" + i.components(separatedBy: "\">")[0]))
                        
                        //print(self.urlArr)
                    }
                }
                
                // "'image' class='post' src='"
                /*
                var arr2 = [String]()
                
                arr2 = content.components(separatedBy: "<p><strong>")
                
                for i in arr2 {
                 
                    if i.contains("</strong></p>"){
                        
                        
                        let str = i.components(separatedBy: "</strong></p>")[0].replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                        self.titles.append(str)
                        
                    }
                }
                */
                
                var arr2 = [String]()
                
                arr2 = content.components(separatedBy: "title=\"")
                
                for i in arr2 {
                    
                    if i.contains("\"></tp"){
                        
                        
                        let str = i.components(separatedBy: "\"></tp")[0].replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                
                        self.titles.append(str)
                        
                        
                        
                    }
                }
                
                /*
 
 
                 let str1 = i.components(separatedBy: "\"></tp")[0].replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                 //let str = str1.replacingOccurrences(of: "&amp", with: "&")
 
 
                */
                while self.titles.count % 5 != 0 {
                    
                    self.titles.append(" ")
                }
                
                var arr3 = [String]()
                
                arr3 = content.components(separatedBy: "'image' class='post' src='")
                
                for i in arr3 {
                    
                    if i.contains("<div id='post"){
                        
                        
                        let str = i.components(separatedBy: "'>")[0]
                        self.images.append(str)
                        //print(str)
                        
                    }
                    
                }
                
                while self.images.count % 5 != 0 {
                    
                    self.images.append(" ")
                }
                
                var arr4 = [String]()
                
                arr4 = content.components(separatedBy: "Athletics</a> at ")
                
                for i in arr4 {
                    
                    if i.contains("<span class='edit_mode_text'"){
                        
                        
                        let str = i.components(separatedBy: " P")[0]
                        self.times.append(str)
                       // print(str)
                        
                    }
                    
                }
                
                while self.times.count % 5 != 0 {
                    
                    self.times.append(" ")
                }
                
                
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                    
                    
                    if self.hasRepeated == 0 {
                        
                        self.getRSS(urlStr: "http://www.nbpsathletics.org/organizations/3072/announcements?page=2")
                        
                        self.hasRepeated = 1
                        
                    } else if self.hasRepeated == 1 {
                        
                        self.getRSS(urlStr: "http://www.nbpsathletics.org/organizations/3072/announcements?page=3")

                        
                        self.hasRepeated = 2
                        
                    }
                    
                }
                
                
            } else {
                
                print("Description of error: " + error.debugDescription)
                
            }
            
        }
        
        task.resume()
        
        
        
        
    }
    /*
     do{
     try FIRAuth.auth()?.signOut()
     self.performSegueWithIdentifier("logoutSegue", sender: self)
     }catch{
     print("Error while signing out!")
     }
 
     try! FIRAuth.auth()!.signOut()
     if let storyboard = self.storyboard {
     let vc = storyboard.instantiateViewControllerWithIdentifier("firstNavigationController") as! UINavigationController
     self.presentViewController(vc, animated: false, completion: nil)
     }
 
 */
    @IBAction func didTapLogout(_ sender: Any) {
        
        
        if AppState.sharedInstance.signedIn == true {
            
                        
            
            AppState.sharedInstance.signedIn = false
            
            do{
                try FIRAuth.auth()!.signOut()
                
            } catch{
                
                print("Error while signing out!")
            }

            
            let vc = storyboard?.instantiateViewController(withIdentifier: "Base")
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    func animateIn(index:Int){
        
        
        titleText.text = titleText.text?.lowercased()
        //blurView.
        self.blurEffectView.isUserInteractionEnabled = true
        
        detailContainer.frame = CGRect(x: self.view.bounds.width/2 , y: self.view.bounds.height/2+60, width: self.view.bounds.width-30, height: 400.0)
        
        self.view.addSubview(detailContainer)
        detailContainer.center = self.view.center
        
        
        detailContainer.transform = CGAffineTransform.init(scaleX: 0.6, y:0.6)
        
        // NSLayoutConstraint(item: detailContainer, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 20.0).isActive = true
        
        //NSLayoutConstraint(item: detailContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: 20.0).isActive = true
        
        
        
        detailContainer.alpha = 0
        self.mainTableView.isScrollEnabled = false
        
        
        UIView.animate(withDuration: 0.4) {
            
            
            
            
            self.detailContainer.alpha = 1
            self.detailContainer.transform = CGAffineTransform.identity
            
            
        }
        
        self.blurEffectView.alpha = 1
        
        
        
        //print("URL: \(url)")
 
        let url1 = URL(string: ("http://www.nbpsathletics.org"+images[index]))!
        
        //print(url1)
       // let url1 = URL(string: "http://www.nbpsathletics.org/p/announcements/1270339/900/600/image.pic")
        
        
        
        popupImageView.downloadedFrom(url: url1, activity: activity){
            
            self.popupImageView.contentMode = UIViewContentMode.scaleAspectFill
            
            
            
//            let color = UIColor.white
            //detailContainer.backgroundColor = color.withAlphaComponent(0.5)
            
            AppState.sharedInstance.myGroup.notify(queue: .main) {
                
                if self.popupImageView.image != nil {
                    self.popupImageView.image = self.imageWithGradient(img: self.popupImageView.image)
                }
            }
            
            
        }
        
        
        
        titleText.text = titles[index]//.lowercased()
        bodyText.text = descriptions[index]
        
        //detailWebView.loadRequest(URLRequest(url: URL(string: "www.google.com")!))
    }
    func animateOut(){
        
        self.mainTableView.isScrollEnabled = true
        
        self.blurEffectView.isUserInteractionEnabled = true
        
        self.blurEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.detailContainer.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
            
            self.detailContainer.alpha = 0
            
            
            
        }) { (success:Bool) in
            
            self.detailContainer.removeFromSuperview()
            
            
            self.detailContainer.transform = CGAffineTransform.init(scaleX: 1, y:1)
            
        }
        
        self.popupImageView.image = nil

    }
    func imageWithGradient(img:UIImage!) -> UIImage {
        
        UIGraphicsBeginImageContext(img.size)
        let context = UIGraphicsGetCurrentContext()
        
        img.draw(at: CGPoint(x: 0, y: 0))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let locations:[CGFloat] = [0.0, 1.0]
        
        //let bottom = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        
        let bottom = UIColor.darkGray.cgColor
        let top = UIColor(red: 10, green: 10, blue: 10, alpha: 0).cgColor
        
        let colors = [top, bottom] as CFArray
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        
        let startPoint = CGPoint(x: img.size.width / 2, y: img.size.height * (2/3))
        let endPoint = CGPoint(x: img.size.width / 2, y: img.size.height + 10)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }

    
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        if amt > 0 {
            
            if indexPath.section == 0 {
                
                
                (cell.contentView.viewWithTag(1) as! UITextView).text = "North Broward faces Gibbons in this away game"
                (cell.contentView.viewWithTag(2) as! UILabel).text = "Boys Soccer: North Broward vs Gibbons"
                
                (cell.contentView.viewWithTag(3) as! UILabel).text = "Home"
                
                    
            } else if indexPath.section == 1 {
                
                (cell.contentView.viewWithTag(1) as! UITextView).text = descriptions[indexPath.row]
                (cell.contentView.viewWithTag(2) as! UILabel).text = titles[indexPath.row]
                //.lowercased()
                
                (cell.contentView.viewWithTag(3) as! UILabel).text = times[indexPath.row]
                
                //print("Titles: \(titles.count)\nDescriptions: \(descriptions.count)")
                
                if  descriptions.count > 9 {
                    
                    activity.stopAnimating()
                    
                }
            }
            
        } else {
            
            (cell.contentView.viewWithTag(1) as! UITextView).text = descriptions[indexPath.row]
            (cell.contentView.viewWithTag(2) as! UILabel).text = titles[indexPath.row]//.lowercased()
            
            
            (cell.contentView.viewWithTag(3) as! UILabel).text = times[indexPath.row]
            
       //     print("Titles: \(titles.count)\nDescriptions: \(descriptions.count)")
            
            if  descriptions.count > 9 {
                
                activity.stopAnimating()
                
            }
            
        }
        
      //  cell.textLabel?.text = description[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return CGFloat(120)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = descriptions.count
        
        if amt > 0 {
            
            if section == 0 {
                
                rows = amt
                
            } else if section == 1 {
                
                rows = descriptions.count
            }
            
        }
        return rows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var sections = 1
        
        if amt > 0 {
            sections = 2
        }
        
        return sections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if amt > 0 {
            
            if section == 0 {
                return "Live Now"
            } else {
                
                return "NBPS Athletics News"
            }
        } else {
            
            return "NBPS Athletics News"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = indexPath.row
        
        if amt > 0 {
            
            if indexPath.section == 1 {
                print("selected \(indexPath.section),\(indexPath.row)")
                animateIn(index:indexPath.row)
            }
            
        } else {
            
            print("selected \(indexPath.section),\(indexPath.row)")
            animateIn(index:indexPath.row)

        }
        
        
        
        //detailWebView.loadRequest(URLRequest(url: URL(string: urlArr[indexPath.row])!))
        
        
        tableView.deselectRow(at: indexPath, animated: true)
 //       detailWebView.loadRequest(URLRequest(url: URL(string: urlArr[indexPath.row])!))
        //detailWebView.loadRequest(URLRequest(url: URL(string: "www.nbpsathletics.org")!))
     
        //print(indexPath)
        
        //mainTableView.deselectRow(at: indexPath, animated: false)

    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    /*open func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
        print("loading")
    }
    
    open func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    */
    
    
    
        
    @IBAction func tappedSafari(_ sender: Any) {
    
        
        print("Tapped Safari")
        
        //animateOut(url: URL(string: urlArr[selectedRow])!)
        AppState.sharedInstance.ArticleURL = URL(string: "http://"+urlArr[selectedRow])!
        self.performSegue(withIdentifier: "ToWebView", sender: nil)
        
        
        /*if let url = NSURL(string: "http://"+urlArr[selectedRow]){
            print(url)
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }*/
    }


    @IBAction func tappedDone(_ sender: Any) {
        
        
        animateOut()
        
    }
}

