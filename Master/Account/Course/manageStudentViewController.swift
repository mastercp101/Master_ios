//
//  manageStudentViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/16.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class manageStudentViewController: UIViewController {
    
    @IBOutlet weak var manageStudentTableView: UITableView!
    @IBOutlet weak var totalPeopleCount: UILabel!

    var applyList = [FindByCourseApply]()
    var urlStr = urlString + "applyServlet"
    var courseID = 0
    
    override func viewDidLoad() {
        self.title = "學生管理"
        super.viewDidLoad()
        manageStudentTableView.setCellAutoRowHeight()
        if applyList.count > 0{
           totalPeopleCount.text = "總共 \(applyList.count) 人"
        }
    }
    
    private func downloadApply(){
        let request : [String : Any] = ["action":"findByCourseId","course_id":courseID]
        Task.postRequestData(urlString: urlStr, request: request) { (error, data) in
            if let error = error {
                assertionFailure("Error : \(error)")
                return
            }
            guard let data = data else{
                assertionFailure("Invalid Data")
                return
            }

            do{
                let applyList = try decoder.decode([FindByCourseApply].self, from: data)
                self.applyList = applyList
                self.manageStudentTableView.reloadData()

            }catch{
                assertionFailure("Error : \(error)")
            }
        }
    }
    
    private func updateApply(status : Int,applyID : Int){
        guard urlStr.count > 0 else{
            return
        }
        let request : [String : Any] = ["action":"update","status":status,"apply_id":applyID]
        Task.postRequestData(urlString: urlStr, request: request) { (error, data) in
            if let error = error{
                assertionFailure("Error : \(error)")
                return
            }
            guard let data = data else{
                assertionFailure("updata apply Fail")
                return
            }
            
            guard let resultStr = String(data: data, encoding: .utf8),
                let result = Int(resultStr)else{
                assertionFailure("Invalid Data")
                return
            }
            self.handleUpdateApplyResult(isUpdateApplySuccess: result > 0)
        }
    }
    
    private func handleUpdateApplyResult(isUpdateApplySuccess : Bool){
        if isUpdateApplySuccess{
            downloadApply()
        }else{
            Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "更改報名狀態失敗") { (action) in}
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension manageStudentViewController : UITableViewDelegate ,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! manageStudentTableViewCell
        cell.studentImageView.setRoundImage()
        
        let apply = applyList[indexPath.row]
        cell.studentImageView.getUserPortrait(account: apply.userName, index: nil)
        cell.applyStatus.text = apply.applyStatusName
        cell.studentName.text = apply.userName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let apply = applyList[indexPath.row]
        Alert.shared.buildTripleAlert(viewController: self, alertTitla: nil, actionTitles: ["尚未繳費","報名成功","取消"], useCancelAction: false, firstAction: { (firstAction) in
            //尚未繳費
            self.updateApply(status: 2, applyID: apply.applyID)
        }, secondAction: { (secondAction) in
            //報名成功
            self.updateApply(status: 3, applyID: apply.applyID)
        }) { (cancelAction) in}
    }
    
}
