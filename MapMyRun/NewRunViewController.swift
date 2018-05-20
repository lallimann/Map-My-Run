//
//  NewRunViewController.swift
//  MapMyRun
//
//  Created by Lalli Mann on 17/03/18.
//  Copyright © 2018 c0727815. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NewRunViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    private var run: Run?
    
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goalLabel: UILabel!
    
    var goalDone = 0
    
    var startStopCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        if(UserDefaults.standard.integer(forKey: "completedGoalsCount")<=20)
        {
            let totalGoalsCompleted = UserDefaults.standard.integer(forKey: "completedGoalsCount")
            let distGoalsArray = UserDefaults.standard.array(forKey: "distanceGoals") as! [Double]
            let timeGoalsArray = UserDefaults.standard.array(forKey: "timeGoals") as! [Double]
            
            let currentDistGoal = distGoalsArray[totalGoalsCompleted]
            let currentTimeGoal = timeGoalsArray[totalGoalsCompleted]
            
            goalLabel.text = "NEW GOAL - RUN \(currentDistGoal) MILES IN \(currentTimeGoal) MINUTES"
        }
        else
        {
            goalLabel.text = "ALL GOALS COMPLETED"
        }
        
        
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    private func saveRun() {
        let newRun = Run(context: CoreDataStack.context)
        newRun.distance = distance.value
        newRun.duration = Int16(seconds)
        newRun.timeStamp = Date()
        
        for location in locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timeStamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newRun.addToLocations(locationObject)
        }
        
        CoreDataStack.saveContext()
        
        run = newRun
        
        //////////////////////////////////////////////////////////////////////////////////////////////////
        //goals arrays
        let totalGoalsCompleted = UserDefaults.standard.integer(forKey: "completedGoalsCount")
        let distGoalsArray = UserDefaults.standard.array(forKey: "distanceGoals") as! [Double]
        let timeGoalsArray = UserDefaults.standard.array(forKey: "timeGoals") as! [Double]
        
        let currentDistGoal = distGoalsArray[totalGoalsCompleted]
        let currentTimeGoal = timeGoalsArray[totalGoalsCompleted]
        
        var currentGoalsDistArray:[Double] = UserDefaults.standard.array(forKey: "currentGoals") as! [Double]
        var currentGoalsTimeArray:[Double] = UserDefaults.standard.array(forKey: "currentTimes") as! [Double]
        var allDistArray:[Double] = UserDefaults.standard.array(forKey: "allDist") as! [Double]
        var allTimeArray:[Double] = UserDefaults.standard.array(forKey: "allTime") as! [Double]
        var allPaceArray:[String] = UserDefaults.standard.array(forKey: "allPace") as! [String]
        var allGoalsResultsArray:[Bool] = UserDefaults.standard.array(forKey: "compareRuns") as! [Bool]
        
        
        if(UserDefaults.standard.integer(forKey: "completedGoalsCount")<=20)
        {
            currentGoalsDistArray.append(currentDistGoal)
            currentGoalsTimeArray.append(currentTimeGoal)
        }
        
        allDistArray.append(Measurement(value: distance.value , unit: UnitLength.meters).converted(to: UnitLength.miles).value)
        allTimeArray.append(Double(seconds))
        allPaceArray.append(FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerMile))
        
        if(UserDefaults.standard.integer(forKey: "completedGoalsCount")<=20)
        {
            if(goalDone == 1)
            {
                allGoalsResultsArray.append(true)
                UserDefaults.standard.set(UserDefaults.standard.integer(forKey:"completedGoalsCount")+1, forKey: "completedGoalsCount")
                print("currentCa currentCa")
            }
            else
            {
                allGoalsResultsArray.append(false)
            }
        }
        
        
        UserDefaults.standard.set(currentGoalsDistArray, forKey: "currentGoals")
        UserDefaults.standard.set(currentGoalsTimeArray, forKey: "currentTimes")
        UserDefaults.standard.set(allDistArray, forKey: "allDist")
        UserDefaults.standard.set(allTimeArray, forKey: "allTime")
        UserDefaults.standard.set(allPaceArray, forKey: "allPace")
        UserDefaults.standard.set(allGoalsResultsArray, forKey: "compareRuns")
        
        //totalRuns
        let totalRuns:Int = UserDefaults.standard.integer(forKey: "totalRuns")
        let totalCalories:Int = UserDefaults.standard.integer(forKey: "totalCalories")
        
        var currentCalories:Int = 0
        let timeInHours = seconds
        let speedInKMPH = 5
        let weight = UserDefaults.standard.double(forKey: "weight")
        
        let calCalc = Int(Double(speedInKMPH) * 1.45)
        currentCalories = Int((Double(calCalc) * weight * Double(timeInHours)/(60*60)))
        
        
        UserDefaults.standard.set(totalRuns+1, forKey: "totalRuns")
        UserDefaults.standard.set(totalCalories + currentCalories, forKey: "totalCalories")
        
        
    }
    
    private func startLocationUpdates() {
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    private func updateDisplay() {
        
        if(goalDone == 0)
        {
            let totalGoalsCompleted = UserDefaults.standard.integer(forKey: "completedGoalsCount")
            let distGoalsArray = UserDefaults.standard.array(forKey: "distanceGoals") as! [Double]
            let timeGoalsArray = UserDefaults.standard.array(forKey: "timeGoals") as! [Double]
            
            let currentDistGoal = distGoalsArray[totalGoalsCompleted]
            let currentTimeGoal = timeGoalsArray[totalGoalsCompleted]
            
          
            if((currentTimeGoal >= Double(seconds)/60) && (currentDistGoal <= Measurement(value: distance.value , unit: UnitLength.meters).converted(to: UnitLength.miles).value))
            {
                goalDone = 1
               
            }
        }
        
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerMile)
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time:  \(formattedTime)"
        paceLabel.text = "Pace:  \(formattedPace)"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations
        {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                mapView.setRegion(region, animated: true)
            }
            locationList.append(newLocation)
        }
    }
    
    private func startRun() {
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
    }
    
    private func stopRun() {
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func startTapped(_ sender: Any) {
        if(startStopCount == 0)
        {
            startRun()
            startButton.setBackgroundImage(UIImage(named: "stop-2.png"), for: UIControlState.normal)
            startStopCount = 1
            self.tabBarController?.tabBar.isHidden = true
        }
        else if (startStopCount == 1)
        {
            let alertController = UIAlertController(title: "End run?",
                                                    message: "Do you wish to end your run?",
                                                    preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "No", style: .cancel))
            alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
                self.timer?.invalidate()
                self.locationManager.stopUpdatingLocation()
                self.stopRun()
                self.saveRun()
                self.startStopCount = 0
                self.tabBarController?.tabBar.isHidden = false
                self.performSegue(withIdentifier: "RunDetailsViewController", sender: nil)
            })
            
            
            present(alertController, animated: true)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "RunDetailsViewController")
        {
            let destination = segue.destination as! RunDetailViewController
            destination.run = run
            destination.goalDone = goalDone
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

