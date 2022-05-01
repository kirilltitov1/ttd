//
//  File.swift
//  
//
//  Created by Kirill Titov on 07.05.2021.
//

import Foundation

struct UserRights: OptionSet, Codable  {
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    let rawValue: Int
    
    func encode(to encoder: Encoder) throws {
        try rawValue.encode(to: encoder)
    }
    
    init(from decoder: Decoder) throws {
        rawValue = try .init(from: decoder)
    }
    

    static let everyone: Self = []

    static let modUser = Self(rawValue: 1 << 1)
    
    static let mangaUpload = Self(rawValue: 1 << 2)

    static let superAdmin = Self(rawValue: 1 << 0)
}
