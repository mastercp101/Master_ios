//
//  Task.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/12.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import Foundation

class Task{
    typealias DoneHandler = (Error?,Data?) -> Void
    static func postRequestData(urlString : String ,
                                request : [String : Any] ,
                                doneHandler : @escaping DoneHandler){
        
        guard let requestJson = try? JSONSerialization.data(withJSONObject: request)else{
            let error = NSError(domain: "Serialize JSON Fail", code: -1, userInfo: nil)
            doneHandler(error,nil)
            return
        }
        guard let url = URL(string: urlString) else{
            assertionFailure("convert urlString to URL fail")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestJson
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error{
                assertionFailure("\(error)")
                DispatchQueue.main.async {
                    doneHandler(error , nil)
                }
                return
            }
            guard let data = data else{
                let error = NSError(domain: "Invalid Data", code: -1, userInfo: nil)
                DispatchQueue.main.async {
                    doneHandler(error , nil)
                }
                return
            }
            DispatchQueue.main.async {
                doneHandler(nil,data)
            }
        }
        dataTask.resume()
    }
}
