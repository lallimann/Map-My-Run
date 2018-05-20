//
//  ComparisonTableViewController.swift
//  MapMyRun
//
//  Created by Lalli Mann on 18/03/18.
//  Copyright © 2018 c0727815. All rights reserved.
//

import UIKit

class ComparisonTableViewController: UITableViewController {

    var currentGoalsDistArray:[Double] = []
    var currentGoalsTimeArray:[Double] = []
    var allDistArray:[Double] = []
    var allTimeArray:[Double] = []
    var allGoalsResultsArray:[Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        currentGoalsDistArray = UserDefaults.standard.array(forKey: "currentGoals") as! [Double]
        currentGoalsTimeArray = UserDefaults.standard.array(forKey: "currentTimes") as! [Double]
        allDistArray = UserDefaults.standard.array(forKey: "allDist") as! [Double]
        allTimeArray = UserDefaults.standard.array(forKey: "allTime") as! [Double]
        allGoalsResultsArray = UserDefaults.standard.array(forKey: "compareRuns") as! [Bool]
        tableView.reloadData()
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
        return allGoalsResultsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "compCell", for: indexPath) as! ComparisonTableViewCell
        
        cell.goalLabel.text = "GOAL: \(currentGoalsDistArray[indexPath.row])mi in \(currentGoalsTimeArray[indexPath.row])min"
        cell.achieveGoal.text = "YOU RAN: \(String(format: "%.2f", allDistArray[indexPath.row]))mi in \(String(format: "%.2f", allTimeArray[indexPath.row]/60))min"
        
        if(allGoalsResultsArray[indexPath.row] == true)
        {
            cell.imageGoal.image = UIImage(named: "mountain.png")
        }
        else
        {
            cell.imageGoal.image = UIImage(named: "cancel.png")
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
