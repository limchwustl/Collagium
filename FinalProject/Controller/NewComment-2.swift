//
//  NewComment.swift
//  FinalProject
//
//  Created by Erin Crosby on 11/25/18.
//  Copyright © 2018 Chaehun Ben Lim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class NewComment: UIViewController, UITextFieldDelegate {

    /*
     Creates a new comment.
    */
    @IBOutlet var textField: UITextField!
    @IBOutlet var imageView: UIImageView!
    var piece : UIImage!
    var comment: String!
    var poster: String!
    var artKey: String!
    
    /*
     Gets and sets data associated with the user on the specified piece.
     If the piece has no data structure for comments, it is initialized. This done to cut down on memory space until
     it is absolutely necessary.
    */
   private func updateDB() {
        let fir = Firestore.firestore()
        let userDoc = fir.collection("Comments")
        userDoc.getDocuments(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let doc = querySnapshot?.documents
                for document in doc! {
                    if document.documentID == self.artKey{
                        let ref = document.reference
                        var docData = document.data()
                        var compData = docData["values"] as? [String: [String]]
                        let currentUser = Auth.auth().currentUser?.displayName
                        
                        //if picture has no initialized Data Structure
                        if(docData.count == 0){
                            
                            //format of map "values" -> user : [commentsByUser]
                            docData = [String : [String : [String]]]()
                            let userAndCom : [String: [String]] = [currentUser! : []]
                            docData = (["values" : userAndCom ])
                               // as? [String : Any])!
                            ref.setData(docData)
                            compData = docData["values"] as? [String: [String]]
                        }
                        
                        //if not comments are currently associated with the user
                        if( compData![currentUser!] == nil ){
                            var commentsOfUser = [""]
                            commentsOfUser[0] = self.comment
                            compData![currentUser!] = commentsOfUser
                        }
                        
                        //Normal append
                        else {
                            var appendArray = compData![currentUser!]
                            appendArray?.append(self.comment)
                            compData![currentUser!] = appendArray
                        }
                        
                        //sets data in firestore
                        docData["values"] = compData
                        ref.setData(docData)
                        self.dataSetAlert()
                    }
                    }
                }
        }
        )
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func post(_ sender: UIButton ){
        comment = textField.text
        updateDB()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = piece
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as? CommentsViewController
        dest?.newComment = comment
        dest?.currentArtKey = artKey
        dest?.piece = piece
    }
    
    func dataSetAlert() {
//        let alert = UIAlertController(title: "Comment Uploaded!", message: "Your comment has been uploaded. Please press 'Back' and then 'Refresh' to view your new comment.", preferredStyle: .alert)
//        let dis = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
//        alert.addAction(dis)
//        self.present(alert, animated: true)
        
        let alert = UIAlertController(title: "Upload", message: "Successfully uploaded your comment!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{
            (_)in
            self.performSegue(withIdentifier: "unwindToCommentView", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }

}
