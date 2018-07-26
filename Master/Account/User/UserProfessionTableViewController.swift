//
//  UserProfessionTableViewController.swift
//  Master
//
//  Created by Diego on 2018/7/25.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

// ProfessionCategory
// ProfessionItem

import UIKit

private let professionCell = "ProfessionCell"
private let workingIndex = 4

class UserProfessionTableViewController: UITableViewController {
    
    private var professions = [String]()
    private var isUpdate = false
    
    var selectNewProfessionItem: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard userAccess == .coach, UserData.shared.info.count == 6  else { return }
        professions = UserData.shared.info[workingIndex]
        if professions.count == 1, professions.first == NOT_EDIT_TEXT { professions.removeAll() }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return professions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: professionCell, for: indexPath)
        cell.textLabel?.text = professions[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        guard let account = userAccount else { return }
        // 同步 DB
        deleteProfession(account: account, profession: professions[indexPath.row])
        // 同步 common userProfessions
        userProfessions = userProfessions.filter({ (profession) -> Bool in
            profession.professionName != professions[indexPath.row]
        })
        // 同步 self tableView
        professions.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        
//        guard !tableView.isEditing else {
//            tableView.setEditing(false, animated: true)
//            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(newProfession(_:)))
//            return
//        }
        
        returnUserInfo()
        self.dismiss(animated: true) {
            guard self.isUpdate else { return }
            self.isUpdate = false
            if let account = userAccount { self.updateCommonProfession(account: account) }
        }
    }
    
    @IBAction func newProfession(_ sender: UIBarButtonItem) {

        guard tableView.isEditing else {
            tableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newProfession(_:)))
            return
        }
        if let controller = storyboard?.instantiateViewController(withIdentifier: "PfsCategoryVC") {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func returnUserInfo() {
        UserData.shared.info.remove(at: workingIndex)
        if professions.count == 0 { professions.append(NOT_EDIT_TEXT) }
        UserData.shared.info.insert(professions, at: workingIndex)
        professions.removeAll()
    }
    
    @IBAction func newProfessionReturn(segue: UIStoryboardSegue) {
        
        // 拿到選擇的值
        guard let account = userAccount, let professionItem = selectNewProfessionItem else { return }
        // 判斷重複
        for profession in professions {
            guard professionItem != profession else {
                showBanAlert()
                return
            }
        }
        insertProfession(account: account, profession: professionItem)
        isUpdate = true
        professions.append(professionItem)
        let indexPath = IndexPath(row: professions.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func showBanAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "請勿重複選擇") { (action) in }
        }
    }
    
    
 // MAEK: - Connect DB Methods.
    
    private func deleteProfession(account: String, profession: String) {
        
        let request: [String: Any] = ["action": "deleteProfession",
                                      "account": account,
                                      "profession": profession]
        
        Task.postRequestData(urlString: urlString + urlUserInfo, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            
            let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let result = results , let deleteResult = result as? Int else { return }
            
            if deleteResult <= 0 {
                Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "刪除時發生錯誤，請聯絡管理員", handler: { (action) in return })
            }
        }
    }
    
    private func updateCommonProfession(account: String) {
        
        let request: [String: Any] = ["action": "findProfessionById", "user_id": account]
        
        Task.postRequestData(urlString: urlString + urlUserInfo, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            let decoder = JSONDecoder()
            let results = try? decoder.decode([Profession].self, from: data)
            guard let result = results else { return }
            if result.count > 0 { userProfessions = result }
        }
    }
    
    private func insertProfession(account: String, profession: String) {
        
        let request: [String: Any] = ["action": "updataUserProfession",
                                      "account": account,
                                      "profession": profession]
        
        Task.postRequestData(urlString: urlString + urlUserInfo, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            
            let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let result = results , let insertResult = result as? Int else { return }
            
            if insertResult <= 0 {
                Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "新增時發生錯誤，請聯絡管理員", handler: { (action) in return })
            }
        }
        
    }
    
}
