
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
//import FirebaseAuth
//import FirebaseDatabase
import Social
import Alamofire
import AlamofireRSSParser


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {

    @IBOutlet weak var tableContainer: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var detailWebView: UIWebView!
    
    @IBOutlet var detailContainer: UIView!
    
    
    var blurEffect: UIBlurEffect!
    var blurEffectView: UIVisualEffectView!
    
    var descriptions = [String]()
    var titles = [String]()
    var urlArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            print("not nil")
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        tableContainer.layer.cornerRadius = 10
        
        mainTableView.layer.cornerRadius = 10
        
        getRSS()
    
        detailContainer.layer.cornerRadius = 10
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRSS(){
        
        
        let url = NSURL(string: "http://www.nbpsathletics.org/organizations/3072/announcements")
        _ = NSURL(string: "http://www.nbpsathletics.org/organizations/3072/announcements?page=2")

        let task = URLSession.shared.dataTask(with: url as! URL) { (data, response, error) in
            
            if error == nil {
                print("\n\n\nGettting data for web\n\n\n")
                
                let urlContent = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                //print("\n\n\n" + String(urlContent!) + "\n\n\n")
                
                let content = String(urlContent!)
                
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
                        
                        print(self.urlArr)
                    }
                }
                
                var arr2 = [String]()
                
                arr2 = content.components(separatedBy: "<p><strong>")
                
                for i in arr2 {
                    
                    if i.contains("</strong></p>"){
                        
                        
                        let str = i.components(separatedBy: "</strong></p>")[0].replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                        self.titles.append(str)

                    }
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
    
    
    func animateIn(){
        
        
        //blurView.
        
        
        detailContainer.frame = CGRect(x: self.view.bounds.width/2 , y: self.view.bounds.height/2+60, width: self.view.bounds.width-30, height: self.view.bounds.height-300)
        
        self.view.addSubview(detailContainer)
        detailContainer.center = self.view.center
        
        
        detailContainer.transform = CGAffineTransform.init(scaleX: 0.6, y:0.6)
        
        // NSLayoutConstraint(item: detailContainer, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 20.0).isActive = true
        
        //NSLayoutConstraint(item: detailContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: 20.0).isActive = true
        
        
        
        detailContainer.alpha = 0
        
        self.blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        
        self.blurEffectView = UIVisualEffectView(effect: self.blurEffect)
        self.blurEffectView.frame = self.view.bounds
        self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(self.blurEffectView, at: self.view.subviews.count - 2)
        self.blurEffectView.isUserInteractionEnabled = true
        self.mainTableView.isScrollEnabled = false
        
        UIView.animate(withDuration: 0.4) {
            
            
            
            
            self.detailContainer.alpha = 1
            self.detailContainer.transform = CGAffineTransform.identity
            
            
        }
        
    }
    func animateOut(){
        
        
        
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.detailContainer.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
            
            self.detailContainer.alpha = 0
            
            self.blurEffectView.effect = nil
            
            self.blurEffectView.isUserInteractionEnabled = true
            
            self.mainTableView.isScrollEnabled = true
            
        }) { (success:Bool) in
            
            self.detailContainer.removeFromSuperview()
            self.blurEffectView.removeFromSuperview()
            
            self.detailContainer.transform = CGAffineTransform.init(scaleX: 1, y:1)
            
        }

    }

    
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
      //  cell.textLabel?.text = descriptions[indexPath.row]
        (cell.contentView.viewWithTag(1) as! UITextView).text = descriptions[indexPath.row]
        (cell.contentView.viewWithTag(2) as! UILabel).text = titles[indexPath.row]
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return CGFloat(120)
    }
    
    open  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descriptions.count
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        
        animateIn()
        
        detailWebView.loadRequest(URLRequest(url: URL(string: urlArr[indexPath.row])!))
        
        print(indexPath)
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }

    @IBAction func tappedDone(_ sender: Any) {
        
        
        animateOut()
        
    }
}

