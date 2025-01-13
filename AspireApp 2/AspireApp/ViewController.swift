//
//  ViewController.swift
//  AspireApp
//
//  Created by Jacky Becker on 2024-11-25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var signInModel = Sign_In_Model()
    var signedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        passwordTextField.isSecureTextEntry = true
        
    

        Auth.auth().addStateDidChangeListener { auth, user in
          if user != nil {

            // User is signed in. Show home screen
              let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabsViewController") as! UITabBarController
              vc.modalPresentationStyle = .fullScreen
              self.present(vc, animated: true, completion: nil)
              
              
          } else {
            // No User is signed in. Show user the login screen
              print("not logged in!!")
          }
        }
        
        
       
    }
    
    
    @IBAction func SignInButton(_ sender: Any) {
            
            
            
            signedIn = signInFunction()
            //signInModel.signUp()
            
            
        if Auth.auth().currentUser != nil {

             let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabsViewController") as! UITabBarController
             vc.modalPresentationStyle = .fullScreen
             self.present(vc, animated: true, completion: nil)
             
        }
            
        
    }
    
    func signInFunction()  -> Bool {
        
        let signedInVar = signInModel.signIn(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        //signInModel.signUp()
        
        return signedInVar
    }
    


}

