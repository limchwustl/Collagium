//
//  Student.swift
//  FinalProject
//
//  Created by James Crosby on 11/5/18.
//  Copyright © 2018 Chaehun Ben Lim. All rights reserved.
//

import Foundation
struct User:Decodable{
    
    //each user has a collection of artwork, a name, an email, and value indicating if they are
    //an instructor or not. Should be able to use email/instructor fields to add filter
//    var Portfolio : [artwork]
//    var hashValue: Int
    var name: String
    var email: String
    
    
//    func getPort() -> [artwork] {
//        if Portfolio != nil {
//            return Portfolio
//        }
//        else {
//            return []
//        }
//    }
}
