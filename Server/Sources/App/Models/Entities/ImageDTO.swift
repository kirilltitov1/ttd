//
//  File.swift
//  
//
//  Created by Kirill Titov on 30.01.2022.
//

import Foundation
import Vapor
import AppKit

struct ImageDTO: Codable, Content {
	var name: String
	var img: Data
	
	public init() throws {
		name = "image.jpg"
		img = try Data(contentsOf: URL(fileURLWithPath: "/Users/kirilltitov/Documents/BMSTU/6sem/course/course-project/src/Server/Public/img.jpg"))
	}
}
