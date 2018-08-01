//
//  HighlightCourse.swift
//  Master
//
//  Created by Che-wei LIU on 2018/8/1.
//  Copyright © 2018 黎峻亦. All rights reserved.
//

import UIKit

struct HighlightCourse: Codable {
    let courseId: Int
    let professionId: Int
    let courseCategoryId: Int
    let coursePrice: Int
    let coursePeopleNumber: Int
    let courseImageId: Int
    let courseStatusId: Int
    
    enum CodingKeys: String,CodingKey {
        case courseId = "course_id"
        case professionId = "profession_id"
        case courseCategoryId = "course_category_id"
        case coursePrice = "course_price"
        case coursePeopleNumber = "course_people_number"
        case courseStatusId = "course_status_id"
        case courseImageId = "course_image_id"
    }
}


