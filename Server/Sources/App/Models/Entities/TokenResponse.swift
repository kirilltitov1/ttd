//
//  File.swift
//  
//
//  Created by Kirill Titov on 13.01.2022.
//

import Foundation

struct TokenResponse: Codable {
	var access_token: String
	var refresh_token: String
}
