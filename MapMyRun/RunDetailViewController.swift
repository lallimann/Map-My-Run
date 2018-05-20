//
//  RunDetailViewController.swift
//  MapMyRun
//
//  Created by Lalli Mann on 17/03/18.
//  Copyright © 2018 c0727815. All rights reserved.
//

import UIKit
import MapKit
import TwitterKit

class RunDetailViewController: UIViewController, MKMapViewDelegate  {
    
    var run: Run!
    var goalDone:Int?
    var twitterLogin = 0
    
    @IBOutlet weak var goal: UILabel!
    @IBOutlet weak var paceLabel1: UILabel!
    @IBOutlet weak var timeLabel1: UILabel!
    @IBOutlet weak var dateLabel1: UILabel!
    @IBOutlet weak var distanceLabel1: UILabel!
    @IBOutlet weak var mapView1: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView1.delegate = self
        
        configureView()
        
        if(goalDone == 1)
        {
            goal.text = "GOAL ACHIEVED"
        }
        else
        {
            goal.text = "GOAL FAILED"
        }
        
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func exit(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func twitterLogin(_ sender: Any) {
       
        
        Twitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                self.twitterLogin = 1
                
                print("signed in as \(String(describing: session?.userName))");
                
                if(self.twitterLogin == 1)
                {
                    let composer = TWTRComposer()
                    
                    composer.setText("Ran:\(FormatDisplay.distance(Measurement(value: self.run.distance, unit: UnitLength.meters))) in \(FormatDisplay.time(Int(self.run.duration))) with pace of \(FormatDisplay.pace(distance: Measurement(value: self.run.distance, unit: UnitLength.meters),seconds: Int(self.run.duration),outputUnit: UnitSpeed.minutesPerMile)) #MapMyRun")
                    
                    // Called from a UIViewController
                    composer.show(from: self.navigationController!) { result in
                        if (result == .done) {
                            print("Successfully composed Tweet")
                        } else {
                            print("Cancelled composing")
                        }
                    }
                }
                
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })
        
       
     
        
    }
    private func configureView(){
        let distance = Measurement(value: run.distance, unit: UnitLength.meters)
        let seconds = Int(run.duration)
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedDate = FormatDisplay.date(run.timeStamp)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerMile)
        
        distanceLabel1.text = "Distance:  \(formattedDistance)"
        dateLabel1.text = formattedDate
        timeLabel1.text = "Time:  \(formattedTime)"
        paceLabel1.text = "Pace:  \(formattedPace)"
        loadMap()
    }
    
    private func mapRegion() -> MKCoordinateRegion? {
        guard
            let locations = run.locations,
            locations.count > 0
            else {
                return nil
        }
        
        let latitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.latitude
        }
        
        let longitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.longitude
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    //    func mapView1(_ mapView1: MKmapView1, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    //        guard let polyline = overlay as? MKPolyline else {
    //            return MKOverlayRenderer(overlay: overlay)
    //        }
    //        let renderer = MKPolylineRenderer(polyline: polyline)
    //        renderer.strokeColor = .black
    //        renderer.lineWidth = 3
    //        return renderer
    //    }
    
    private func polyLine() -> MKPolyline {
        guard let locations = run.locations else {
            return MKPolyline()
        }
        
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    
    private func loadMap() {
        guard
            let locations = run.locations,
            locations.count > 0,
            let region = mapRegion()
            else {
                let alert = UIAlertController(title: "Error",
                                              message: "Sorry, this run has no locations saved",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
                return
        }
        
        mapView1.setRegion(region, animated: true)
        mapView1.add(polyLine())
    }
    
    func mapView(_ mapView1: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .black
        renderer.lineWidth = 3
        return renderer
    }
}

