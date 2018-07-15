//
//  UserTableViewController.swift
//  Master
//
//  Created by Diego on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

struct photo {
    
    let tset1:String
    let tset2:String
}

class UserTableViewController: UITableViewController {

    private let imageCell = "UserImageCell"
    private let nameCell = "UserNameCell"
    private let infoCell = "UserInfoCell"
    private let profileCell = "UserProfileCell"
    private let professionCell = "UserProfessionCell"
    
    let info = ["身份","性別","地址","電話"]
    let test = [[""],["阿不拉"],["教練","男","中壢市中央大學","03-422345"],["自我介紹自我介紹自我介紹自我介紹自自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹我介紹自我介自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹自我介紹紹"],["鋼琴","吉他","馬拉松","睡覺"]]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return test.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return test[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     
        
//        var cell = tableView.dequeueReusableCell(withIdentifier: test, for: indexPath) as! UserImageCell
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: imageCell, for: indexPath) as! UserImageCell
            cell.userPortraitImageView.image = UIImage(named:"user_image")
            cell.userBackgroundImageView.image = UIImage(named:"user_back")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: nameCell, for: indexPath) as! UserNameCell
            cell.userNameLabel.text = test[indexPath.section][indexPath.row]
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCell, for: indexPath) as! UserInfoCell
            cell.userInfoDetail.text = test[indexPath.section][indexPath.row]
            cell.userInfoTitle.text = info[indexPath.row]
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: profileCell, for: indexPath) as! UserProfileCell
            cell.userProfileLabel.text = test[indexPath.section][indexPath.row]
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: professionCell, for: indexPath) as! UserProfessionCell
            cell.userProfessionLabel.text = test[indexPath.section][indexPath.row]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "nope", for: indexPath)
            return cell
        }
    }
 
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let title: String?
        switch section {
        case 2:
            title = "會員資訊"
        case 3:
            title = "個人簡介"
        case 4:
            title = "專業技能"
        default:
            title = nil
        }
        return title
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
