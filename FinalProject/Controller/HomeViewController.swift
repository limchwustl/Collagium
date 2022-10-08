//
//  HomeViewController.swift
//  FinalProject
//
//  Created by Hakkyung on 2018. 11. 22..
//  Copyright © 2018년 Chaehun Ben Lim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var portfolio: [String: Artwork] = [:]
    var storePort: [Artwork] = []
    var courseList: [String] = []
    var imageCache: [String : UIImage] = [:]
    var currentUser: String = (Auth.auth().currentUser?.displayName)!
    var artworks: [Artwork] = []
    var collectionArt = [String]()
    let storage = Storage.storage()
    var date = String()
    var dimension = String()
    var descriptions = String()
    var material = String()
    var artTitle = String()
    var artworkNum: Int = 0
    let groupQueue = DispatchGroup()
    
    //var currentImage = UIImage()
    let db = Firestore.firestore()
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    @IBOutlet weak var alertSign: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(collectionArt.count)
        return collectionArt.count
       // return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        let key = collectionArt[indexPath.row]
        cell.homeImageView.image = imageCache[key]
        return cell
        
        //self.homeCollectionView.reloadData()
                //for index in collectionArt {
           // let theIndex = index
        
//        let ref = storage.reference().child("\(Auth.auth().currentUser!.uid)/" + collectionArt[indexPath.row])
//        print(collectionArt)
//        print("\(ref)")
        
        //        print(key)
        //print(imageCache[key])
      
        
        //print(currentImage)
        //print(cell.homeImageView.image)
        //homeCollectionView.reloadData()
        //}

        //let ref = storage.reference("\(Auth.auth().currentUser!.uid)")
//        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
//            if let error = error {
//                print(error.localizedDescription)
//            }else {
//                if let imageData = data {
//                    let image = UIImage(data: imageData)
//                    cell.homeImageView.image = image
//
//                }
//            }
//        }
//
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        artworkNum = indexPath.row
        choiceAlert()
        //self.performSegue(withIdentifier: "HomeToMain", sender: self)
        
        /*
        
        //let model = collectionArt[(indexPath.row)]
        UserDefaults.standard.set((Auth.auth().currentUser?.uid)!, forKey: "storeduid")
        let currentCourse = "myCourses"
        
        let docRef = db.collection("artworks").document("\(Auth.auth().currentUser!.uid)")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                // print("Document data: \(dataDescription)")
                let result = document.data()
                
                if let importantData = result!["\(currentCourse)"] as? [String: Any] {
                    // print(importantData.keys)
                    // print(importantData)
                    for index in self.collectionArt {
                        if let importantDataID = importantData[index] as? [String: Any]{
                            // print(importantDataID)
                            self.dimension = (importantDataID["dimension"] as? String)!
                            self.date = (importantDataID["date"] as? String)!
                            self.descriptions = (importantDataID["description"] as? String)!
                            self.artTitle = (importantDataID["title"] as? String)!
                            self.material = (importantDataID["material"] as? String)!
                            let art = Artwork(course:"\(currentCourse)",artist:(Auth.auth().currentUser?.displayName)!,key:index, desc: self.descriptions, title: self.artTitle, dimension: self.dimension, date:self.date, material: self.material)
                            self.portfolio.append(art)
                            // print(indexPath.row)
                        }
                    }
                    self.artworkNum = indexPath.row
                    print(self.portfolio)
                    self.choiceAlert()
                    //self.performSegue(withIdentifier: "HomeToMain", sender: self)
                }
            } else {
                print("Document does not exist")
            }
        }
        
        */
        
        
//       UserDefaults.standard.set((Auth.auth().currentUser?.uid)!, forKey: "storeduid")
//        let currentCourse = "myCourses"
//
//
//        let docRef = db.collection("artworks").document("\(Auth.auth().currentUser!.uid)")
//        docRef.getDocument { (document, error) in
//                        if let document = document, document.exists {
//                            //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                            // print("Document data: \(dataDescription)")
//                            let result = document.data()
//
//                            if let importantData = result!["\(currentCourse)"] as? [String: Any] {
//                                // print(importantData.keys)
//                               // print(importantData)
//                                if (self.portfolio.count != self.collectionArt.count) {
//                                    for index in self.collectionArt {
//                                    if let importantDataID = importantData[index] as? [String: Any]{
//                                       // print(importantDataID)
//                                        self.dimension = (importantDataID["dimension"] as? String)!
//                                        self.date = (importantDataID["date"] as? String)!
//                                        self.descriptions = (importantDataID["description"] as? String)!
//                                        self.artTitle = (importantDataID["title"] as? String)!
//                                        self.material = (importantDataID["material"] as? String)!
//                                        let art = Artwork(course:"\(currentCourse)",artist:(Auth.auth().currentUser?.displayName)!,key:index, desc: self.descriptions, title: self.artTitle, dimension: self.dimension, date:self.date, material: self.material)
//                                        self.portfolio.append(art)
//                                       // print(indexPath.row)
//                                        }
//                                    }
//                                }
//                                    self.artworkNum = indexPath.row
//                                print(self.portfolio)
//                                self.performSegue(withIdentifier: "HomeToMain", sender: self)
//                            }
//                            } else {
//                                print("Document does not exist")
//                            }
//                        }
        
    }



    func getKeys(){
      
//        let docRef = db.collection("artworks").document("\(Auth.auth().currentUser!.uid)")
//        let currentCourse = "myCourses"
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                // print("Document data: \(dataDescription)")
//                let result = document.data()
//
//                if let importantData = result!["\(currentCourse)"] as? [String: Any] {
//                   // print(importantData.keys)
//                    //print(importantData)
//                  let keys: Array<String> = Array<String>(importantData.keys)
//                    //print(keys)
//                    self.collectionArt = keys
//
//
//
//                } else {
//                    print("Document does not exist")
//                }
//
//
//            }
//
//        }
        
        let docRef = db.collection("artworks").document("\(Auth.auth().currentUser!.uid)")
        let currentCourse = "myCourses"
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                // print("Document data: \(dataDescription)")
                let result = document.data()
                
                if let importantData = result!["\(currentCourse)"] as? [String: Any] {
                    // print(importantData.keys)
                    //print(importantData)
                    let keys: Array<String> = Array<String>(importantData.keys)
                    //print(keys)
                    self.collectionArt = keys
                    //print(self.collectionArt)
                    self.fetchImages()
                    self.groupQueue.leave()
                    self.fetchData()
                    //print(self.collectionArt)
                    // self.homeCollectionView.reloadData()
                    //print(thistext)
                    //                    let currentMaterial = thistext["material"] as? String?
                    //                    //let currentdimension = thistext!["dimension"] as? String?
                    //                    print (currentMaterial!)
                } else {
                    print("Document does not exist")
                    self.groupQueue.leave()
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    self.homeCollectionView.reloadData()
                }
                //                print("fetch before")
                //                self.fetchImages()
            }
        }
    }

    func fetchImages(){
        //print("fetch in")
        //homeCollectionView.isHidden = true
        for key in collectionArt{
            groupQueue.enter()
            let ref = storage.reference().child("\(Auth.auth().currentUser!.uid)/" + key)
            //print("\(ref)")
            //let ref = storage.reference("\(Auth.auth().currentUser!.uid)")
            ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.groupQueue.leave()
                }else {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        if(self.imageCache[key] == nil){
                            
                            self.imageCache[key] = image
                            
                            self.groupQueue.leave()
                        }else {
                            self.groupQueue.leave()
                        }
                    }
                    //self.homeCollectionView.reloadData()
                }
            }
        }
    }
    
    func fetchData(){
        
        UserDefaults.standard.set((Auth.auth().currentUser?.uid)!, forKey: "storeduid")
        let currentCourse = "myCourses"
        
        for key in collectionArt{
            
            let docRef = db.collection("artworks").document(Auth.auth().currentUser!.uid)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    // print("Document data: \(dataDescription)")
                    let result = document.data()
                    
                    if let importantData = result!["\(currentCourse)"] as? [String: Any] {
                        // print(importantData.keys)
                        // print(importantData)
                        // for index in self.collectionArt {
                        if let importantDataID = importantData[key] as? [String: Any]{
                            // print(importantDataID)
                            self.dimension = (importantDataID["dimension"] as? String)!
                            self.date = (importantDataID["date"] as? String)!
                            self.descriptions = (importantDataID["description"] as? String)!
                            self.artTitle = (importantDataID["title"] as? String)!
                            self.material = (importantDataID["material"] as? String)!
                            let art = Artwork(course:"\(currentCourse)",artist:(Auth.auth().currentUser?.displayName)!,key:key, desc: self.descriptions, title: self.artTitle, dimension: self.dimension, date:self.date, material: self.material)
                            self.portfolio[key] = art
                            // print(indexPath.row)
                        }
                        //}
                        //self.artworkNum = indexPath.row
                        print(self.portfolio)
                    }
                    
                } else {
                    print("Document does not exist")
                    self.groupQueue.leave()
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    self.homeCollectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func clickToAddNewPortfolio(_ sender: UIButton) {
        performSegue(withIdentifier: "HomeToAdd", sender: self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        let image = UIImage(named: "whitelogos")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 2.5))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationItem.titleView = imageView
        if collectionArt == nil {
            spinner.stopAnimating()
            spinner.isHidden = true
        }
//        spinner.isHidden = false
//        spinner.startAnimating()
//        self.homeCollectionView.isHidden = true
//        self.homeCollectionView.reloadData()
//        DispatchQueue.global().async {
//            self.fetchMyCourses()
//            self.getKeys()
//            self.fetchMyCourses()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//
//                self.homeCollectionView.reloadData()
//                self.spinner.isHidden = true
//                self.spinner.stopAnimating()
//                self.homeCollectionView.isHidden = false
//            }
//
//
//        }
       

        // Do any additional setup after loading the view.
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        //print(currentImage)
        //homeCollectionView.reloadData()
//        let cellSize = UIScreen.main.bounds.width / 3 - 10
//
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5)
//        layout.itemSize = CGSize(width: cellSize, height: cellSize + cellSize / 4)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 3
//        homeCollectionView.collectionViewLayout = layout
        
        fetchMyCourses()
        spinner.startAnimating()
        groupQueue.enter()
        getKeys()
        
        groupQueue.notify(queue: .main) {
            self.homeCollectionView.reloadData()
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
        }
        
        //fetchArtworks()
        
    }
    func choiceAlert(){
        let alert = UIAlertController(title: "You have selected a piece of art.", message: "Would you like to view this piece or delete it? Deleting will permenantly remove this piece.", preferredStyle: .alert)
        let view = UIAlertAction(title: "VIEW", style: .default, handler: { action in
            self.performSegue(withIdentifier: "HomeToMain", sender: self)
        })
        let delete = UIAlertAction(title: "DELETE", style: .destructive) { action in
           
            DispatchQueue.global().async {
                self.pathToRemove()
                DispatchQueue.main.async {
                    self.homeCollectionView.reloadData()
                }
            }
         
                //self.collectionArt = [String]()
                
                    //self.homeCollectionView.reloadData()
            
            
            
            
            
                
                
            
            
           // print(self.collectionArt)
           // self.homeCollectionView.reloadData()
        }
        alert.addAction(view)
        alert.addAction(delete)
        self.present(alert, animated: true)
         self.homeCollectionView.reloadData()
    }
    
    
    func pathToRemove(){
        let thisKey = self.collectionArt[self.artworkNum]
        //Remove from artworks
        let col = Firestore.firestore().collection("artworks")
         col.getDocuments(completion: {  (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for doc in (querySnapshot?.documents)!{
                    if doc.documentID == Auth.auth().currentUser?.uid{
                        var docData = doc.data()
                        print("doc data")
                        for map in docData {
                            print("map")
                            print(map.key)
                            print(map.value)
                            let pieces : String = map.key
                            var thisCourse = docData[pieces] as? [String : Any]
                            for piece in thisCourse! {
//                                if self.collectionArt.count > 0 {
                                if piece.key == thisKey{
                                    thisCourse![piece.key] = nil
                                    docData[pieces] = thisCourse
                                   //// print(docData[pieces])
                                    
                                }
//                                }
                            }
                            print(docData)
                            
                            let ref = doc.reference
                            ref.setData(docData)
                        }
                        
                    }
                }
            }
        })
        
        //remove from Comments
        let com = Firestore.firestore().collection("Comments").document(collectionArt[artworkNum])
        com.delete { (error) in
            if let err = error {
                print(err)
            }
            else {
                print("It worked")
            }
        }
        
        //remove from storage
        let uid : String = (Auth.auth().currentUser?.uid)!
        let path : String = "\(uid)/\(collectionArt[artworkNum])"
        let smallRef = self.storage.reference().child(path)
        smallRef.delete { (error) in
            if let error = error {
                print(error.localizedDescription)
                print(path)
            }
            else {
                print("Successful delete")
                self.imageCache.removeValue(forKey: path)
            }
        }
        //self.collectionArt = docData.keys as? [String]
        self.collectionArt.remove(at: self.artworkNum)
       
    }
    /* https://www.andrewcbancroft.com/2015/12/18/working-with-unwind-segues-programmatically-in-swift/
     */
    @IBAction func unwindToHomeView(segue: UIStoryboardSegue){ }
    
    
    func fetchMyCourses(){

        let db = Firestore.firestore()
        let myUID = Auth.auth().currentUser?.uid
        db.collection("courses").whereField("userUID", arrayContains: myUID!).getDocuments(){ (querySnapshot, err) in
            if let err = err {

                print("Error getting documents: \(err)")
                return
            }
            else{

                for document in querySnapshot!.documents {

                    if(!self.courseList.contains(document.get("name") as! String)){

                        self.courseList.append(document.get("name") as! String)
                    }
                }
                self.homeCollectionView.reloadData()
            }
        }
    

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if  collectionArt.count > 0 {
//            let layout = UICollectionViewFlowLayout()
//            layout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5)
//            layout.itemSize = CGSize(width: cellSize, height: cellSize + cellSize / 4)
//            layout.minimumInteritemSpacing = 0
//            layout.minimumLineSpacing = 3
//            homeCollectionView.collectionViewLayout = layout
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.viewDidLoad()
        

    }
    
    @IBAction func refresh(_ sender: UIButton) {
        self.homeCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToMain" {
            if let destinationVC = segue.destination as? MainViewController {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                destinationVC.portfolio = self.portfolio
                //print(self.portfolio)
                destinationVC.thisPieceNum = self.artworkNum
                print(collectionArt)
                destinationVC.collectionArt = self.collectionArt
                destinationVC.imageCache = self.imageCache
                //destinationVC.thisArtist.text = currentUser
            }
        }
        else if segue.identifier == "HomeToAdd"{
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            if let destinationVC = segue.destination as? AddPFViewController{
                
                destinationVC.courseList = self.courseList
            }
        }
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
