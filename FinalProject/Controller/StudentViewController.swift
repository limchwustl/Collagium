//
//  StudentViewController.swift
//  FinalProject
//
//  Created by Erin Crosby on 11/10/18.
//  Copyright © 2018 Chaehun Ben Lim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class StudentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var courseName: UILabel!
    
    var course: String = ""
    var selectedName: String = ""
    var collectionStudent = [String]()
    var students: [User] = []
    var selectedStudent: User!
    var database = Database.database()
    var storage = Storage.storage()
    var firstName = String()
    var lastName = String()
    let groupQueue = DispatchGroup()
    var studentImages: [String:UIImage] = [:]
    var studentData: [String:String] = [:]
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionStudent.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "studentCell", for: indexPath) as! StudentCollectionViewCell
        fetchStudentData()
        let uid = collectionStudent[indexPath.row]
        cell.studentImageView.image = studentImages[uid]
   
 
        cell.studentName.text = studentData[uid]
        return cell
        
//        let db = Firestore.firestore()
//        let docRef = db.collection("users").document(collectionStudent[indexPath.row])
//        docRef.getDocument{ (document,error) in
//            if let document = document, document.exists{
//                let result = document.data()
//                self.firstName = (result!["firstName"] as? String)!
//                self.lastName = (result!["lastName"] as? String)!
//
//                cell.studentName.text = "\(self.firstName) \(self.lastName)"
//            }
//        }
//
//        let ref = storage.reference().child("\(collectionStudent[indexPath.row])/profilePicture" )
//
//        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
//            if let error = error {
//                print(error.localizedDescription)
//                 cell.studentImageView.image = UIImage(named: "defaultImage")
//            }else {
//                if let imageData = data {
//                    let image = UIImage(data: imageData)
//                    cell.studentImageView.image = image
//
//                }
//            }
//        }
//
//        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        UserDefaults.standard.set(collectionStudent[indexPath.row], forKey: "storeduid")
        let uid = collectionStudent[indexPath.row]
        selectedName = studentData[uid]!
        performSegue(withIdentifier: "StudentsToPortfolio", sender: self)
    }
    
    func fetchStudents(){
        
        collectionStudent = UserDefaults.standard.array(forKey: "storedStudents") as! [String]
    }
    
    func fetchImages(){
        
        for id in collectionStudent{
            groupQueue.enter()
            let ref = storage.reference().child("\(id)/profilePicture" )
            ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.studentImages[id] = UIImage(named: "defaultImage")
                    self.groupQueue.leave()
                }else {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        self.studentImages[id] = image
                        self.groupQueue.leave()
                    }
                }
                self.fetchStudentData()
            }
        }
        groupQueue.leave()
    }
    
    func fetchStudentData(){
        
        let db = Firestore.firestore()
        for id in collectionStudent{
            
            let docRef = db.collection("users").document(id)
            docRef.getDocument{ (document,error) in
                if let document = document, document.exists{
                    let result = document.data()
                    self.firstName = (result!["firstName"] as? String)!
                    self.lastName = (result!["lastName"] as? String)!
                    
                    if(self.studentData[id] == nil){
                        
                        self.studentData[id] = "\(self.firstName) \(self.lastName)"
                       
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchStudents()
        fetchImages()
        spinner.startAnimating()
        groupQueue.enter()
        groupQueue.notify(queue: .main) {
            self.myCollectionView.reloadData()
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            
        }
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        let image = UIImage(named: "whitelogos")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 2.5))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationItem.titleView = imageView
        courseName.text = UserDefaults.standard.string(forKey: "storedClass")
        let cellSize = UIScreen.main.bounds.width / 3 - 10
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5)
        layout.itemSize = CGSize(width: cellSize, height: cellSize + cellSize / 2)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        myCollectionView.collectionViewLayout = layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        //super.viewDidAppear()
       // myCollectionView.reloadData()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StudentsToPortfolio" {
            if let destinationVC = segue.destination as? PortfolioViewController {
                destinationVC.name = self.selectedName
                destinationVC.course = self.course
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
            }
        }
    }
    

}
