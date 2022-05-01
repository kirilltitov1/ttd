//
//  File.swift
//  
//
//  Created by Kirill Titov on 16.01.2022.
//

import Foundation
import Vapor

struct UserReg: Codable, Content {
	let email: String
	let password: String
}
