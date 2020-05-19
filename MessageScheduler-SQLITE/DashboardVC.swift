//
//  DashboardVC.swift
//  MessageScheduler-SQLITE
//
//  Created by Berkant Beğdilili on 18.05.2020.
//  Copyright © 2020 Berkant Beğdilili. All rights reserved.
//

import UIKit
import UserNotifications

class DashboardVC: UIViewController {

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var list = [Scheduler]()
    var searchText:String?
    var didSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        
        setupDB()
        setupTV()
        
    }

    override func viewWillAppear(_ animated: Bool) {

        if didSearch{
            list = DAO().search(searchText: searchText!)
        }else{
            selectedSegmentIndex()
        }
        
        tableView.reloadData()
    }
    

    @IBAction func createNew(_ sender: Any) {
        performSegue(withIdentifier: "toCreateOrEdit", sender: nil)
    }
    
   
    @IBAction func indexChanged(_ sender: Any) {
        selectedSegmentIndex()
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let VC = segue.destination as! CreateOrEditVC
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if sender != nil{
            let index = sender as! Int
            
            VC.edit = true
            VC.sch = self.list[index]
        }else{
            VC.edit = false
        }
    }
    
    func setupTV(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TVCell.self, forCellReuseIdentifier: "TVCell")
        searchBar.delegate = self
    }
    
    func setupDB(){
        let bundle = Bundle.main.path(forResource: "scheduler", ofType: ".sqlite")
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let fileManager = FileManager.default
        
        let copy = URL(fileURLWithPath: path).appendingPathComponent("scheduler.sqlite")
        
        if fileManager.fileExists(atPath: copy.path){
            
        }else {
            do {
                try fileManager.copyItem(atPath: bundle!, toPath: copy.path)
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
    
    func selectedSegmentIndex(){
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                list = DAO().scheduledMessage()
            case 1:
                list = DAO().sentMessage()
            default:
                break
        }
    }
}


extension DashboardVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVCell", for: indexPath) as! TVCell
        
        let cellList = list[indexPath.row]
        
        cell.phoneNo.text = "Phone No : \(cellList.sch_num!)"
        cell.message.text = "Message  : \(cellList.sch_message!)"
        cell.date.text    = "Time          : \(cellList.sch_date!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "DELETE"){ (contextualAction, view, boolValue) in
            
            let cellDelete = self.list[indexPath.row]
            
            // Veritabanından Silme
            DAO().deleteScheduler(sch_id: cellDelete.sch_id!)
            
            
            if self.didSearch{
                self.list = DAO().search(searchText: self.searchText!)
            }else {
                self.selectedSegmentIndex()
            }
            
            tableView.reloadData()
        }
        
        let edit = UIContextualAction(style: .normal, title: "EDIT"){ (contextualAction , view, boolValue) in
            
            self.performSegue(withIdentifier: "toCreateOrEdit", sender: indexPath.row)
            
        }
        
        return UISwipeActionsConfiguration.init(actions: [delete,edit])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension DashboardVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        
        if searchText == "" {
            didSearch = false
            segmentedControl.isHidden = false
            selectedSegmentIndex()
            
        }else {
            didSearch = true
            segmentedControl.isHidden = true
            list = DAO().search(searchText: self.searchText!)
        }
        
        tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension DashboardVC: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    
}

