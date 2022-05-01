//
//  File.swift
//  
//
//  Created by Kirill Titov on 07.05.2021.
//

import Fluent
import Vapor

final class FilmGenre: Model, Content {
    
    static var schema: String = "films_genres"
    
    @ID
    var id: UUID?
    
    @Parent(key: "film_id")
    var film: Film
    
    @Parent(key: "genre_id")
    var genre: Genre
    
    required init() {}
    
    init(
        id: UUID? = nil,
        film: Film,
        genre: Genre
    ) throws {
        self.id = id
        self.$film.id = try film.requireID()
        self.$genre.id = try genre.requireID()
    }
}
