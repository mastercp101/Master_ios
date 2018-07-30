//
//  CommentDialogViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/30.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class CommentDialogViewController: UIViewController {

    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentInputTextField: UITextField!
    
    var bottomConstraint : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGesture()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
        
        bottomConstraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: dialogView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        view.addConstraint(bottomConstraint!)
    }
    
    
    @objc
    private func handleKeyboardNotification(notification : Notification){
        guard let userInfo = notification.userInfo else{
            return
        }
        let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
        
        let isKeyboardShowing = notification.name == .UIKeyboardWillShow
        bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height + 35 : 0
        
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            //..
        }
    }
    
    
    private func setGesture(){
        self.commentTableView.isUserInteractionEnabled = true
        let tableVIewGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tableVIewGesture.cancelsTouchesInView = false
        self.commentTableView.addGestureRecognizer(tableVIewGesture)
    }
    
    @objc
    private func endEditing(){
        self.commentInputTextField.resignFirstResponder()
    }

    @IBAction func sendBtnTapped(_ sender: Any) {
        
    }
    @IBAction func doneBtnTapped(_ sender: Any) {
        endEditing()
        self.dismiss(animated: true)
    }
    
    
}

extension CommentDialogViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.commentInputTextField.resignFirstResponder()
    }
}

