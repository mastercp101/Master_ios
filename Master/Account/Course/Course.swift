//
//  CourseClass.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

struct Course : Codable{
    let courseID : Int
    let userID : String
    let courseDate : String
    let courseApplyDeadLine : String
    let coursePeopleNumber : Int
    let courseImageID : Int
    let courseStatusID : Int
    let courseCategoryID : Int
//    let professionID : Int
    let courseName : String
    let courseContent : String
    let coursePrice : Int
    let courseNeed : String
    let courseQualification : String
    let courseLocation : String
    let courseNote : String
    
    enum CodingKeys : String,CodingKey {
        case courseID = "course_id"//
        case userID = "user_id"//
        case courseDate = "course_date"//
        case courseApplyDeadLine = "course_apply_deadline"//
        case coursePeopleNumber = "course_people_number"//
        case courseImageID = "course_image_id"//
        case courseStatusID = "course_status_id"//
        case courseCategoryID = "course_category_id"//
//        case professionID = "profession_id"
        case courseName = "course_name"//
        case courseContent = "course_content"//
        case coursePrice = "course_price"//
        case courseNeed = "course_need"//
        case courseQualification = "course_qualification"//
        case courseLocation = "course_location"//
        case courseNote = "course_note"//
    }
//    this.course_id = course_id;
//    this.user_id = user_id;
//    this.course_category_id = course_category_id;
//    this.course_status_id = course_status_id;
//    this.course_name = course_name;
//    this.course_date = course_date;
//    this.course_content = course_content;
//    this.course_price = course_price;
//    this.course_need = course_need;
//    this.course_qualification = course_qualification;
//    this.course_location = course_location;
//    this.course_apply_deadline = course_apply_deadline;
//    this.course_people_number = course_people_number;
//    this.course_image_id = course_image_id;
//    this.course_note = course_note;

    
}

struct CourseDetail : Codable{
    let courseCategoryID : Int
    let professionID : Int
    let courseName : String
    let courseContent : String
    let coursePrice : Int
    let courseNeed : String
    let courseQualification : String
    let courseLocation : String
    let courseNote : String
    
    
    enum CodingKeys : String,CodingKey {
        case courseCategoryID = "course_category_id"
        case professionID = "profession_id"
        case courseName = "course_name"
        case courseContent = "course_content"
        case coursePrice = "course_price"
        case courseNeed = "course_need"
        case courseQualification = "course_qualification"
        case courseLocation = "course_location"
        case courseNote = "course_note"
    }
    
}

struct CourseProfile : Codable{
    let courseID : Int
    let userID : String
    let courseDate : String
    let courseApplyDeadLine : String
    let coursePeopleNumber : Int
    let courseImageID : Int
    let courseStatusID : Int
    let courseCategoryID : Int
    
    enum CodingKeys : String,CodingKey {
        case courseID = "course_id"
        case userID = "user_id"
        case courseDate = "course_date"
        case courseApplyDeadLine = "course_apply_deadline"
        case coursePeopleNumber = "course_people_number"
        case courseImageID = "course_image_id"
        case courseStatusID = "course_status_id"
        case courseCategoryID = "course_category_id"
    }
}

struct Photo{
    let imageID : Int
    let image : UIImage
}


