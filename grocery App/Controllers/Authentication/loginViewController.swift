//
//  ViewController.swift
//  grocery App
//
//  Created by Wa ibra. on 05/04/1443 AH.
//

import UIKit
import FirebaseAuth


class loginViewController: UIViewController {

    //Variables
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    func setUpElements(){
        
        //hide the error label
        errorLabel.alpha = 0
        
        //style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleFilledButton(loginButton)

    }
    
 
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //signing in user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil{
                //fail to sign in
                self.showError("Incorrect Email/Password Combination")
                
            }
            else{ //go to next vc 
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "allGroceryViewController") as? allGroceryViewController
                self.view.window?.rootViewController = nextVC
                self.view.window?.makeKeyAndVisible()
            }
        }

    }
    

    
    //Display error message
    func showError( _ message: String ){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}



