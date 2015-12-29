//
//  User.swift
//  XEEM
//
//  Created by Giao Tuan on 12/17/15.
//  Copyright © 2015 JadeLe. All rights reserved.
//

import Foundation

var _currentUser: User?
let USER_KEY = "CURRENT_USER"
let USER_TOKEN_KEY = "CURRENT_USER_TOKEN"

class User: NSObject {
    var id: String?
    var fullName: String?
    var username: String?
    var password: String?
    var token: String?
    var email: String?
    var address: String?
    var phone: String?
    var transList: [Transportation]?
    var avatarURL: NSURL?
    var dictionary : NSDictionary?
    var defaultVehicles : Transportation?
    
    init(dictionary : NSDictionary?) {
        if let dictionary = dictionary {
            self.dictionary = dictionary
            fullName = dictionary["name"] as? String
            id = dictionary["Id"] as? String
            fullName = dictionary["Name"] as? String
            email = dictionary["Email"] as? String
            password = dictionary["Password"] as? String
            address = dictionary["Address"] as? String
            phone = dictionary["Phone"] as? String
            avatarURL = NSURL(string: (dictionary["AvatarUrl"] as? String ?? "")!)
            transList = Transportation.TransWithArray(dictionary["Transporations"] as! [NSDictionary])
            defaultVehicles = transList![0] as Transportation?
        }
    }
    
    class var currentToken: String? {
        get{
            let data = NSUserDefaults.standardUserDefaults().objectForKey(USER_TOKEN_KEY) as? String
        
            return data
        }
        set(newToken){
            NSUserDefaults.standardUserDefaults().setObject(newToken, forKey: USER_TOKEN_KEY)
        }
    }
    // Save curent user
    class var currentUser: User? {
        get {
        if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(USER_KEY)
                if data != nil {
                    do {
                        let dict = try NSJSONSerialization.JSONObjectWithData(data! as! NSData, options: [])
                        _currentUser = User(dictionary: dict as! NSDictionary)
                    } catch {
                        print(error)
                        return _currentUser
                }
            }
        }
        return _currentUser
        }
        
        set (user) {
            _currentUser = user
            
            if _currentUser != nil {
                // save to NSDefault
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: [])
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: USER_KEY)
                } catch let error as NSError {
                    print(error)
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: USER_KEY)
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: USER_KEY)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

}