//
//  CommentsViewController.swift
//  FinalProject
//
//  Created by Chaehun Ben Lim on 11/7/18.
//  Copyright © 2018 Chaehun Ben Lim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    /*
     CommentsViewController controls the comments made by users on the selected piece. User comments are stored as
     cells in the UITableView. A selected cell will spawn an alert sheet with all the comments the User has made for that piece.
     selecting a comment by that user from the sheet will render an alert view with the comment as the title.
     
     tableView must be refreshed after visiting newComment in order for the new comments to be displayed. Navigation from newComment
     to CommentsViewController is handeled via the Navigation controller so the viewDidLoad() method of CommentsVC will not reload the
     data. Data refresh must therefore be user initiated.
 
    */
    
    var newComment : String!
    var piece : UIImage!
    var commentary = [String : [String]]()
    var currentArtKey: String!
    var postersInDoc : [String] = [""]
    @IBOutlet var tableView: UITableView!
    
    //Refreshes tableView
    
    @IBAction func unwindToCommentView(segue: UIStoryboardSegue){ }
    
    //Segue to add newComment
    @IBAction func addComment(_ sender: UIButton){
        performSegue(withIdentifier: "toNewComment", sender: self
        )
    }
    
    
    /*
     MARK: TableViewFunctionality
    */
    
    //Init number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for k in commentary {
            if(postersInDoc[0] == ""){
                postersInDoc.insert(k.key, at: 0)
            }
            else {
                postersInDoc.append(k.key)
            }
            count = count + 1
            print(postersInDoc[count-1])
        }
        if(postersInDoc == nil){
            return count
        }
        print(postersInDoc)
        return postersInDoc.count
    }
    
    //Init cell name
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        if(indexPath.row < postersInDoc.count ){
            let post = postersInDoc[indexPath.row]
            if(post != ""){
                let comm = commentary[post]
                cell.textLabel?.text = postersInDoc[indexPath.row]
                cell.detailTextLabel?.numberOfLines = (comm?.count)!
                cell.detailTextLabel?.text = comm![0]
                cell.detailTextLabel?.font = UIFont(name: "avenir next", size: 12)
                cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
                cell.detailTextLabel?.minimumScaleFactor = 0.5
                if (comm?.count)! > 1{
                for i in  1 ... comm!.count-1{
                    if let currText = cell.detailTextLabel?.text {
                        cell.detailTextLabel?.text = "\(currText)\n\(comm![i])"
                    }
                }
                }
                //showComment(poster: post, comment: comm!)
            }
        }
       
        return cell
    }
    
    //Select and show comments of user


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getComments()
        
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        commentary = [String : [String]]()
        postersInDoc = [""]
        tableView.reloadData()
        getComments()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     MARK: getComments() : loads comments from firestore associated with this piece.
    */
    func getComments(){
        let db = Firestore.firestore()
        let commentOfArt = db.collection("Comments")
        commentOfArt.getDocuments(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //pulls up document associated with piece
                    if document.documentID == self.currentArtKey {
                        let docDictionary = document.data()
                        if(docDictionary.count != 0){
                        self.commentary = (docDictionary["values"] as? [String : [String]])!
                        self.tableView.reloadData()
                        }
                }
            }
        }
        
    }
        )
    }
    
    /*
     MARK: Alert Functions
    */
    
    //Show
    
    
    //display comment
    func newComment(comment: String){
        let alert = UIAlertController(title: comment, message: "", preferredStyle: .alert)
        let dis = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dis)
        self.present(alert, animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as? NewComment
        dest?.artKey = currentArtKey
        dest?.piece = piece
    }
    
    
}

