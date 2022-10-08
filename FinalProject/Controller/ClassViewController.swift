//
//  ClassViewController.swift
//  FinalProject
//
//  Created by Chaehun Ben Lim on 11/5/18.
//  Copyright © 2018 Chaehun Ben Lim. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

class ClassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var classes: [ArtClass] = []
    var db: Firestore!
    var selectedClass: String = ""
    @IBOutlet weak var theTableView: UITableView!
    
    
    /*
        Populate the Table view with classes.
     
        1. Pull from firestore (should be done asynchronously w/ loading icon).
            iterate thru documents in courses and add them to classes variable.
            each document should be an ArtClass. We must hard code all applicable classes
            as documents in Firestore. Each document should contain a name, instructor,
            and a collection of students w/ documents that are users. update requires updating both
            users original collection as well as course.doc.students.user
     
            File structure
            users   -|
                     |-user
     
            Courses -|
                     |- class 1
                     |- class 2 --|
                     |- etc       |-students (collection) ----|
                                  |-name                      |-user -|
                                  |-instructor                        |- mimics each user doc in users
        2. cast into struct
        3. load table cells
    */
   
    /*https://stackoverflow.com/questions/30052587/how-can-i-go-back-to-the-initial-view-controller-in-swift
     */
    
    func fetchClasses() {
        db.collection("courses").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents:\(err)")
                return
            } else {
                for document in querySnapshot!.documents {
                    
                    let courseName:String = document.get("name") as! String
                    let courseInstructor:String = document.get("instructor") as! String
                    
                    let course = ArtClass(name: courseName, instructor: courseInstructor)
                    self.classes.append(course)
                    self.theTableView.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = classes[indexPath.row].name
        cell.textLabel?.font = UIFont(name: "baskerville", size: 20)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.5
        cell.detailTextLabel?.text = classes[indexPath.row].instructor
        cell.detailTextLabel?.font = UIFont(name: "avenir next", size: 12)
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.minimumScaleFactor = 0.5
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = tableView.cellForRow(at: indexPath)
        if let title = selectedCell?.textLabel?.text {
            let keyTitle = title
            self.selectedClass = keyTitle
        }

        UserDefaults.standard.set("\(selectedClass)", forKey: "storedClass")
        let currentCourse = UserDefaults.standard.string(forKey: "storedClass")

        let db = Firestore.firestore()
        let docRef = db.collection("courses").document(currentCourse!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var thisData = document.data()
                let storedData = thisData!["userUID"] as? [String]

                if storedData?.count == 0 {
                    self.performSegue(withIdentifier: "ClassToStudents", sender: self)
                }else{
                    UserDefaults.standard.set(storedData!, forKey: "collectionStudents")
                    UserDefaults.standard.set(storedData!, forKey: "storedStudents")
                    self.performSegue(withIdentifier: "ClassToStudents", sender: self)
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
          UserDefaults.standard.set([String](), forKey: "storedStudents")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "whitelogos")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 2.5))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationItem.titleView = imageView
        theTableView.dataSource = self
        theTableView.delegate = self
        
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        
        db.settings = settings
        fetchClasses()
        
//        let currentUID = Auth.auth().currentUser?.uid
//        let cd = Auth.auth().currentUser?.displayName
//
//        print(cd)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClassToStudents" {
            if let destinationVC = segue.destination as? StudentViewController {
                destinationVC.course = self.selectedClass
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
            }
        }
    }
}
