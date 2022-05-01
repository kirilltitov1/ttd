//
//  File.swift
//  
//
//  Created by Kirill Titov on 06.05.2021.
//

import Fluent
import Vapor

final class Review: Model, Content {
    static var schema: String = "reviews"
    
    @ID
    var id: UUID?
    
    @Parent(key: "user_id")
    public var user: User
    
    @Parent(key: "film_id")
    var film: Film
    
    @Field(key: "text")
    var text: String
    
    required init() {}
    
    init(
        id: UUID? = nil,
        user: User,
        film: Film,
        text: String
    ) throws {
        self.id = id
        self.$user.id = try user.requireID()
        self.$film.id = try film.requireID()
        self.text = text
    }
}

