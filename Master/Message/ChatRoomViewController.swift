//
//  ChatRoomViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/17.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController {

    @IBOutlet weak var chatRoomTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "123"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(backBtnTapped))
    }
    @objc
    func backBtnTapped(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChatRoomViewController :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fromOther", for: indexPath) as? messageFromOtherCell
        cell?.userPropertyImageView.setRoundImage()
        cell?.messageLabel.setLableMultipleLine()
        cell?.userNameLabel.text = "123"
        cell?.messageLabel.text = "1415512421314234141\n134141\n1revsdvsdz"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "fromOther") as? messageFromOtherCell {
            let messageHeight = cell.messageLabel.bounds.height
            let nameHeight = cell.userNameLabel.bounds.height
            let totalHeight = messageHeight + nameHeight
            return totalHeight + 50
        }else{
            return 10
        }
    }
}
