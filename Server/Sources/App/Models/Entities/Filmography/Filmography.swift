//
//  File.swift
//  
//
//  Created by Kirill Titov on 06.05.2021.
//

import Fluent
import Vapor

final class Filmography: Model, Content {
    
    static var schema: String = "filmographies"
    
    @ID
    var id: UUID?
    
    @Parent(key: "actor_id")
    var actor: Actor
    
    @Parent(key: "film_id")
    var film: Film
    
    required init() {}
    
    init(
        id: UUID? = nil,
        actor: Actor,
        film: Film
    ) throws {
        self.id = id
        self.$actor.id = try actor.requireID()
        self.$film.id = try film.requireID()
    }
}
