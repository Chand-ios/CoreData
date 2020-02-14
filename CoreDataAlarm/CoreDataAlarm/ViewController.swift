//
//  ViewController.swift
//  CoreDataAlarm
//
//  Created by eAlphaMac2 on 14/02/20.
//  Copyright © 2020 eAlphaMac2. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UNUserNotificationCenterDelegate  {
    @IBOutlet var tblView: UITableView!

     var timer = Timer()
    var Time:String = ""
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
        var context:NSManagedObjectContext!
        var items: [NSManagedObject] = []
        @IBOutlet var dptext: UITextField!
        let datePicker = UIDatePicker()

        override func viewDidLoad() {
            tblView.delegate = self
            tblView.dataSource = self
                 createDatePicker()
            timer  = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ViewController.testDate), userInfo: nil, repeats: true)
        }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        fetchData()
    }
    
  //TableView Delegate And Data Source
    
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return items.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
           cell.selectionStyle = .none
           let item = items[indexPath.row]
            print("item : ", item)
           print("item : ", (item.value(forKey: "time") as? String) ?? "")
           cell.textLabel?.text = item.value(forKey: "time") as? String
           cell.textLabel?.textColor = .darkGray
       
               
            
           
       
       return cell
       
       }
    
 //Creating Database,Save Data and Fetch data

        func openDatabse()
           {
               context = appDelegate.persistentContainer.viewContext
               let entity = NSEntityDescription.entity(forEntityName: "Dates", in: context)
               let newUser = NSManagedObject(entity: entity!, insertInto: context)
               saveData(UserDBObj:newUser)
           }
        func saveData(UserDBObj:NSManagedObject)
           {
            UserDBObj.setValue(Time, forKey: "time")
            

            print("Storing Data..")
            do {
                try context.save()
            } catch {
                print("Storing data Failed")
            }

            fetchData()
        }
        func fetchData()
        {

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
               let manageContent = appDelegate.persistentContainer.viewContext
               let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: "Dates")
               do {

                   let result = try manageContent.fetch(fetchData)
                   items = result as! [NSManagedObject]
                   tblView.reloadData()
               }catch {
                   print("err")
               }
        }
    
   //DataPicker Creation
        
        func createDatePicker() {
            datePicker.datePickerMode = .dateAndTime
        let toolbar = UIToolbar()
            toolbar.sizeToFit()

            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
            toolbar.setItems([doneButton], animated: false)

            dptext.inputAccessoryView = toolbar
            dptext.inputView = datePicker


        }
@objc func testDate() {
    if Calendar.current.isDate(datePicker.date, equalTo: Date(), toGranularity: .minute) {
        print("success")
        }
}
        @objc func donePressed() {

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            //let dateFormatter = DateFormatter()
                   dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"

            let convertedDate = dateFormatter.string(from: datePicker.date)

           Time = convertedDate
            openDatabse()
            self.view.endEditing(true)

              }
}
