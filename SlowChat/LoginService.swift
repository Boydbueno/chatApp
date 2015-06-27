//
//  LoginService.swift
//  SlowChat
//
//  Created by Nigelbueno on 26-06-15.
//  Copyright (c) 2015 boydbueno. All rights reserved.
//

import Foundation
import SwiftHTTP

class LoginService {
    
    func login(username: String, password: String, successCallback: () -> Void, errorCallback: () -> Void) -> Void {
        var request = HTTPTask()
        //we have to add the explicit type, else the wrong type is inferred. See the vluxe.io article for more info.
        let params: Dictionary<String,AnyObject> = ["username": username, "password": password]
        request.POST("http://178.62.135.117/login", parameters: params, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                errorCallback()
            }
            else if let data: AnyObject = response.responseObject{
                successCallback()
            }
        })
    }
    
}