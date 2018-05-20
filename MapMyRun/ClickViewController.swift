//
//  ClickViewController.swift
//  MapMyRun
//
//  Created by Lalli Mann on 18/03/18.
//  Copyright © 2018 c0727815. All rights reserved.
//

import UIKit
import Photos

class ClickViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var a:[Data] = []
    var dateArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
   
    
    @IBAction func cameraAction(_ sender: Any) {
        
        dateArray = UserDefaults.standard.array(forKey: "picsDates") as! [String]
        a = UserDefaults.standard.array(forKey: "progressPics") as! [Data]
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .camera
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    @IBAction func imageAction(_ sender: Any) {
        dateArray = UserDefaults.standard.array(forKey: "picsDates") as! [String]
        a = UserDefaults.standard.array(forKey: "progressPics") as! [Data]
        
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
            ///
            
            let date1 = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let date = formatter.string(from: date1)
            
            print("datedatedate--"+date)
            
            dateArray.append(date)
           
            ////
            let image = selectedImage
            
            let imageData = UIImageJPEGRepresentation(image, 0.3)
            
            
            
            a.append(imageData!)
            
            if (dateArray.count == a.count)
            {
                UserDefaults.standard.set(dateArray, forKey: "picsDates")
                UserDefaults.standard.set(a,forKey: "progressPics")
            }
            else
            {
                let alert = UIAlertController(title: "Something went wrong", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            
            print("datedatedate--\(a.count)")
            
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
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

