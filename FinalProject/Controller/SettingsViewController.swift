//
//  SettingsViewController.swift
//  FinalProject
//
//  Created by Chaehun Ben Lim on 11/7/18.
//  Copyright © 2018 Chaehun Ben Lim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    let userID = Auth.auth().currentUser?.uid
    var myCourses: [String] = []
    var courseSet: [String] = []
    var selected = ""
    var firstName = String()
    var lastName = String()
    //let storage = Storage.storage()
    var db: Firestore!
    var myPickerView: UIPickerView!
    
    
    //let dbb = Firestore.firestore()
   
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var myNameLabel: UILabel!
    @IBOutlet weak var myEmailLabel: UILabel!
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var courseTableView: UITableView!
    
    
    
    let storageRef = Firebase.Storage.storage().reference()
    let databaseRef = Database.database().reference()
    var imageGetter : UIImagePickerController = UIImagePickerController()
    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    let storage = Firebase.Storage.storage()
    override func viewDidAppear(_ animated: Bool) {
        UserDefaults.standard.set(myCourses, forKey: "myCourses")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let image = UIImage(named: "whitelogos")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 2.5))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationItem.titleView = imageView
        courseTableView.dataSource = self
        courseTableView.delegate = self
        imageGetter.delegate = self
        myTextField.delegate = self
        self.myPickerView = UIPickerView(frame: CGRect.zero)
        myPickerView.showsSelectionIndicator = true
        fetchUserInfo()
        //myNameLabel.text = Auth.auth().currentUser?.displayName!
        myEmailLabel.text = Auth.auth().currentUser?.email!
        downloadImage()
       // getValue()
        
    }
    
    @IBAction func addingCourse(_ sender: Any) {
        
        myTextField.becomeFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.pickUp(myTextField)
    }
    
    @IBAction func changePasswordPressed(_ sender: Any) {
        performSegue(withIdentifier: "AccountToPasswordChange", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        fetchMyCourses()
        fetchCourseList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeProfilePicture(_ sender: Any) {
        self.imageGetter.sourceType = .photoLibrary
        self.present(imageGetter,animated: true,completion: nil)
        //print(userID)
        // File located on disk
       
        
        
    }
    //https://iosdevcenters.blogspot.com/2017/05/uipickerview-example-with-uitoolbar-in.html
    func pickUp(_ textField : UITextField){
        
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    @objc func doneClick() {
        
        checkAndAdd(course: selected)
        myTextField.resignFirstResponder()
    }
    @objc func cancelClick() {
        
        selected = courseSet[0]
        myTextField.resignFirstResponder()
    }
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
                    
                    if(!self.myCourses.contains(document.get("name") as! String)){
                        
                        self.myCourses.append(document.get("name") as! String)
                    }
                }
                self.myCourses.sort()
                self.courseTableView.reloadData()
            }
        }
    }
    func checkAndAdd(course: String){
        
        let db = Firestore.firestore()
        let myUID = Auth.auth().currentUser?.uid
        let myName = Auth.auth().currentUser?.displayName
        
        db.collection("courses").document(course).getDocument(){ (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                if let uidArray = dataDescription!["userUID"] as? [String] {
                    
                    if(!uidArray.contains(myUID!)){
                        
                        self.addUID(uid: myUID!, course: self.selected)
                        
                        let alert = UIAlertController(title: "Message", message: "\(myName!) is now enrolled in \(self.selected)!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        print("\(myUID!) is now enrolled in \(self.selected)")
                    }
                    else{
                        
                        let alert = UIAlertController(title: "Message", message: "\(myName!) is already enrolled in \(self.selected)!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        print("\(myUID!) is already enrolled in \(self.selected)")
                    }
                    
                    self.fetchMyCourses()
                    self.selected = self.courseSet[0]
                }
            } else {
                print("Document does not exist")
            }
        }
    }
   func addUID(uid: String, course: String){
        
        let db = Firestore.firestore()
        //let removed = course.replacingOccurrences(of: " ", with: "")
        db.collection("courses").document(course).updateData([
            
            "userUID": FieldValue.arrayUnion([uid])
            ])
    }
    
    func removeUID(uid: String, course: String){
        
        let db = Firestore.firestore()
        db.collection("courses").document(course).updateData([
            
            "userUID": FieldValue.arrayRemove([uid])
            ])
    }

    func downloadImage() {
        
        let ref = storage.reference().child("\(Auth.auth().currentUser!.uid)" + "/profilePicture")
        
        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
            }else {
                if let imageData = data {
                    let image = UIImage(data: imageData)
                   
                    self.profileImageView.image = image
                }
            }
        }

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
   
        let currentImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        changeRequest?.photoURL = info[UIImagePickerControllerPHAsset] as? URL
      
        var dlURL = ""
        
        var data = NSData()
        data = UIImageJPEGRepresentation(currentImage!, 0.8)! as NSData as NSData
        // set upload path
        let filePath = "\(Auth.auth().currentUser!.uid)/\("profilePicture")"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        self.storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                
                metaData?.storageReference?.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                   let dldURL = url?.absoluteString
                    dlURL = dldURL!
                })
               
                self.databaseRef.child("users").child(Auth.auth().currentUser!.uid).updateChildValues(["userPhoto": dlURL])
            
            
            }
            self.imageGetter.dismiss(animated: true)
            self.downloadImage()
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = myCourses[indexPath.row]
        cell.textLabel?.font = UIFont(name: "baskerville", size: 20)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.5
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        courseTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){
            
            let course = myCourses[indexPath.row]
            self.myCourses.remove(at: indexPath.row)
            removeUID(uid: (Auth.auth().currentUser?.uid)!, course: course)
            courseTableView.reloadData()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return courseSet.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label = UILabel()
        if let view = view as? UILabel{
            
            label = view
        }
        
        label.text = courseSet[row]
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selected = courseSet[row]
    }
    
    func fetchCourseList(){
        
        let db = Firestore.firestore()
        db.collection("courses").getDocuments(){ (querySnapshot, err) in
            if let err = err{
                
                print("Error getting document: \(err)")
                return
            }
            else{
                
                for document in querySnapshot!.documents{
                    
                    let courseName:String = document.get("name") as! String
                    self.courseSet.append(courseName)
                }
            }
            
        self.selected = self.courseSet[0]
        }
    }
    
    func fetchUserInfo() {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document((Auth.auth().currentUser?.uid)!)
        docRef.getDocument{ (document,error) in
            if let document = document, document.exists{
                let result = document.data()
                self.firstName = (result!["firstName"] as? String)!
                self.lastName = (result!["lastName"] as? String)!
                self.myNameLabel.text = "\(self.firstName) \(self.lastName)"
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AccountToPasswordChange" {
            
            
            
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
