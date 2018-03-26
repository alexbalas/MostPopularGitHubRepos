//
//  Repo.swift
//  Most Popular GitHub Repos
//
//  Created by Alex Balas on 3/16/18.
//  Copyright © 2018 Alex Balas. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

class Repo {
    var id: String?
    var name: String?
    var description: String?
    var ownerLogin: String?
    var url: String?
    
    required init(json: JSON) {
        self.description = json["description"].string
        self.id = json["id"].string
        self.name = json["name"].string
        self.ownerLogin = json["owner"]["login"].string
        self.url = json["url"].string
        getMyRepos { (repos, errors) in
            
        }
    }
    
    func getMyRepos(completionHandler: (Array<Repo>?, NSError?) -> Void)
    {
        let path = "https://api.github.com/user/repos"
        
        
        Alamofire.request(path).response { (response) in
            debugPrint(response)
            
            print("ZZZZZZZ")
            print(response.data!)
            
        }
    }
}

