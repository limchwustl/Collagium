//
//  artwork.swift
//  FinalProject
//
//  Created by James Crosby on 11/5/18.
//  Copyright © 2018 Chaehun Ben Lim. All rights reserved.
//

import Foundation
import UIKit
struct Artwork:Decodable {
    
//    static func == (lhs: artwork, rhs: artwork) -> Bool {
//        return true
//    }
    
    /*
        artwork contains the piece name, description, image, materials (that may need to be a
        seperate class type if we want to make them 'tags'), a count for likes/dislikes, and a
        dictionary that has stored comments by user.
    */
//    var hashValue: Int
    var course: String
    var artist: String
    var key: String
    var desc : String
//    var piece: UIImage!
    var title: String
    var dimension: String
    var date: String
    var material : String //This will probably change if we want this to be filterable
//    var likes: Int
//    var dislike: Int
    
    
//    var comments: [User : [String]]!
//
//    func getComments() -> [User : [String]] {
//        
//        if comments != nil {
//            return comments
//        }
//        else{
//            return [:]
//        }
//    }
}
