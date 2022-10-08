//
//  MainViewController.swift
//  FinalProject
//
//  Created by Chaehun Ben Lim on 11/1/18.
//  Copyright © 2018 Chaehun Ben Lim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MainViewController: UIViewController {

    
    @IBOutlet weak var thisTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var screenView: UIView!
    @IBOutlet weak var thisDesc: UILabel!
    @IBOutlet weak var thisDim: UILabel!
    @IBOutlet weak var thisDate: UILabel!
    @IBOutlet weak var thisMaterial: UILabel!
    @IBOutlet weak var thisArtist: UILabel!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    var thisPieceNum: Int = 0
    var portfolio: [String: Artwork] = [:]
    var imageCache: [String: UIImage] = [:]
    var artist: String!
    var course: String = ""
    var collectionArt = [String]()
    let storage = Storage.storage()
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        updateView()
        fetchLikes()
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeLeftRecognizer.numberOfTouchesRequired = 1
        swipeLeftRecognizer.direction = .left
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeRightRecognizer.numberOfTouchesRequired = 1
        swipeRightRecognizer.direction = .right
        self.screenView.addGestureRecognizer(swipeLeftRecognizer)
        self.screenView.addGestureRecognizer(swipeRightRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToCreatePF" {
            if let destinationVC = segue.destination as? AddPFViewController {
                destinationVC.course = self.course
            }
        }
        if segue.identifier == "MainToComment"{
            if let vc = segue.destination as?
                CommentsViewController {
                vc.piece = self.imageView.image
                vc.currentArtKey = self.collectionArt[thisPieceNum]
            }
        }
    }
    
    func fetchLikes () {
        let db = Firestore.firestore()
        let docRef = db.collection("likes").document(self.collectionArt[self.thisPieceNum])
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let result = document.data()
                if let importantData = result!["likedUsers"] as? [String: Bool] {
                    self.showNumLikesOnLabel(num: importantData.count)
                    if let currUid = Auth.auth().currentUser?.uid {
                        if (importantData[currUid] != nil) {
                            self.likeButton.setImage(UIImage(named:"filledLike"), for: UIControlState.normal)
                        } else {
                            self.likeButton.setImage(UIImage(named:"emptyLike"), for: UIControlState.normal)
                        }
                    }
                } else {
                    self.numLikes.text = "0 likes"
                    self.likeButton.setImage(UIImage(named:"emptyLike"), for: UIControlState.normal)
                }
            } else {
                self.numLikes.text = "0 likes"
                self.likeButton.setImage(UIImage(named:"emptyLike"), for: UIControlState.normal)
            }
        }
    }
    
    func updateView() {
        
        let key = collectionArt[thisPieceNum]
        thisTitle.text = self.portfolio[key]?.title
        thisDesc.text = self.portfolio[key]?.desc
        thisDim.text = self.portfolio[key]?.dimension
        thisArtist.text = self.portfolio[key]?.artist
        thisDate.text = self.portfolio[key]?.date
        thisMaterial.text = self.portfolio[key]?.material
        imageView.image = imageCache[key]
    }
    
    func clickLike() {
        if let currUid = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            let docRef = db.collection("likes").document(self.collectionArt[self.thisPieceNum])
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let result = document.data()
                    if var importantData = result!["likedUsers"] as? [String: Bool] {
                        if (importantData[currUid] == nil) {
                            importantData["\(currUid)"] = true
                            self.likeButton.setImage(UIImage(named:"filledLike"), for: UIControlState.normal)
                        } else {
                            importantData.removeValue(forKey:currUid)
                            self.likeButton.setImage(UIImage(named:"emptyLike"), for: UIControlState.normal)
                        }
                        docRef.setData(["likedUsers":importantData])
                        self.showNumLikesOnLabel(num: importantData.count)
                    } else {
                        self.newLike(db: db, currUid: currUid)
                    }
                } else {
                    self.newLike(db: db, currUid: currUid)
                }
            }
        } else {
            print("No UID fetched")
        }
    }
    
    func showNumLikesOnLabel(num: Int) {
        if (num != 1) {
            self.numLikes.text = "\(num) likes"
        } else {
            self.numLikes.text = "1 like"
        }
    }
    
    func newLike(db: Firestore, currUid: String) {
        let newMap = [currUid : true]
        db.collection("likes").document(self.collectionArt[self.thisPieceNum]).setData (["likedUsers" : newMap]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                self.numLikes.text = "1 like"
                self.likeButton.setImage(UIImage(named:"filledLike"), for: UIControlState.normal)
                print("Document successfully written")
            }
        }
    }
    
    @objc func swipeRight() {
        if (thisPieceNum == 0) {
            thisPieceNum = self.portfolio.count
        }
        if (thisPieceNum > 0) {
            thisPieceNum = thisPieceNum - 1
            updateView()
            fetchLikes()
        }
    }
    
    @objc func swipeLeft() {
        if (thisPieceNum == self.portfolio.count-1) {
            print("CAUGHT")
            thisPieceNum = -1
        }
        if (thisPieceNum < self.portfolio.count-1) {
            thisPieceNum = thisPieceNum + 1
            updateView()
            fetchLikes()
        }
    }
    
    @IBAction func clickToComment(_ sender: UIButton) {
        performSegue(withIdentifier: "MainToComment", sender: self)
    }
    @IBAction func likeButtonPressed(sender: Any) {
        clickLike()
    }
}
