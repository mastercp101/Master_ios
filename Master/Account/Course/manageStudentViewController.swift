//
//  manageStudentViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/16.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class manageStudentViewController: UIViewController {

    @IBOutlet weak var totalPeopleCount: UILabel!
    var courseID = 0
    var applyList = [FindByCourseApply]()
    @IBOutlet weak var manageStudentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageStudentTableView.setCellAutoRowHeight()
        downloadApply()
    }
    
    private func downloadApply(){
        let urlStr = urlString + "applyServlet"
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
                self.totalPeopleCount.text = "總共 \(applyList.count) 人"
            }catch{
                assertionFailure("Error : \(error)")
            }
            
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? manageStudentTableViewCell
        cell?.studentImageView.setRoundImage()
        
        let apply = applyList[indexPath.row]
        cell?.applyStatus.text = apply.applyStatusName
        cell?.studentName.text = apply.userName
        cell?.studentImageView.image = UIImage()
        return cell!
    }
}
