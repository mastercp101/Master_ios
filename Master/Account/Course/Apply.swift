//
//  Apply.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/18.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import Foundation

// Find Apply by user name
struct FindByUserNameApply{
    let courseName : String
    let courseDate : Date
    let courseStatusName : String
}

// Find Apply By Course
struct FindByCourseApply{
    let courseID : Int
    let applyID : Int
    let userName : String
    let applyStatusName : String
    let applyDate : Date
}

// ApplyInsert
struct InsertApply{
    let applyID : Int
    let courseID : Int
    let userID : Int
    let applyStatusID : Int
    let applyTime : Date
}
