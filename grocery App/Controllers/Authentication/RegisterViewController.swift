//
//  RegisterViewController.swift
//  grocery App
//
//  Created by Wa ibra. on 05/04/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class RegisterViewController: UIViewController {

    //Variables
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){

        //hide the error label
        errorLabel.alpha = 0
        
        //style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleFilledButton(signUpButton)

    }
    
    //check the fields and validate data
    func validateFields() -> String? {
        
        //check all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            //remove all spaces and check if field is empty
            return "Please fill in all fields"
            
        }
        
        //check if password is secure
        let cleanPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanPassword) == false{
            //password isn't secure enough
            return "please make sure your password is at least 8 characters, contains a special character and a number"
        }
        
        return nil
    }

   
    @IBAction func signUpPressed(_ sender: Any) {
        
        let error = validateFields()
        if error != nil {
            // there's something wrong with the fields, show error message
            showError(error!)
        }
        else{
            //remove all spaces
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create user in firebase
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //check for errors
                if err != nil{
                    //error creating user
                    self.showError("Error creating user")
                }
                else{
                    
                     //User created seccessfully, store first and last name
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname" : firstName, "lastname": lastName, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            //show error message
                            self.showError("Error saving user data")
                        }
                    }
                    // trinsition to grocery screen
                    self.transitionToGrocery()
                    
                }
            }
        }
    }
    
    func transitionToGrocery(){
        //after passing all errors go to groceryVC and set it as root VC
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "allGroceryViewController") as? allGroceryViewController
        view.window?.rootViewController = nextVC
        view.window?.makeKeyAndVisible()
    }
    
    //Display Error
    func showError( _ message: String ){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
}
