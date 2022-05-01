//
//  File.swift
//  
//
//  Created by Kirill Titov on 17.01.2022.
//

import Foundation

struct UserDTO {
	
	var id: UUID?
	
	var reviews: [ReviewDTO]
	
	var fio: String?

	var email: String
	
	var passwordHash: String
	
	var userRights: UserRights?
	
	init() {
		self.id = UUID()
		self.reviews = []
		self.fio = "string"
		self.email = "string"
		self.passwordHash = "string"
		self.userRights = .everyone
	}
}
