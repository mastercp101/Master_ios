//
//  Profession.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/23.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import Foundation

struct Profession : Codable{
    let professionID : Int
    let professionName : String
    
    enum CodingKeys : String,CodingKey{
        case professionID = "profession_id"
        case professionName = "profession_name"
    }
}
