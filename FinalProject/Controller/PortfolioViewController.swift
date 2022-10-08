//
//  PortfolioViewController.swift
//  FinalProject
//
//  Created by Chaehun Ben Lim on 11/7/18.
//  Copyright © 2018 Chaehun Ben Lim. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import Firebase
import FirebaseAuth

class PortfolioViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var pfCollectionView: UICollectionView!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var alertSign: UILabel!
    @IBOutlet weak var courseName: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var portfolio: [String:Artwork] = [:]
    var imageCache: [String:UIImage] = [:]
    var name: String = ""
    var course: String = ""
    var artworkNum: Int = 0
    let storage = Storage.storage()
    var currentCourse = String()
    var currentUid = String()
    var firstName = String()
    var lastName = String()
    var collectionAlbum = [String]()
    var date = String()
    var dimension = String()
    var descriptions = String()
    var material = String()
    var artTitle = String()
    let db = Firestore.firestore()
    let groupQueue = DispatchGroup()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return collectionAlbum.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pfCell", for: indexPath) as! PortfolioCollectionViewCell
        let key = collectionAlbum[indexPath.row]
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.4
        cell.pfImageView.image = imageCache[key]
        return cell
        
//        let ref = storage.reference().child("\(currentUid)/" + collectionAlbum[indexPath.row])
//        print("\(ref)")
//
//        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
//            if let error = error {
//                print(error.localizedDescription)
//            }else {
//                if let imageData = data {
//                    let image = UIImage(data: imageData)
//                    cell.pfImageView.image = image
//
//                }
//            }
//        }
//        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.artworkNum = indexPath.row
        self.performSegue(withIdentifier: "PortfolioToMain", sender: self)
        
//        let currentCourse = UserDefaults.standard.string(forKey: "storedClass")
//        let currentUser = UserDefaults.standard.string(forKey: "storeduid")
//        let currentName = UserDefaults.standard.string(forKey: "currentUserName")
//
//        let docRef = db.collection("artworks").document(currentUser!)
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//
//                let result = document.data()
//
//                if let importantData = result![currentCourse!] as? [String: Any] {
//                    if (self.portfolio.count != self.collectionAlbum.count) {
//                        for index in self.collectionAlbum {
//                            if let importantDataID = importantData[index] as? [String: Any]{
//
//                                self.dimension = (importantDataID["dimension"] as? String)!
//                                self.date = (importantDataID["date"] as? String)!
//                                self.descriptions = (importantDataID["description"] as? String)!
//                                self.artTitle = (importantDataID["title"] as? String)!
//                                self.material = (importantDataID["material"] as? String)!
//                                let art = Artwork(course:currentCourse!,artist:currentName!,key:index, desc: self.descriptions, title: self.artTitle, dimension: self.dimension, date:self.date, material: self.material)
//                                self.portfolio.append(art)
//
//                            }
//                        }
//                    }
//                    self.artworkNum = indexPath.row
//                    print(self.portfolio)
//
//                }
//            }else{
//                print("Document does not exist")
//            }
//        }

    }
    
    func fetchKeys(){
        
        let db = Firestore.firestore()
        let docRef = db.collection("artworks").document(currentUid)
        //print(docRef)
        docRef.getDocument{ (document,error) in
            if let document = document, document.exists{
                let result = document.data()
                if let importantData = result![self.currentCourse] as? [String:Any] {
                    let keys: Array<String> = Array<String>(importantData.keys)
                    self.collectionAlbum = keys
                }else{
                    print("Document does not exist")
                }
                self.fetchImages()
                self.groupQueue.leave()
                self.fetchData()
            }
        }
    }
    
    func fetchImages(){
       
        for key in collectionAlbum{
            groupQueue.enter()
            let ref = storage.reference().child("\(currentUid)/" + key)
            //print("\(ref)")
            //let ref = storage.reference("\(Auth.auth().currentUser!.uid)")
            ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                }else {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        self.imageCache[key] = image
                        //cell.pfImageView.image = image
                        //print(image)
                        //print(self.currentImage)
                        self.groupQueue.leave()
                        
                    }
                    //self.pfCollectionView.reloadData()
                }
            }
        }
    }
    
    func fetchData(){
        
        //let currentCourse = UserDefaults.standard.string(forKey: "storedClass")
        let currentUser = UserDefaults.standard.string(forKey: "storeduid")
        //let currentName = UserDefaults.standard.string(forKey: "currentUserName")
        //print(currentName)
        let docRef = db.collection("artworks").document(currentUser!)
        for key in collectionAlbum{
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    // print("Document data: \(dataDescription)")
                    let result = document.data()
                    
                    if let importantData = result![self.course] as? [String: Any] {
                        // print(importantData.keys)
                        // print(importantData)
                        if let importantDataID = importantData[key] as? [String: Any]{
                            // print(importantDataID)
                            self.dimension = (importantDataID["dimension"] as? String)!
                            self.date = (importantDataID["date"] as? String)!
                            self.descriptions = (importantDataID["description"] as? String)!
                            self.artTitle = (importantDataID["title"] as? String)!
                            self.material = (importantDataID["material"] as? String)!
                            let art = Artwork(course:self.course,artist:self.name, key:key, desc: self.descriptions, title: self.artTitle, dimension: self.dimension, date:self.date, material: self.material)
                            //self.portfolio.append(art)
                            if(self.portfolio[key] == nil){
                                
                                self.portfolio[key] = art
                            }
                            //self.pfCollectionView.reloadData()
                            // print(indexPath.row)
                        }
                        //print(self.portfolio)
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        pfCollectionView.reloadData()
        
//        if collectionAlbum.count == 0{
//            alertSign.isHidden = false
//        }else{
//            alertSign.isHidden = true
//        }
    }
    func fetchUserInfo() {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currentUid)
        docRef.getDocument{ (document,error) in
            if let document = document, document.exists{
                let result = document.data()
                self.firstName = (result!["firstName"] as? String)!
                self.lastName = (result!["lastName"] as? String)!
                UserDefaults.standard.set("\(self.firstName) \(self.lastName)", forKey: "currentUserName")
                self.pageTitle.text = "\(self.firstName) \(self.lastName)'s Portfolio"
            }
        }
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        currentCourse = UserDefaults.standard.string(forKey: "storedClass")!
        currentUid = UserDefaults.standard.string(forKey: "storeduid")!
        
        fetchUserInfo()
        //pageTitle.text = "\(currentName!)'s Portfolio"
        let image = UIImage(named: "whitelogos")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 2.5))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationItem.titleView = imageView
        courseName.text = UserDefaults.standard.string(forKey: "storedClass")
//        DispatchQueue.global().async {
//           self.fetchUserInfo()
//            self.fetchArtworks()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
//              //print(self.collectionAlbum)
//                self.pfCollectionView.reloadData()
//
//            }
//        }
        
       
        
        pfCollectionView.delegate = self
        pfCollectionView.dataSource = self
        currentUid = UserDefaults.standard.string(forKey: "storeduid")!
        fetchKeys()
        spinner.startAnimating()
        groupQueue.enter()
        groupQueue.notify(queue: .main) {
            self.pfCollectionView.reloadData()
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
       
        }
        let cellSize = UIScreen.main.bounds.width / 3 - 10
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10)
        layout.itemSize = CGSize(width: cellSize, height: cellSize + cellSize / 4)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3
        pfCollectionView.collectionViewLayout = layout
        
        //currentCourse = UserDefaults.standard.string(forKey: "storedClass")!
        //currentUid = UserDefaults.standard.string(forKey: "storeduid")!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PortfolioToMain" {
            if let destinationVC = segue.destination as? MainViewController {
                
                destinationVC.course = self.course
                destinationVC.portfolio = self.portfolio
                destinationVC.collectionArt = self.collectionAlbum
                destinationVC.thisPieceNum = self.artworkNum
                destinationVC.imageCache = self.imageCache
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
            }
        }
    }
}
