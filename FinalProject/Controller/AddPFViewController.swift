//
//  AddPFViewController.swift
//  FinalProject
//
//  Created by Chaehun Ben Lim on 11/7/18.
//  Copyright © 2018 Chaehun Ben Lim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AddPFViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
   /*
    
     TODO:
        1. Implement functionality to save title, material, desc Strings and
            sanitize. x
        2. Implement Date -> String functionality x
        3. Get Photo/Preview/Stage Photo function
        4. Get dimension input -> String x
        5. Alerts for unfilled fields
        6. Async uploads to firestore
    */
    
    var imageGetter : UIImagePickerController = UIImagePickerController()
    @IBOutlet var artTitleField: UITextField!
    @IBOutlet var materialField: UITextField!
    let commentsDataToSave: [String: Any] = [:]
    @IBOutlet var datePick: UIDatePicker!
    @IBOutlet var dimOne: UITextField!
    @IBOutlet var dimTwo: UITextField!
    @IBOutlet weak var descriptiontextField: UITextView!
    @IBOutlet weak var coursePicker: UIPickerView!
    @IBOutlet weak var checkedBox: UIButton!
    
    var piece: UIImage!
    var course: String = ""
    var courseList: [String] = []
    lazy var selectedPicker: String = courseList[0]
    let storageRef = Firebase.Storage.storage().reference()
    let databaseRef = Database.database().reference()
    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    let timeStamp = NSDate().timeIntervalSince1970
    lazy var currentUser = Auth.auth().currentUser
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return courseList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label = UILabel()
        if let view = view as? UILabel{
            
            label = view
        }
        
        label.text = courseList[row]
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if courseList.count > 0{
        
        
        selectedPicker = courseList[row]
        }
       
    }
    

    /* https://www.andrewcbancroft.com/2015/12/18/working-with-unwind-segues-programmatically-in-swift/
 */
    func addUserArtworksDataToComment(data: [String: Any]){
//        let selected = selectedPicker
//        //ref2.child("users").child(FIRAuth.auth()!.currentUser!.uid).setValue(user)
//
//         Firestore.firestore().collection("Comments").document("\(Auth.auth().currentUser!.uid)_\(selected)_\(artTitleField.text!)_\(timeStamp)").setData(data){ err in
//            if let err = err {
//                print(err.localizedDescription)
//            } else {
//
//                print("User artworks database added to Firestore")
//            }
//        }
        let ref = Firestore.firestore().collection("Comments").document("\(Auth.auth().currentUser!.uid)_\(selectedPicker)_\(artTitleField.text!)_\(timeStamp)").setData(data){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {

                print("User artworks database added to Firestore")
            }
            let alert = UIAlertController(title: "Upload", message: "Successfully uploaded the artwork!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{
                (_)in
                self.performSegue(withIdentifier: "unwindToHomeView", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageGetter.delegate = self
        coursePicker.dataSource = self
        coursePicker.delegate = self
        coursePicker.showsSelectionIndicator = true
        checkedBox.setImage(UIImage(named: "unchecked"), for: .normal)
        checkedBox.setImage(UIImage(named: "checked"), for: .selected)
        
        let color = UIColor(red: 238, green: 235, blue: 235, alpha: 1)
        datePick.backgroundColor = color
        let image = UIImage(named: "whitelogos")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 2.5))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationItem.titleView = imageView
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        //courseList = UserDefaults.standard.array(forKey: "myCourses") as! [String]
        //selectedPicker = courseList[0]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadArt(_ sender: Any) {
//        let thisDate = getDate(datePick)
//       coursePicker.reloadAllComponents()
//      //let selected = pickerData[coursePicker.selectedRow(inComponent:)
//        let selected = selectedPicker
//        let dataToSave: [String: Any] =  ["\(Auth.auth().currentUser!.uid)_\(selected)_\(artTitleField.text!)_\(timeStamp)" : ["title":artTitleField.text!,"dimension" : dimOne.text! + "X" + dimTwo.text!,"material" : materialField.text!, "date" : thisDate, "description" : descriptiontextField.text!]]
//        print(dataToSave)
//        pushToCloud(data: dataToSave)
//        pushToMyCloud(data: dataToSave)
//        addUserArtworksDataToComment(data: commentsDataToSave)
        let thisDate = getDate(datePick)
        let checkArray = self.getText()
        if(!checkArray.contains("")){
            let dataToSave: [String: Any] =  ["\(Auth.auth().currentUser!.uid)_\(selectedPicker)_\(artTitleField.text!)_\(timeStamp)" : ["title":artTitleField.text!,"dimension" : dimOne.text! + "X" + dimTwo.text!,"material" : materialField.text!, "date" : thisDate, "description" : descriptiontextField.text!]]
            pushToCloud(data: dataToSave)
            pushToMyCloud(data: dataToSave)
            addUserArtworksDataToComment(data: commentsDataToSave)
        }
        else {
            incompleteAlert()
        }
    }
   
    //https://stackoverflow.com/questions/24051904/how-do-you-add-a-dictionary-of-items-into-another-dictionary
     func addTogether <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>)
        -> Dictionary<K,V>
    {
        var map = Dictionary<K,V>()
        for (k, v) in left {
            map[k] = v
        }
        for (k, v) in right {
            map[k] = v
        }
        return map
    }
    func pushToCloud(data: [String: Any]){
        let db = Firestore.firestore()
        let selected = selectedPicker
      let docRef = db.collection("artworks").document("\(Auth.auth().currentUser!.uid)")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var thisData = document.data()
                document.data()
                //print(document.data())
                let storedData = thisData![selected] as? [String: Any]
                if storedData != nil {
                let newUpdatedData = self.addTogether(left: storedData!, right: data)
                print (newUpdatedData)
                let finalData: [String: Any] = [selected:newUpdatedData]
                db.collection("artworks").document("\(Auth.auth().currentUser!.uid)").updateData(finalData)
                       { err in
                            if let err = err {
                                print(err.localizedDescription)
                            }else{
                                print ("added!")
                        }
                }
                } else {
                    let finalData: [String: Any] = [selected:data]
                    db.collection("artworks").document("\(Auth.auth().currentUser!.uid)").updateData(finalData)
                    { err in
                        if let err = err {
                            print(err.localizedDescription)
                        }else{
                            print ("added!")
                        }
                    }
                }
            }
        }
    }
    func pushToMyCloud(data: [String: Any]){
        let db = Firestore.firestore()
        let docRef = db.collection("artworks").document("\(Auth.auth().currentUser!.uid)")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var thisData = document.data()
                document.data()
                //print(document.data())
                let storedData = thisData!["myCourses"] as? [String: Any]
                if storedData != nil {
                    let newUpdatedData = self.addTogether(left: storedData!, right: data)
                    print (newUpdatedData)
                    let finalData: [String: Any] = ["myCourses":newUpdatedData]
                    db.collection("artworks").document("\(Auth.auth().currentUser!.uid)").updateData(finalData)
                    { err in
                        if let err = err {
                            print(err.localizedDescription)
                        }else{
                            print ("added to my Portfolio!")
                        }
                    }
                } else {
                    let finalData: [String: Any] = ["myCourses":data]
                    db.collection("artworks").document("\(Auth.auth().currentUser!.uid)").updateData(finalData)
                    { err in
                        if let err = err {
                             print(err.localizedDescription)
                        }else{
                            print ("added to my Portfolio!")
                        }
                    }
                }
            }
        }
    }
    
    

    
    @IBAction func uploadPhotos(_ sender: UIButton) {
        self.imageGetter.sourceType = .photoLibrary
        self.present(imageGetter,animated: true,completion: nil)
    }
    func getDate(_ sender: UIDatePicker) -> String{
        let format = DateFormatter()
        format.dateFormat = "MM/dd/YYYY"
        let subDate = format.string(from: sender.date)
        return subDate
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let drawingImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        changeRequest?.photoURL = info[UIImagePickerControllerPHAsset] as? URL
        var dlURL = ""
        let selected = selectedPicker
        var data = NSData()
        data = UIImageJPEGRepresentation(drawingImage!, 0.8)! as NSData as NSData
        // set upload path
        print(selected)
        let filePath = "\(Auth.auth().currentUser!.uid)/\(Auth.auth().currentUser!.uid)_\(selected)_\(artTitleField.text!)_\(timeStamp)"
        // pass course name
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        self.storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                metaData?.storageReference?.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    let dldURL = url?.absoluteString
                    dlURL = dldURL!
                    print(dlURL)
                })
            }
            self.imageGetter.dismiss(animated: true)
        }
        self.imageGetter.dismiss(animated: true){
            
            self.checkedBox.isSelected = !self.checkedBox.isSelected
        }
    }
    func incompleteAlert(){
        let alert = UIAlertController(title: "Incomplete Fields", message: "You have not filled out all fields or uploaded a photo yet.", preferredStyle: .alert)
        let dis = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dis)
        self.present(alert, animated: true)
    }
    
    func getText() -> [String]{
        var uploadText = [String](repeatElement("", count: 4))
        uploadText[0] = artTitleField.text!
        uploadText[1] = materialField.text!
        uploadText[2] = descriptiontextField.text!
        uploadText[3] = dimOne.text! + " x " + dimTwo.text!
        return uploadText
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
