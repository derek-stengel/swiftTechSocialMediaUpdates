//
//  User.swift
//  YearLongProject
//
//  Created by Derek Stengel on 6/25/24.
//

import Foundation

struct User: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var userUUID: UUID
    var secret: UUID
    var userName: String
    
    static var current: User?
}
