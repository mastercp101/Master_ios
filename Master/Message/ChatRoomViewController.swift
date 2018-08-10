//
//  ChatRoomViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/8/2.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatRoomViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageInputView: UIView!
    @IBOutlet weak var inputMessageTextField: UITextField!
    
    var isBottom = false
    var ref : DatabaseReference!
    var chatItems = [ChatItem]()
    var bottomConstraint : NSLayoutConstraint?
    var chatRoom : ChatRoom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        setBackBtn()
        ref = Database.database().reference()
        setTableView()
        ChatItemSingleTon.shared.cellContentViewWidth = UIScreen.main.bounds.width
        downloadMessage()
        setKeyboardHandler()
        setConstraint()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tableView.addGestureRecognizer(gesture)
    }
    
    @objc
    private func endEditing(){
        inputMessageTextField.endEditing(true)
    }
    
    private func setBackBtn(){
        let backBtn = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(backBtnTapped))
        self.navigationItem.leftBarButtonItem = backBtn
    }
    
    @objc
    private func backBtnTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = chatRoom!.roomName
    }
    
    private func setConstraint(){
        bottomConstraint = NSLayoutConstraint(item: messageInputView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(bottomConstraint!)
    }
    
    private func setKeyboardHandler(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func downloadMessage(){
        guard let position = chatRoom?.roomPosition else {
            return
        }
        ref.child(position).observe(.value) { (snapshot) in
            self.chatItems = [ChatItem]()
            for chatItem in snapshot.children.allObjects as! [DataSnapshot]{
                self.isBottom = false
                let chatItemObject = chatItem.value as! [String : Any]
                let message = chatItemObject["msg"] as! String
                let name = chatItemObject["name"] as! String
                let newChatItem = ChatItem(userID: name, message: message)
                self.chatItems.append(newChatItem)
            }
            self.tableView.reloadData()
        }
    }
    
    private func scrollBottomWithoutAnimation(){
        let indexPath = IndexPath(row: tableView.numberOfRows(inSection: 0) - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    private func scrollToBottom(){
        
        guard self.chatItems.count > 0 else{
            return
        }
        
        let indexPath = IndexPath(row: self.chatItems.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @objc
    private func handleKeyboardNotification(notification : Notification){
        guard let userInfo = notification.userInfo else{
            return
        }
        let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
        
        let isKeyboardShowing = notification.name == .UIKeyboardWillShow
        bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
        
        if !isKeyboardShowing{
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                self.scrollToBottom()
            }
        }
    }
    
    
    // MARK: - send Btn Tapped
    @IBAction func sendBtnTapped(_ sender: Any) {
        guard let message = inputMessageTextField.text else{
            return
        }
        let request : [String : Any] = ["msg":message,"name":userAccount!]
        ref.child(chatRoom!.roomPosition).childByAutoId().setValue(request)
        inputMessageTextField.text = nil
        
        updateLastessage(message: message, userID: userAccount!, roomName: chatRoom!.roomName)
        updateLastessage(message: message, userID: chatRoom!.friendUserID, roomName: userName!)
    }
    
    
    private func updateLastessage(message : String, userID : String, roomName : String){
        let urlStr = urlString + "chatRoomServlet"
        let request : [String : Any] = ["action":"updateLastMessage","last_message":message,"user_id":userID,"room_name":roomName]
        Task.postRequestData(urlString: urlStr, request: request) { (error, data) in
            if let error = error{
                assertionFailure("Error : \(error)")
                return
            }
        }
    }
    
    private func setTableView(){
        tableView.register(messageCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 95
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }
    
}

extension ChatRoomViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! messageCell
        let chatItem = self.chatItems[indexPath.row]
        cell.selectionStyle = .none
        cell.messageBubbleView.messageLabel?.text = chatItem.message
        cell.messageBubbleView.setBubbleViewFrame(chatItem: chatItem)
        cell.setImage(chatItem: chatItem)
        cell.setNameLabel(chatItem: chatItem)
        handleScrollToBottom(indexPath: indexPath)
        return cell
    }
    
    private func handleScrollToBottom(indexPath : IndexPath){
        if indexPath.row != chatItems.count - 1 && !isBottom{
            let index = IndexPath(item: chatItems.count - 1, section: 0)
            self.tableView.scrollToRow(at: index, at: .bottom, animated: false)
        }else{
            self.isBottom = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputMessageTextField.endEditing(true)
    }
}

