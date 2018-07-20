//
//  CourseClass.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import Foundation

struct Course{
    let courseID : Int?
    let userID : String?
    let courseDate : Date?
    let courseApplyDeadLine : Date?
    let coursePeopleNumber : Int?
    let courseImageID : Int?
    let courseStatusID : Int?
    let courseCategoryID : Int?
    let professionID : Int?
    let courseName : String?
    let courseContent : String?
    let coursePrice : Int?
    let courseQualification : String?
    let courseLocation : String?
    let courseNote : String?
}

struct CourseDetail {
    let courseCategoryID : Int
    let professionID : Int
    let courseName : String
    let courseContent : String
    let coursePrice : Int
    let courseQualification : String
    let courseLocation : String
    let courseNote : String
}

struct CourseProfile {
    let courseID : Int
    let userID : String
    let courseDate : Date
    let courseApplyDeadLine : Date
    let coursePeopleNumber : Int
    let courseImageID : Int
    let courseStatusID : Int
    let courseCategoryID : Int
}


