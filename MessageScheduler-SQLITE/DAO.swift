//
//  DAO.swift
//  MessageScheduler-SQLITE
//
//  Created by Berkant Beğdilili on 18.05.2020.
//  Copyright © 2020 Berkant Beğdilili. All rights reserved.
//

import Foundation

class DAO{
    
    let db:FMDatabase?
    let dateFormatter = DateFormatter()
    let date:String?
    
    init(){
        
        dateFormatter.dateFormat = "dd.MM"
        date = dateFormatter.string(from: Date())
        
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let url = URL(fileURLWithPath: path).appendingPathComponent("scheduler.sqlite")
        
        db = FMDatabase(url: url)
    }
    
    func scheduledMessage() -> [Scheduler]{
        
        var list = [Scheduler]()
        
        db?.open()
        
        do {
            let rs = try db!.executeQuery("SELECT * FROM scheduler WHERE sch_date>=\(date!)", values: nil)
            
            while rs.next(){
                let sch = Scheduler(sch_id: Int(rs.string(forColumn: "sch_id")!)!,
                                    sch_num: rs.string(forColumn: "sch_num")!,
                                    sch_message: rs.string(forColumn: "sch_message")!,
                                    sch_date: rs.string(forColumn: "sch_date")!)
                
                list.append(sch)
            }
        } catch  {
            print(error.localizedDescription)
        }
        
        db?.close()
        
        return list
        
    }
    
    func sentMessage() -> [Scheduler]{
        
        var list = [Scheduler]()
        
        db?.open()
        
        do {
            let rs = try db!.executeQuery("SELECT * FROM scheduler WHERE sch_date<\(date!)", values: nil)
            
            while rs.next(){
                let sch = Scheduler(sch_id: Int(rs.string(forColumn: "sch_id")!)!,
                                    sch_num: rs.string(forColumn: "sch_num")!,
                                    sch_message: rs.string(forColumn: "sch_message")!,
                                    sch_date: rs.string(forColumn: "sch_date")!)
                list.append(sch)
            }
        } catch  {
            print(error.localizedDescription)
        }
        
        db?.close()
        
        return list
    }
    
    func addScheduler(sch_num:String, sch_message:String, sch_date:String){
        
        db?.open()
        
        do {
            try db!.executeUpdate("INSERT INTO scheduler (sch_num,sch_message,sch_date) VALUES (?,?,?)", values: [sch_num,sch_message,sch_date])
        } catch  {
            print(error.localizedDescription)
        }
        
        db?.close()
        
    }
    
    func deleteScheduler(sch_id:Int){
        
        db?.open()
        
        do {
            try db!.executeUpdate("DELETE FROM scheduler WHERE sch_id = ?", values: [sch_id])
        } catch  {
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func updateScheduler(sch_id:Int ,sch_num:String, sch_message:String, sch_date:String){
        
        db?.open()
        
        do {
            try db!.executeUpdate("UPDATE scheduler SET sch_num = ? , sch_message = ? , sch_date = ? WHERE sch_id = ?", values: [sch_num,sch_message,sch_date,sch_id])
        } catch  {
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func search(searchText:String) -> [Scheduler]{
        
        var list = [Scheduler]()
        
        db?.open()
        
        do {
            let rs = try db!.executeQuery("SELECT * FROM scheduler WHERE sch_message LIKE '%\(searchText)%' OR sch_num LIKE '%\(searchText)%' OR sch_date LIKE '%\(searchText)%'", values: nil)
            
            while rs.next(){
                let sch = Scheduler(sch_id: Int(rs.string(forColumn: "sch_id")!)!,
                                    sch_num: rs.string(forColumn: "sch_num")!,
                                    sch_message: rs.string(forColumn: "sch_message")!,
                                    sch_date: rs.string(forColumn: "sch_date")!)
                
                list.append(sch)
            }
            
        } catch  {
            print(error.localizedDescription)
        }
        
        db?.close()
        
        return list
        
    }
    
    
}
