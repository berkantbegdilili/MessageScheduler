//
//  Scheduler.swift
//  MessageScheduler-SQLITE
//
//  Created by Berkant Beğdilili on 18.05.2020.
//  Copyright © 2020 Berkant Beğdilili. All rights reserved.
//

import Foundation

class Scheduler:Equatable{
    
    var sch_id:Int?
    var sch_num:String?
    var sch_message:String?
    var sch_date:String?
    
    init(){
    }
    
    init(sch_id:Int, sch_num:String, sch_message:String, sch_date:String){
        self.sch_id = sch_id
        self.sch_num = sch_num
        self.sch_message = sch_message
        self.sch_date = sch_date
    }
    
    static func == (lhs: Scheduler, rhs: Scheduler) -> Bool {
        return lhs.sch_id == rhs.sch_id
    }
    
}
