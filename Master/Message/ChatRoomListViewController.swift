//
//  ChatRoomListViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/9.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ChatRoomListViewController: UIViewController {
    
    var ref : DatabaseReference!
    var chatRoomList = [ChatRoom]()

    @IBOutlet weak var chatRoomListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        chatRoomListTableView.setCellAutoRowHeight()
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        downloadChatRoom()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        chatRoomList = [ChatRoom]()
        chatRoomListTableView.reloadData()
    }
    
    private func downloadChatRoom(){
        guard let userAccount = userAccount else{
            Common.shared.alertUserToLogin(viewController: self)
            return
        }
        
        let request : [String : Any] = ["action":"findRoomByUserId","user_id":userAccount]
        let urlStr = urlString + "chatRoomServlet"
        Task.postRequestData(urlString: urlStr, request: request) { (error, data) in
            if let error = error {
                assertionFailure("Error : \(error)")
                return
            }
            guard let data = data ,let chatRooms = try? decoder.decode([ChatRoom].self, from: data)else{
                assertionFailure("Invalid Data")
                return
            }
            self.chatRoomList = chatRooms
            self.chatRoomListTableView.reloadData()
        }
    }
}

extension ChatRoomListViewController :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! messageRoomItemCell
        cell.userProfileImageView.setRoundImage()
        cell.userProfileImageView.getUserPortrait(account: chatRoomList[indexPath.row].roomName, index: nil)
        cell.userNameLabel.text = chatRoomList[indexPath.row].roomName
        cell.lastMessageLabel.text = chatRoomList[indexPath.row].lastMessage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "chatRoomVC") as! ChatRoomViewController
        let cell = tableView.cellForRow(at: indexPath) as! messageRoomItemCell
        ChatItemSingleTon.shared.friendPortrait = cell.userProfileImageView.image
        nextVC.chatRoom = chatRoomList[indexPath.row]
        let navigation = UINavigationController(rootViewController: nextVC)
        self.present(navigation, animated: true, completion: nil)
    }
}
