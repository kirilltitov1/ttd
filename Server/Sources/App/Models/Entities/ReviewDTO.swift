//
//  File.swift
//  
//
//  Created by Kirill Titov on 17.01.2022.
//

import Foundation

struct ReviewDTO {
	
	let id: UUID
	let user: UserDTO
	let film_id: UUID
	let text: String
	
	init() {
		self.id = UUID()
		self.user = UserDTO()
		self.film_id = UUID()
		self.text = "string"
	}
}
