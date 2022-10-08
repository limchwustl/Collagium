//
//  ChangePasswordViewController.swift
//  FinalProject
//
//  Created by Jin Seok Ahn on 12/1/18.
//  Copyright © 2018 Chaehun Ben Lim. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController {

   
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func updateButtonPressed(_ sender: Any) {
        let credential = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email)!, password: self.currentPasswordField.text!)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (error) in
            if error == nil {
                Auth.auth().currentUser?.updatePassword(to: self.newPasswordField.text!) { (error) in
                if error == nil {
                let alert = UIAlertController(title: "Password Changed", message: "Successfully Updated", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: self.success))
                self.present(alert, animated: true, completion: nil)
                } else {
                    self.errorMessage()
                    }
                }
            } else {
                self.errorMessage()
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func errorMessage () {
        let alert = UIAlertController(title: "Update Failed", message: "Current password does not match", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func success (alert: UIAlertAction!) {
        self.navigationController?.popViewController(animated: true)
    }

}
