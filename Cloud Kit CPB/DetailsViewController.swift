//
//  DetailsViewController.swift
//  CollegeProfileBuilder
//
//  Created by Wade Sellers on 7/22/16.
//  Copyright © 2016 MobileMakers. All rights reserved.
//

import UIKit
import SafariServices
import CloudKit

class DetailsViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collegeImageView: UIImageView!
    @IBOutlet weak var collegeLocationField: UITextField!
    @IBOutlet weak var numberOfStudentsField: UITextField!
    @IBOutlet weak var webPageField: UITextField!
    
    var selectedCollege: College!
    
    var imagePicker = UIImagePickerController()
    
    var dataBase = CKContainer.default().publicCloudDatabase
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = selectedCollege.name
        collegeLocationField.text = selectedCollege.location
        numberOfStudentsField.text = selectedCollege.numberOfStudents
        collegeImageView.image = selectedCollege.image
        webPageField.text = selectedCollege.webPage
        
        imagePicker.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        selectedCollege.location = collegeLocationField.text!
        selectedCollege.numberOfStudents = numberOfStudentsField.text!
        selectedCollege.webPage = webPageField.text!
        return true
    }
    
    @IBAction func onViewWebpageButtonPressed(_ sender: UIButton) {
        let svc = SFSafariViewController(url: URL(string: "http://\(webPageField.text!)")!)
        present(svc, animated: true, completion: nil)
    }
    
    @IBAction func onSelectImageButtonPressed(_ sender: UIButton) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage = UIImage()
        imagePicker.dismiss(animated: true) {
            selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.collegeImageView.image = selectedImage
            self.selectedCollege.image = selectedImage
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nvc = segue.destination as! MapViewController
        nvc.college = selectedCollege
    }
    
    func updateCloud()
    {
        let place = CKRecord(recordType: "College")
        
        place.setObject(selectedCollege.name as CKRecordValue, forKey: "name")
        
        place.setObject(selectedCollege.location as CKRecordValue, forKey: "location")
        
        place.setObject(selectedCollege.numberOfStudents as CKRecordValue, forKey: "numberOfStudents")
        
        place.setObject(selectedCollege.webPage as CKRecordValue, forKey: "webPage")
        
        dataBase.save(place) { (record, error) in
            
        }
        
    }
    
    
}



