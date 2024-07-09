//
//  Post.swift
//  YearLongProject
//
//  Created by Derek Stengel on 7/2/24.
//

import Foundation

struct Post: Codable {
    var id: Int
    var user: String
    var date: String
    var handle: String
    var title: String
    var body: String
    var numberOfComments: String
    var numberOfLikes: String
}
