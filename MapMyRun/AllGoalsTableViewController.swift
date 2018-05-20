//
//  AllGoalsTableViewController.swift
//  MapMyRun
//
//  Created by Lalli Mann on 15/03/18.
//  Copyright © 2018 c0727815. All rights reserved.
//

import UIKit

class AllGoalsTableViewController: UITableViewController {

    var distGoals:[Any] = []
    var timeGoals:[Any] = []
    var goalsCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        distGoals = UserDefaults.standard.array(forKey: "distanceGoals")!
        
        timeGoals = UserDefaults.standard.array(forKey: "timeGoals")!
        
        goalsCount = UserDefaults.standard.integer(forKey: "completedGoalsCount")
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        
        distGoals = UserDefaults.standard.array(forKey: "distanceGoals")!
        
        timeGoals = UserDefaults.standard.array(forKey: "timeGoals")!
        
        goalsCount = UserDefaults.standard.integer(forKey: "completedGoalsCount")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return distGoals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "allCell", for: indexPath) as! AllGoalsTableViewCell
        
        cell.label.text = "To run \(distGoals[indexPath.row]) in \(timeGoals[indexPath.row]) in minutes"
        
        if(indexPath.row>=goalsCount)
        {
            cell.imageStatus.image = UIImage(named: "sands-of-time.png")
        }
        else
        {
            cell.imageStatus.image = UIImage(named: "check.png")
        }
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
