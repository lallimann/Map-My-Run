//
//  ViewController.swift
//  MapMyRun
//
//  Created by Lalli Mann on 14/03/18.
//  Copyright © 2018 c0727815. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var totalRunsLable: UILabel!
    @IBOutlet weak var totalCaloriesLable: UILabel!
    @IBOutlet weak var goalButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore
        {
            print("Not first launch.")
        } else
        {
            print("First launch, setting UserDefault.")
            
            //profilePicture data
            let data:Data? = nil
            UserDefaults.standard.set(data, forKey: "profilePicture")
            
            
            
            //goals data
            let titles:[String] = ["BEGINNER","ACTIVE","ADVANCE","ELITE"]
            let distGoalsArray:[Double] = [0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.4, 2.6, 2.8, 3.0, 3.2, 3.4, 3.6, 3.8, 4.0, 4.2, 4.4]
            let timeGoalsArray:[Double] = [5.0, 7.0, 9.0, 11.0, 12.0, 14.0, 16.0, 18.0, 19.0, 21.0, 23.0, 25.0, 26.0, 28.0, 30.0, 31.0, 33.0, 35.0, 37.0, 39.0]
            let totalGoalsComplete:Int = 0
            
            UserDefaults.standard.set(titles, forKey: "titles")
            UserDefaults.standard.set(distGoalsArray, forKey: "distanceGoals")
            UserDefaults.standard.set(timeGoalsArray, forKey: "timeGoals")
            UserDefaults.standard.set(totalGoalsComplete, forKey: "completedGoalsCount")
            
            
            
            //currentGoals
            let currentGoalsDistArray:[Double] = []
            let currentGoalsTimeArray:[Double] = []
            let allDistArray:[Double] = []
            let allTimeArray:[Double] = []
            let allPaceArray:[Double] = []
            let allGoalsResultsArray:[Bool] = []
            
            UserDefaults.standard.set(currentGoalsDistArray, forKey: "currentGoals") //to compare only
            UserDefaults.standard.set(currentGoalsTimeArray, forKey: "currentTimes") //to compare only
            UserDefaults.standard.set(allDistArray, forKey: "allDist") // for log and compare
            UserDefaults.standard.set(allTimeArray, forKey: "allTime") // for log and compare
            UserDefaults.standard.set(allPaceArray, forKey: "allPace") // for log only
            UserDefaults.standard.set(allGoalsResultsArray, forKey: "compareRuns") //to compare only
            
            
            
            //totalRuns
            let totalRuns:Int = 0
            let totalCalories:Int = 0
            
            UserDefaults.standard.set(totalRuns, forKey: "totalRuns")
            UserDefaults.standard.set(totalCalories, forKey: "totalCalories")
            
            
            //progressPictures
            let progressPicturesData:[Data] = []
            let dateString:[String] = []
            
            UserDefaults.standard.set(progressPicturesData, forKey: "progressPics")
            UserDefaults.standard.set(dateString, forKey: "picsDates")
            
            
            //user data
            let weight: Double = 0
            let height: Double = 0
            
            UserDefaults.standard.set(weight, forKey: "weight")
            UserDefaults.standard.set(height, forKey: "height")
            
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if(UserDefaults.standard.integer(forKey: "completedGoalsCount")<=5)
        {
            titleLable.text = "BEGINNER"
            
        }
        else if(UserDefaults.standard.integer(forKey: "completedGoalsCount")<=10)
        {
            titleLable.text = "ACTIVE"
        }
        else if(UserDefaults.standard.integer(forKey: "completedGoalsCount")<=15)
        {
            titleLable.text = "ADVANCE"
        }
        else if(UserDefaults.standard.integer(forKey: "completedGoalsCount")<=20)
        {
            titleLable.text = "ELITE"
        }
        
        if(UserDefaults.standard.integer(forKey: "completedGoalsCount")<=20)
        {
            let totalGoalsCompleted = UserDefaults.standard.integer(forKey: "completedGoalsCount")
            let distGoalsArray = UserDefaults.standard.array(forKey: "distanceGoals") as! [Double]
            let timeGoalsArray = UserDefaults.standard.array(forKey: "timeGoals") as! [Double]
            
            let currentDistGoal = distGoalsArray[totalGoalsCompleted]
            let currentTimeGoal = timeGoalsArray[totalGoalsCompleted]
            
            goalButton.setTitle("NEW GOAL - RUN \(currentDistGoal) MILES IN \(currentTimeGoal) MINUTES", for: UIControlState.normal)
        }
        else
        {
            goalButton.setTitle("ALL GOALS COMPLETED", for: UIControlState.normal)
        }
        
        let totalRuns = UserDefaults.standard.integer(forKey: "totalRuns")
        let totalCalories = UserDefaults.standard.integer(forKey: "totalCalories")
        totalRunsLable.text = "\(totalRuns)"
        totalCaloriesLable.text = "\(totalCalories)"
        
        
        let profilePicData = UserDefaults.standard.data(forKey: "profilePicture")
        
        if(profilePicData != nil)
        {
            profilePicture.image = UIImage(data: profilePicData!)
            profilePicture.contentMode = .scaleAspectFit
        }
        
    }
    
    @IBAction func tapGestureProfilePic(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            profilePicture.image = selectedImage
            
            //let fileManager = FileManager.default
            //let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("profile.png")
            let image = selectedImage
            //print(paths)
            let imageData = UIImagePNGRepresentation(image)
           // fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
            
            let profilePicData = imageData
            UserDefaults.standard.set(profilePicData, forKey: "profilePicture")
            
            dismiss(animated: true, completion: nil)
        }
        else
        {
            fatalError("error while selectig image \(info)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

