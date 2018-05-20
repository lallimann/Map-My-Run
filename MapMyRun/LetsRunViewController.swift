//
//  LetsRunViewController.swift
//  MapMyRun
//
//  Created by Lalli Mann on 18/03/18.
//  Copyright © 2018 c0727815. All rights reserved.
//

import UIKit
import HealthKit

class LetsRunViewController: UIViewController {


    let healthStore = HKHealthStore()
    var d:Double = 0.0
    
    @IBOutlet weak var letsRunButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        var d:Double = 0
        
        
        if HKHealthStore.isHealthDataAvailable(){
            let readableTypes: Set<HKSampleType> = [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!]
            
            
            healthStore.requestAuthorization(toShare: nil, read: readableTypes, completion: { (success, error) in
                if(!success){
                    print("error")
                    
                    return
                }
                
                self.getTodaysSteps(completion: {d in
                    print("stepssteps\(d)");
                    self.navigationItem.title = "STEPS TODAY-\(d)"
                })
                
            })
        }
       
        // Do any additional setup after loading the view.
        
    }
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
               // log.error("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
                completion(0.0)
                return
            }
            
            DispatchQueue.main.async {
                completion(sum.doubleValue(for: HKUnit.count()))
            }
        }
        
        healthStore.execute(query)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        if (UserDefaults.standard.double(forKey: "weight") == 0)
        {
            letsRunButton.setTitle("Please enter weight in setting", for: UIControlState.normal)
            letsRunButton.titleLabel?.font = UIFont(name:"NewsGothicStd-Bold.otf",size:3)
            letsRunButton.isEnabled = false
        }
        else
        {
            letsRunButton.isEnabled = true
             letsRunButton.titleLabel?.font = UIFont(name:"NewsGothicStd-Bold.otf",size:23)
            letsRunButton.setTitle("LETS RUN", for: UIControlState.normal)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
