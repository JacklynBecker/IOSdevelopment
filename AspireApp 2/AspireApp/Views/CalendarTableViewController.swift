//
//  CalendarTableViewController.swift
//  AspireApp
//
//  Created by Jacky Becker on 2024-12-07.
//

import UIKit
import EventKit

class CalendarTableViewController: UITableViewController {
    
    var titles : [String] = []
    var startDates : [String] = []
    var timeDate : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
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
            self.tableView.reloadData()
    }
    
    func readEvents() {


        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)

        for calendar in calendars {
            if calendar.title == "Aspire" {
                let oneMonthAfter = Date(timeIntervalSinceNow: +30*24*3600)

                let predicate = eventStore.predicateForEvents(withStart: .now, end: oneMonthAfter, calendars: [calendar])

                let events = eventStore.events(matching: predicate)

                for event in events {

                    if event.notes != "NEWS" {
                        let formatter3 = DateFormatter()
                        let formatter4 = DateFormatter()
                        formatter3.dateFormat = "d MMM"
                        formatter4.dateFormat = "HH:mm"
                        //print(event.startDate.)
                        titles.append(event.title)
                        startDates.append(formatter3.string(from: event.startDate))
                        let time = "\(formatter4.string(from: event.startDate)) - \(formatter4.string(from: event.endDate))"
                        timeDate.append(time)
                    }

                }

            }
        }


    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CalendarTableViewCell

        // Configure the cell...
        cell.dateLabel.text = startDates[indexPath.row]
        cell.eventLabel.text = titles[indexPath.row]
        cell.timeLabel.text = timeDate[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Calendar Events"
        }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
