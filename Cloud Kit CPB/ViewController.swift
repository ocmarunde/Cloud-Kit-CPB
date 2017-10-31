//
//  ViewController.swift
//  Cloud Kit CPB
//
//  Created by Olivia Marunde on 10/24/17.
//  Copyright © 2017 Olivia Marunde. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var collegeArray = [College]()
    var database = CKContainer.default().publicCloudDatabase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabelView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collegeArray.count
        //return arrayOf.scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = collegeArray[(indexPath as NSIndexPath).row].name
        //cell.textLabel?.text = "\(arrayOf.scores[indexPath.row])"
        cell.detailTextLabel?.text = collegeArray[(indexPath as NSIndexPath).row].location
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nvc = segue.destination as! DetailsViewController
        
        nvc.dataBase = database
        nvc.selectedCollege = collegeArray
        
        let indexPath = tabelView.indexPathForSelectedRow!
        nvc.selectedCollege = [collegeArray[(indexPath as NSIndexPath).row]]
    }
    
    func getData()
    {
        collegeArray.name = []
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "College", predicate: predicate)
        database.perform(query, inZoneWith: nil) { (records, error) in
            for name in records! {
                //let time = score.object(forKey: "name") as! String
                self.collegeArray.name.append(collegeArray)
                self.collegeArray.location.append(collegeArray)
                self.collegeArray.numberOfStudents.append(collegeArray)
                self.collegeArray.webPage.append(collegeArray)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
            self.tabelView.reloadData()
        }
        
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onEditButtonPressed(_ sender: UIBarButtonItem) {
        if sender.tag == 0 {
            tabelView.isEditing = true
            sender.tag = 1
        }
        else {
            tabelView.isEditing = false
            sender.tag = 0
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            collegeArray.remove(at: (indexPath as NSIndexPath).row)
            tabelView.reloadData()
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

}

