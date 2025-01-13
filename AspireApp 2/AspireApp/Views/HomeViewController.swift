//
//  HomeViewController.swift
//  AspireApp
//
//  Created by Jacky Becker on 2024-12-03.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import EventKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    var titles : [String] = []
    var URLs : [URL] = []
    var Images : [UIImage] = []
    

    
    @IBOutlet weak var TextViewWaiver: UITextView!
    
    @IBOutlet weak var visitorPassLabel: UILabel!
    
    
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        visitorPassLabel.text = ""
        getData()
        
        let eventStore = EKEventStore()

        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
                readEvents()
        case .denied:
                print("Access denied")
        case .notDetermined:

            eventStore.requestAccess(to: .event, completion: { (granted: Bool, NSError) -> Void in
                    if granted {
                        self.readEvents()

                    }else{
                        print("Access denied")
                    }



                })
            default:
                print("Case Default")
            }
        
        //self.tableView.reloadData()
        
    }
    
    func readEvents() {

        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)

        for calendar in calendars {
            if calendar.title == "Aspire" {
                let oneMonthAfter = Date(timeIntervalSinceNow: +30*24*3600)
                let oneMonthBefore = Date(timeIntervalSinceNow: -30*24*3600)

                let predicate = eventStore.predicateForEvents(withStart: oneMonthBefore, end: oneMonthAfter, calendars: [calendar])

                let events = eventStore.events(matching: predicate)

                for event in events {

                    if event.notes == "NEWS" {
                        let formatter3 = DateFormatter()
                        let formatter4 = DateFormatter()
                        formatter3.dateFormat = "d MMM"
                        formatter4.dateFormat = "HH:mm"
                        //print(event.startDate.)
                        titles.append(event.title)
                        //URLs.append(event.url!)
                        //UIImage(data: Data(contentsOf: url))
                        //let url = URL(string: <#T##String#>)
                        //Images.append(UIImage(data: Data(contentsOf: url)))
                        //startDates.append(formatter3.string(from: event.startDate))
                        //let time = "\(formatter4.string(from: event.startDate)) - \(formatter4.string(from: event.endDate))"
                        //timeDate.append(time)
                    }

                }

            }
        }


    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNews", for: indexPath) as! NewsTableViewCell
        
        cell.TitleLabel.text = titles[indexPath.row]
        //cell.LearnMore.text = URLs[indexPath.row].absoluteString
        return cell
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

                if (data["visitorPass"] as! Bool){
                    visitorPassLabel.text = "Yes"
                }
            }
          }
          catch {
            print(error.localizedDescription)
          }
        }
    }
   

}
