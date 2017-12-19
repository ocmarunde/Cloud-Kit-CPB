//
//  ViewController.swift
//  CollegeProfileBuilder
//
//  Created by Wade Sellers on 7/22/16.
//  Copyright © 2016 MobileMakers. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var collegeArray = [College]()
    
    var database = CKContainer.default().publicCloudDatabase
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        let college1 = College(Name: "University of Illinois", Location: "Champaign, IL", NumberOfStudents: "43,000", Image: UIImage(named: "Illinois")!, Webpage: "www.uiuc.edu", Crest: UIImage(named: "IllinoisCrest")!)
        //        collegeArray.append(college1)
        //        let college2 = College(Name: "Iowa", Location: "Iowa City, IA", NumberOfStudents: "31,000", Image: UIImage(named: "iowa")!, Webpage: "www.uiowa.edu", Crest: UIImage(named: "IowaCrest")!)
        //        collegeArray.append(college2)
        //        let college3 = College(Name: "Harvard", Location: "Cambridge, MA", NumberOfStudents: "21,000", Image: UIImage(named: "Harvard")!, Webpage: "www.harvard.edu", Crest: UIImage(named: "HarvardCrest")!)
        //        collegeArray.append(college3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getColleges()
        
        myTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collegeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        cell.textLabel?.text = collegeArray[(indexPath as NSIndexPath).row].name
        cell.detailTextLabel?.text = collegeArray[(indexPath as NSIndexPath).row].location
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nvc = segue.destination as! DetailsViewController
        let indexPath = myTableView.indexPathForSelectedRow!
        nvc.selectedCollege = collegeArray[(indexPath as NSIndexPath).row]
        nvc.dataBase = database
    }
    
    @IBAction func onAddButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New College", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add College Name Here"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add College Location Here"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add Number of Students Here"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add Webpage URL Here"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (action) in
            let nameTextField = alert.textFields?[0]
            let locationTextField = alert.textFields?[1]
            let numberOfStudentsTextField = alert.textFields?[2]
            let webPageTextField = alert.textFields?[3]
            
            let newCollege = College(Name: nameTextField!.text!, Location: locationTextField!.text!, NumberOfStudents: numberOfStudentsTextField!.text!, Image: UIImage(), Webpage: webPageTextField!.text!, Crest: UIImage())
            self.collegeArray.append(newCollege)
            self.updateCould(college: newCollege)
            
        }
        
        alert.addAction(addAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func onEditButtonPressed(_ sender: UIBarButtonItem) {
        if sender.tag == 0 {
            myTableView.isEditing = true
            sender.tag = 1
        }
        else {
            myTableView.isEditing = false
            sender.tag = 0
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            collegeArray.remove(at: (indexPath as NSIndexPath).row)
            myTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let college = collegeArray[(sourceIndexPath as NSIndexPath).row]
        collegeArray.remove(at: (sourceIndexPath as NSIndexPath).row)
        collegeArray.insert(college, at: (destinationIndexPath as NSIndexPath).row)
        
    }
    
    func getColleges()
    {
        collegeArray = []
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "College", predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            
            for college in records!
            {
                let cloudName = college.object(forKey: "name") as! String
                
                let clouddLocation = college.object(forKey: "location") as! String
                
                let cloudNumberofStudents = college.object(forKey: "numberOfStudents") as! String
                
                let cloudWebPage = college.object(forKey: "webPage") as! String
                
                let cloudCollege = College(Name: cloudName, Location: clouddLocation, NumberOfStudents: cloudNumberofStudents, Image: UIImage(), Webpage: cloudWebPage, Crest: UIImage())
                
                self.collegeArray.append(cloudCollege)
            }
            
            
            DispatchQueue.main.async
                {
                    self.myTableView.reloadData()
            }
            
        }
        
        
    }
    
    func updateCould(college: College)
    {
        
        let place = CKRecord(recordType: "College")
        
        place.setObject(college.name as CKRecordValue, forKey: "name")
        
        place.setObject(college.location as CKRecordValue, forKey: "location")
        
        place.setObject(college.numberOfStudents as CKRecordValue, forKey: "numberOfStudents")
        
        place.setObject(college.webPage as CKRecordValue, forKey: "webPage")
        
        self.database.save(place) { (record, error) in
            
            DispatchQueue.main.async {
                self.myTableView.reloadData()
                
            }
            
            
        }
    }
    
}



