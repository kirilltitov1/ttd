//
//  File.swift
//  
//
//  Created by Kirill Titov on 06.05.2021.
//

import Fluent
import Vapor

final class Genre: Model, Content {
    
    static var schema: String = "genres"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Siblings(through: FilmGenre.self, from: \.$genre, to: \.$film)
    public var films: [Film]
    
    required init() {}
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
