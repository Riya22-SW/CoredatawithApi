//
//  JokeModel.swift
//  CDwithAPI
//
//  Created by admin on 10/12/24.
//

import Foundation

struct JokeModel: Codable {
    let id: Int
    let type: String
    let setup: String
    let punchline: String
}
