//
//  Apply.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/18.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import Foundation

// Find Apply By Course
struct FindByCourseApply : Codable{
    let courseID : Int
    let applyID : Int
    let userName : String
    let applyStatusName : String
    let applyDate : String
    
    enum CodingKeys : String,CodingKey{
        case courseID = "course_id"
        case applyID = "apply_id"
        case userName = "user_name"
        case applyStatusName = "apply_status_name"
        case applyDate = "apply_time"
    }
}

// ApplyInsert
struct InsertApply : Codable{
    let applyID : Int
    let courseID : Int
    let userID : String
    let applyStatusID : Int
    let applyTime : String?
    
    enum CodingKeys : String,CodingKey{
        case applyID = "apply_id"
        case courseID = "course_id"
        case userID = "user_id"
        case applyStatusID = "apply_status_id"
        case applyTime = "apply_time"
    }
}
