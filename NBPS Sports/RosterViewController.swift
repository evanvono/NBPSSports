//
//  RosterViewController.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 9/23/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//

import UIKit


class RosterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var firstNames = [String]()
    var lastNames = [String]()
    
    @IBOutlet weak var rosterHolder: UIView!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        rosterHolder.layer.cornerRadius = 10
        rosterHolder.layer.masksToBounds = true
        //www.nbpsathletics.org/teams/787681-Varsity-Football-football-team-website/rosters/876550

        // Do any additional setup after loading the view.
        
        getRSS(urlStr: "http://www.nbpsathletics.org/teams/787681-Varsity-Football-football-team-website/rosters/876550")
           
        
        
        
    }
    @IBAction func tappedClose(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPopover" {
            
            
            let popoverViewController = segue.destination
            
            popoverViewController.popoverPresentationController?.delegate = self
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.none
    }
    */
    
    
    func getRSS(urlStr: String){
        
        
        let url = NSURL(string: urlStr)
        
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
            
            if error == nil {
                //print("\n\n\nGettting data for web\n\n\n")
                
                let urlContent = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                //print("\n\n\n" + String(urlContent!) + "\n\n\n")
                
                let content = String(urlContent!)
                
                // print("\n\n\n\n\(content)\n\n\n\n")
                
                
                var arr = [String]()
                
                arr = content.components(separatedBy: "first_name'>")
                
                for i in arr {
                    
                    if (i.contains("row_number")){
                        
                        let par = (i.components(separatedBy: "</span>")[0])
                        
                        
                        let str = par.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                        
                        print(str)
                        self.firstNames.append(str)
                        
                    }
                    
                }
                
                var arr1 = [String]()
                
                arr1 = content.components(separatedBy: "last_name'>")
                for i in arr1 {
                    
                    if (i.contains("row_number'>")){
                        
                        let par = (i.components(separatedBy: "</span>")[0])
                        
                        
                        let str = par.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                        self.lastNames.append(str)
                        
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

    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Player")!
        
        if firstNames.count > 0{
            
            let nameLabel = (cell.contentView.viewWithTag(1) as! UILabel)
            nameLabel.text = "\(firstNames[indexPath.row]) \(lastNames[indexPath.row])"
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Roster"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return firstNames.count
        //return roster.count
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
