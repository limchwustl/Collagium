//
//  SignUpViewController.swift
//  FinalProject
//
//  Created by Chaehun Ben Lim on 10/29/18.
//  Copyright © 2018 Chaehun Ben Lim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class SignUpViewController: UIViewController {

  
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    var currentUser:User!
//    var ref: DatabaseReference!
//
//    ref = Database.database().reference()
    //var db : Firestore!
    
    @IBAction func clickToMakeAccount(_ sender: UIButton) {
        guard let userFirstName = firstNameField.text else {return}
        guard let userLastName = lastNameField.text else {return}
        guard let email = emailField.text else {return}
        guard let pw = pwField.text else {return}
        
        let keyFirstName = userFirstName.replacingOccurrences(of: " ", with: "").capitalized
        let keyLastName = userLastName.replacingOccurrences(of: " ", with: "").capitalized
        let dataToSave: [String: Any] = ["email":email, "isInstructor": false, "firstName": keyFirstName, "lastName": keyLastName, "UID":Auth.auth().currentUser?.uid]
        let artworksDataToSave: [String: Any] = [:]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let autoLogin = appDelegate.loginListener {
            Auth.auth().removeStateDidChangeListener(autoLogin);
        }
        Auth.auth().createUser(withEmail: email, password: pw) {user, error in
            if error == nil && user != nil {
                print("user created")
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                let keyName = keyFirstName + " " + keyLastName
                changeRequest?.displayName = keyName
                changeRequest?.commitChanges { error in
                    if error == nil {
                        self.addUser(data: dataToSave)
                        self.addUserArtworksData(data: artworksDataToSave)
                        let alert = UIAlertController(title: "Account Created", message: "Please Sign In", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: self.login))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }else {
                if let thisError = error {
                    let errorMsg = stringError(thisError)
                    let alert = UIAlertController(title: "Sign Up Failed", message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
         
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.backgroundColor = .clear
        
        self.view.addSubview(navBar)
        navBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        navBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
       
        let backButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.back))
        self.navigationItem.rightBarButtonItem = backButton
        navBar.setItems([self.navigationItem], animated: false);

        // Do any additional setup after loading the view.
    }
    
    func addUser(data: [String: Any]){
        
        //ref2.child("users").child(FIRAuth.auth()!.currentUser!.uid).setValue(user)
        
        let ref = Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).setData(data){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
               
                print("User added to Firestore")
            }
        }
    }
    func addUserArtworksData(data: [String: Any]){
        
        //ref2.child("users").child(FIRAuth.auth()!.currentUser!.uid).setValue(user)
        
        let ref = Firestore.firestore().collection("artworks").document((Auth.auth().currentUser?.uid)!).setData(data){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                
                print("User artworks database added to Firestore")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    func login (alert: UIAlertAction!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
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
