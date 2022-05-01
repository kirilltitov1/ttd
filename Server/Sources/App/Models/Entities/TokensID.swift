//
//  File.swift
//  
//
//  Created by Kirill Titov on 16.01.2022.
//

import Foundation
import Vapor

struct TokensID: Content {
	var user_id: UUID?
	var access_token: String
	var refresh_token: String
}
