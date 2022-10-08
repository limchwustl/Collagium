//
//  LogInViewController.swift
//  FinalProject
//
//  Created by Chaehun Ben Lim on 10/29/18.
//  Copyright © 2018 Chaehun Ben Lim. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet var openingView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet var signinview: UIView!
    var openingViewCount = 1
    

    
    @IBAction func setEmailFieldToNil(_ sender: UITextField) {
        usernameField.text = ""
    }
    @IBAction func setPasswordFieldToNil(_ sender: UITextField) {
        passwordField.text = ""
    }
    
    @IBAction func enterSignUp(_ sender: UIButton) {
        performSegue(withIdentifier: "SignInToSignUp", sender: self)
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!) {(user,error) in
            if error == nil{
            print ("logged in!")
               self.performSegue(withIdentifier: "SignInToClass", sender: self)
        } else {
                if let thisError = error {
                    let errorMsg = stringError(thisError)
                    let alert = UIAlertController(title: "Log In Failed", message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    }
    func showLoadingScreen() {

        openingView.bounds.size.height = view.bounds.size.height
        openingView.bounds.size.width = view.bounds.size.width
        openingView.center = view.center
        view.addSubview(openingView)
        
    }
    func hideLoadingScreen() {
        UIView.animate(withDuration: 0, animations: {self.openingView.transform = CGAffineTransform(translationX: 0, y: -800)
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if openingViewCount == 1 {
            showLoadingScreen()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.hideLoadingScreen()
                self.openingViewCount = 2
            }
           signInButton.layer.cornerRadius = signInButton.frame.height/2
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
