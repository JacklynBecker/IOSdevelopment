//
//  sign_in_model.swift
//  AspireApp
//
//  Created by Jacky Becker on 2024-12-01.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class Sign_In_Model{
    
    //only used to create test account, other accounts must be made through developer
    func signUp(){
        let email = "becker9912@gmail.com"
        let password = "testapp"
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
          if let error = error as? NSError {
              switch AuthErrorCode(AuthErrorCode.Code(rawValue: error.code) ?? AuthErrorCode.operationNotAllowed) {
            case AuthErrorCode.operationNotAllowed:
              // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                print("Operation Illegal")
            case AuthErrorCode.emailAlreadyInUse:
              // Error: The email address is already in use by another account.
                print("Email already in use")
            case AuthErrorCode.invalidEmail:
              // Error: The email address is badly formatted.
                print("Email already is badly formatted")
            case AuthErrorCode.weakPassword:
              // Error: The password must be 6 characters long or more.
                print("Password needs to be atleast 6 characters or more")
            default:
                print("Error: \(error.localizedDescription)")
            }
          } else {
            print("User signs up successfully")

          }
        }
    }
    
    //sign in with firebase authentication 
    func signIn(email: String, password: String) -> Bool{
        
        var validSignIn = false
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
          if let error = error as? NSError {
              switch AuthErrorCode(AuthErrorCode.Code(rawValue: error.code) ?? AuthErrorCode.operationNotAllowed) {
            case AuthErrorCode.operationNotAllowed:
              // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
                print("Authentication not enabled")
            case AuthErrorCode.userDisabled:
              // Error: The user account has been disabled by an administrator.
                print("The user account has been disabled by an administrator.")
            case AuthErrorCode.wrongPassword:
              // Error: The password is invalid or the user does not have a password.
                print("Password invalid.")
            case AuthErrorCode.invalidEmail:
              // Error: Indicates the email address is malformed.
                print("Email invalid.")
            default:
                print("Error: \(error.localizedDescription)")
            }
          } else {
              
            print("User signs in successfully")
            validSignIn = true

          }
        }
        
        return validSignIn
    }


}
