//
//  MessageViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/9.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet weak var messageTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        messageTableView.removeFromSuperview()
        messageTableView.setCellAutoRowHeight()
    }
}

extension MessageViewController :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? messageRoomItemCell
        cell?.userPropertyImageView.setRoundImage()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "chatRoomVC") as? ChatRoomViewController else{
            assertionFailure("Invalid ViewController")
            return
        }
        let navigation = UINavigationController(rootViewController: nextVC)
        DispatchQueue.main.async {
            self.showDetailViewController(navigation, sender: nil)
        }
        
    }
    
   
    
    
}
