//
//  ContectHandler.swift
//  Master
//
//  Created by 黎峻亦 on 2018/8/8.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ContectHandler{
    
    let chatSevlet = "chatRoomServlet"
    var ref : DatabaseReference!
    var myName = userName!
    var myID = userAccount!
    var friendUserID = ""
    var friendUserName = ""
    var position = ""
    var viewController = UIViewController()
    
    init(viewController : UIViewController,friendUserID : String , friendUserName : String) {
        self.friendUserID = friendUserID
        self.friendUserName = friendUserName
        self.viewController = viewController
        ref = Database.database().reference()
        //        self.isRoomExist()
    }
    
    func isRoomExist(){
        let urlStr = urlString + chatSevlet
        let request : [String : Any] = ["action":"checkChatRoom","user_id":myID,"friend_name":friendUserName]
        Task.postRequestData(urlString: urlStr, request: request) { (error, data) in
            if let error = error {
                assertionFailure("Error : \(error)")
                return
            }
            guard let data = data,
                let resultStr = String(data: data, encoding: .utf8),
                let result = Int(resultStr) else{
                    assertionFailure("Invalid Data")
                    return
            }
            // find room position
            if result > 0{
                self.findRoomPosition()
            }else{ // create chatRoom
                let position = self.createFireBaseChatRoom()
                self.position = position
                self.insertChatRommInDB(position: position)
            }
        }
    }
    
    private func findRoomPosition(){
        let urlStr = urlString + chatSevlet
        let request : [String : Any] = ["action":"findRoomPosition","user_id":myID,"friend_name":friendUserName]
        Task.postRequestData(urlString: urlStr, request: request) { (error, data) in
            if let error = error {
                assertionFailure("Error : \(error)")
                return
            }
            guard let data = data,
                let resultStr = String(data: data, encoding: .utf8) else{
                    assertionFailure("Invalid Data")
                    return
            }
            self.position = resultStr
            self.openChatRoom()
        }
    }
    
    private func createFireBaseChatRoom() -> String{
        let key = ref.childByAutoId().key
        let request : [String : Any] = [key:"空房間"]
        ref.updateChildValues(request)
        return key
    }
    
    private func insertChatRommInDB(position : String){
        let urlStr = urlString + chatSevlet
        let request : [String : Any] = ["action":"createChatRoom","chat_room_position":position]
        Task.postRequestData(urlString: urlStr, request: request) { (error, data) in
            if let error = error {
                assertionFailure("Error : \(error)")
                return
            }
            guard let data = data,
                let resultStr = String(data: data, encoding: .utf8),
                let result = Int(resultStr) else{
                    assertionFailure("Invalid Data")
                    return
            }
            self.connectUserToChatRoom( chatRoomID: result)
        }
    }
    
    private func connectUserToChatRoom(chatRoomID : Int){
        let urlStr = urlString + chatSevlet
        let request : [String : Any] = ["action":"connectUserToRoom","user_id":self.myID,"chat_room_id":chatRoomID,"room_name":friendUserName]
        Task.postRequestData(urlString: urlStr, request: request) { (error, data) in
            if let error = error {
                assertionFailure("Error : \(error)")
                return
            }
            self.connectFriendToChatRoom(chatRoomID: chatRoomID)
        }
    }
    
    private func connectFriendToChatRoom(chatRoomID : Int){
        let urlStr = urlString + chatSevlet
        let request : [String : Any] = ["action":"connectUserToRoom","user_id":self.friendUserID,"chat_room_id":chatRoomID,"room_name":userName!]
        Task.postRequestData(urlString: urlStr, request: request) { (error, data) in
            if let error = error {
                assertionFailure("Error : \(error)")
                return
            }
            self.openChatRoom()
        }
    }
    
    private func openChatRoom(){
        let chatRoom = ChatRoom(friendUserID: self.friendUserID, roomName: self.friendUserName, roomPosition: self.position, lastMessage: "")
        let nextVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "chatRoomVC") as! ChatRoomViewController
        nextVC.chatRoom = chatRoom
        let navigation = UINavigationController(rootViewController: nextVC)
        viewController.present(navigation, animated: true, completion: nil)
    }
    
    
}
