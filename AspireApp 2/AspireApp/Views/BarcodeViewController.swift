//
//  BarcodeViewController.swift
//  AspireApp
//
//  Created by Jacky Becker on 2024-12-03.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class BarcodeViewController: UIViewController {
    
    
    @IBOutlet weak var NameBarcodeLabel: UILabel!
    
    
    @IBOutlet weak var BarcodeImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NameBarcodeLabel.text = ""
        getData()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func SignOutButton(_ sender: Any) {
        
        do {
          try Auth.auth().signOut()
        } catch {
          print("Sign out error")
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! UIViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func getData(){
        Task {
          do {
              
              let db  = Firestore.firestore()
              let userUID = Auth.auth().currentUser?.uid
              var name = ""
              
            let documentSnapshot = try await db.collection("users").document(userUID!).getDocument()
            if let data = documentSnapshot.data() {
                name = data["name"] as! String
                BarcodeImage.image = generateBarcode(from: name)
                NameBarcodeLabel.text = name
                
            }
          }
          catch {
            print(error.localizedDescription)
          }
        }
    }
    
    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    

    


}
