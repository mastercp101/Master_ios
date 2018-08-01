//
//  MasterTableViewCell.swift
//  Master
//
//  Created by Che-wei LIU on 2018/7/31.
//  Copyright © 2018 黎峻亦. All rights reserved.
//

import UIKit

class MasterTableViewCell: UITableViewCell {

    
    @IBOutlet weak var courseNameLabel: UILabel!
    
    @IBOutlet weak var starTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var numberOfJoinedLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
