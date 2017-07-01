
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
import Social
import ChameleonFramework



/*
 *
 * HOOK DATE UP TO HTML FOR HEADLINES IN TABLEVIEW
 *
 */
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


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource/*, UIWebViewDelegate */{

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var userLabel: UILabel!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableContainer.layer.cornerRadius = 5
        
        if self.revealViewController() != nil {
            //print("not nil")
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
            ref = FIRDatabase.database().reference()

        }
        
        titleView.layer.cornerRadius = 10.0
        activity.isHidden = false
        activity.startAnimating()
       
        let name = AppState.sharedInstance.displayName
        
        if AppState.sharedInstance.signedIn == true {
            
            userLabel.text = "Welcome back, \(name)"
            logoutButton.tintColor = self.view.tintColor
            
        } else {
            
            userLabel.text = ""
            logoutButton.tintColor = UIColor.clear
            
            
        }
        
        
        mainTableView.layer.cornerRadius = 10
        
        
        getRSS(urlStr: "http://www.nbpsathletics.org/organizations/3072/announcements")
        
        getRSS(urlStr: "http://www.nbpsathletics.org/organizations/3072/announcements?page=2")
        
        //detailWebView.loadRequest(URLRequest(url: URL(string: "www.google.com")!))
        
    
        detailContainer.layer.cornerRadius = 10
        
        setUpBlurView()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func setUpBlurView(){
        
        self.blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        
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
                
                print("\n\n\n\n\(content)\n\n\n\n")
                
                
                var arr = [String]()
                
                arr = content.components(separatedBy: "<p>")
                
                for i in arr {
                    
                    if (i.contains("</p></div>")){
                        
                        let par = (i.components(separatedBy: "</p></div>")[0])
                        
                        
                        let str = par.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                        self.descriptions.append(str)
                        
                    }
        
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
                
                var arr2 = [String]()
                
                arr2 = content.components(separatedBy: "<p><strong>")
                
                for i in arr2 {
                    
                    if i.contains("</strong></p>"){
                        
                        
                        let str = i.components(separatedBy: "</strong></p>")[0].replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                        self.titles.append(str)
                        
                    }
                }
                
                while self.titles.count % 5 != 0 {
                    
                    self.titles.append(" ")
                }
                
                var arr3 = [String]()
                
                arr3 = content.components(separatedBy: "'image' class='post' src='")
                
                for i in arr3 {
                    
                    if i.contains("<div id='post"){
                        
                        
                        let str = i.components(separatedBy: "'>")[0]
                        self.images.append(str)
                        print(str)
                        
                    }
                    
                }
                
                while self.images.count % 5 != 0 {
                    
                    self.images.append(" ")
                }
                
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
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
                try! FIRAuth.auth()!.signOut()
                
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
        
        detailContainer.frame = CGRect(x: self.view.bounds.width/2 , y: self.view.bounds.height/2+60, width: self.view.bounds.width-30, height: self.view.bounds.height-300)
        
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
        
        print(url1)
       // let url1 = URL(string: "http://www.nbpsathletics.org/p/announcements/1270339/900/600/image.pic")
        
        
        
        popupImageView.downloadedFrom(url: url1, activity: activity){
            
            self.popupImageView.contentMode = UIViewContentMode.scaleAspectFill
            
            let color = AverageColorFromImage(image: AppState.sharedInstance.articleImage)
            //detailContainer.backgroundColor = color.withAlphaComponent(0.5)
            
            AppState.sharedInstance.myGroup.notify(queue: .main) {
                
                if self.popupImageView.image != nil {
                    self.popupImageView.image = self.imageWithGradient(img: self.popupImageView.image)
                }
            }
            
            
        }
        
        
        
        titleText.text = titles[index].lowercased()
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
        
        let bottom = UIColor.flatGrayColorDark().cgColor
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
        
        
        
      //  cell.textLabel?.text = descriptions[indexPath.row]
        (cell.contentView.viewWithTag(1) as! UITextView).text = descriptions[indexPath.row]
        (cell.contentView.viewWithTag(2) as! UILabel).text = titles[indexPath.row].lowercased()
        
        print("Titles: \(titles.count)\nDescriptions: \(descriptions.count)")
        
        if  descriptions.count > 9 {
            
            activity.stopAnimating()
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return CGFloat(120)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descriptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selected \(indexPath.section),\(indexPath.row)")
        animateIn(index:indexPath.row)
        
        
        
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
    

    @IBAction func tappedDone(_ sender: Any) {
        
        
        animateOut()
        
    }
}

