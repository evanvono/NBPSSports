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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        menuItems = ["Menu","Football","Basketball","Soccer","Editors","Volleyball","Twitch"]

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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height:Int = 44
        
        if indexPath.section == 0{
            
            height = 110
        } else {
            height = 44
        }
        return CGFloat(height)
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

}
