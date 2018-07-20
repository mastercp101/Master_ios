//
//  singleCourseViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class singleCourseViewController: UIViewController {
    
    @IBOutlet weak var singleCourseTableView: UITableView!
    var dogName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        singleCourseTableView.setCellAutoRowHeight()
    }
    
    @IBAction func manageBtnTapped(_ sender: Any) {
        Alert.shared.buildTripleAlert(viewController: self,
                                       alertTitla: nil,
                                       actionTitles: ["管理學生","管理課程","刪除課程"],
                                       firstAction: { (firstAction) in
            // Manage Student
             let nextVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "manageStudentVC") as? manageStudentViewController
            let navigation = UINavigationController(rootViewController: nextVC!)
            self.present(navigation, animated: true, completion: nil)
            self.presentVC()
            
        }, secondAction: { (secondAction) in
            
            // Manage Course
            self.presentVC()
            
        }) { (thirdAction) in
            // Delete Course Alert
            Alert.shared.buildDoubleAlert(viewController: self,alertTitle: "確定要刪除這個課程？",alertMessage: nil,actionTitles: ["確定","取消"],firstHandler: { (firstAction) in
                // Delete Course
            }, secondHandler: { _ in
                return
            })
        }
    }
    
    private func presentVC(){
        //..
    }
    
}
extension singleCourseViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as? courseMainCell
            cell?.mainImageView.image = UIImage(named: dogName)
            cell?.applyBtn.setBorder()
            cell?.contectBtn.setBorder()
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as? courseInfoCell
            var title = ""
            var content = ""
            switch indexPath.row{
            case 1 :
                title = "內容"
                content = ""
                break
            case 2 :
                title = "地點"
                content = ""
                break
            case 3 :
                title = "課程需求"
                content = ""
                break
            case 4 :
                title = "招生人數"
                content = ""
                break
            case 5 :
                title = "參加資格"
                content = ""
                break
            case 6 :
                title = "注意事項"
                content = ""
                break
            default:
                break
            }
            cell?.courseInfoTitle.text = title
            cell?.courseInfoContent.text = content
            return cell!
        }
    }
}
