//
//  PaymentViewController.swift
//  AspireApp
//
//  Created by Jacky Becker on 2024-12-03.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PaymentViewController: UIViewController {
    
    
    
    @IBOutlet weak var expirationLabel: UILabel!
    
    @IBOutlet weak var membershipLabel: UILabel!
    
    
    @IBOutlet weak var paymentDateLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    func getData(){
        Task {
          do {
              
              let db  = Firestore.firestore()
              let userUID = Auth.auth().currentUser?.uid
              
            let documentSnapshot = try await db.collection("users").document(userUID!).getDocument()
            if let data = documentSnapshot.data() {
                
                
                let stamp = data["purchaseDate"] as? Timestamp
                let date = stamp!.dateValue()
                
                let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
                
                var components = DateComponents()
                let formatter1 = DateFormatter()
                formatter1.dateStyle = .short
               
                let today = Date.now
                let todayCalendarDate = Calendar.current.dateComponents([.day, .year, .month], from: today)
                
                var daysValue = 0

                if (data["membership"] as! String == "monthly" && data["autoRenew"] as! Bool){
                    membershipLabel.text = "Monthly auto-renew"
                    components.month = calendarDate.month! + 1
                    components.day = calendarDate.day!
                    components.year = calendarDate.year!
                    let date = Calendar.current.date(from: components)
                    paymentDateLabel.text = formatter1.string(from: date!)
                    let diffInDays = Calendar.current.dateComponents([.day], from: todayCalendarDate, to: components).day
                    expirationLabel.text = String(diffInDays!) + " days"
                    
                }
                else if (data["membership"] as! String == "monthly"){
                    membershipLabel.text = "Monthly"
                    let diffInDays = Calendar.current.dateComponents([.day], from: todayCalendarDate, to: components).day
                    expirationLabel.text = String(diffInDays!) + " days"
                    paymentDateLabel.text = "None"
                }
                else if (data["membership"] as! String == "yearly" && data["autoRenew"] as! Bool){
                    membershipLabel.text = "Yearly auto-renew"
                    components.month = calendarDate.month!
                    components.day = calendarDate.day!
                    components.year = calendarDate.year! + 1
                    let date = Calendar.current.date(from: components)
                    paymentDateLabel.text = formatter1.string(from: date!)
                    let diffInDays = Calendar.current.dateComponents([.day], from: todayCalendarDate, to: components).day
                    expirationLabel.text = String(diffInDays!) + " days"
                    
                }
                else if (data["membership"] as! String == "yearly"){
                    membershipLabel.text = "Yearly"
                    paymentDateLabel.text = "None"
                    components.month = calendarDate.month!
                    components.day = calendarDate.day!
                    components.year = calendarDate.year! + 1
                    let diffInDays = Calendar.current.dateComponents([.day], from: todayCalendarDate, to: components).day
                    expirationLabel.text = String(diffInDays!) + " days"
                }
                else{
                    membershipLabel.text = "None"
                    paymentDateLabel.text = "None"
                    expirationLabel.text = "None"
                }
                
            
                
            }
          }
          catch {
            print(error.localizedDescription)
          }
        }
    }
    
    

}
