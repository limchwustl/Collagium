//
//  AccountViewController.swift
//  FinalProject
//
//  Created by Chaehun Ben Lim on 11/7/18.
//  Copyright © 2018 Chaehun Ben Lim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let db = Firestore.firestore()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
//    @IBAction func clickTodeleteThisAccount(_ sender: UIButton) {
//        db.collection("courses").document
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToSetting(_ sender: UIButton) {
        performSegue(withIdentifier: "AccountToSetting", sender: self)
    }
    @IBAction func signOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController")
            
            UIApplication.shared.keyWindow?.rootViewController = loginViewController
            self.navigationController?.popToRootViewController(animated: true)
        } catch {
            print ("error signing out")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AccountToSetting" {
      
                
            
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
            
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
