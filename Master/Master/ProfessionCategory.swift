//
//  ProfessionCategory.swift
//  Master
//
//  Created by Che-wei LIU on 2018/7/25.
//  Copyright © 2018 黎峻亦. All rights reserved.
//

import Foundation

struct ProfessionCategory: Codable {
    
    let professionCategory: String
    let professionItems: [String]
    
    enum CodingKeys : String,CodingKey{
        case professionCategory = "profession_category"
        case professionItems = "profession_item"
    }
}
