//
//  File.swift
//  
//
//  Created by Kirill Titov on 18.01.2022.
//

import Foundation
import Vapor
import Swiftgger

func swagger() {
	let openAPIBuilder = OpenAPIBuilder(
		title: "Swagger documentation for Kino API",
		version: "2.0.0",
		description: "This is a sample server for task server application.",
		termsOfService: "http://example.com/terms/",
		contact: APIContact(name: "Kirill & Maria", email: "test@email.ru", url: URL(string: "https://www.google.ru/")),
		license: APILicense(name: "MIT", url: URL(string: "http://mit.license")),
		authorizations: [.jwt(description: "You can get token from *sign-in* action from *Account* controller.")]
	)
		.add(
			APIController(name: "Auth", description: "Authorization on Kino app", actions: [
				APIAction(method: .get,
						  route: "/api/v2/jwt/check_jwt/{access_token}",
						  summary: "Update token",
						  description: "Updates access token using refresh token",
						  parameters: [
							APIParameter(name: "access_token",
										 parameterLocation: .path,
										 description: "Access token",
										 required: true,
										 deprecated: false,
										 allowEmptyValue: false,
										 dataType: .uuid)],
						  responses: [
							APIResponse(code: "200", description: "Successful operation", object: TokenResponse.self),
							APIResponse(code: "401", description: "Invalid refresh token, need authorization")
						  ]),
				APIAction(method: .get,
						  route: "/api/v2/login/{email}/{password_hash}",
						  summary: "Login user",
						  description: "Created user object",
						  parameters: [
							APIParameter(name: "email",
										 parameterLocation: .path,
										 description: "Created user object",
										 required: true,
										 deprecated: false,
										 allowEmptyValue: false,
										 dataType: .string),
							APIParameter(name: "password_hash",
										 parameterLocation: .path,
										 description: "Created user object",
										 required: true,
										 deprecated: false,
										 allowEmptyValue: false,
										 dataType: .string)
						  ],
						  responses: [
							APIResponse(code: "200", description: "Successful operation", object: TokensID.self),
							APIResponse(code: "400", description: "Invalid login or password")
						  ]),
				APIAction(method: .post,
						  route: "/api/v2/email_reg",
						  summary: "Register via email",
						  description: "Register via email",
						  request: APIRequest(object: UserReg.self, description: "Объект пользователя для регистрации"),
						  responses: [
							APIResponse(code: "200", description: "successful operation"),
							APIResponse(code: "409", description: "user already exists")
						  ],
						  authorization: true),
				
			]))
		.add(
			APIController(name: "Films", description: "film actions", actions: [
				APIAction(method: .get,
						  route: "/api/v2/films",
						  summary: "get films",
						  description: "get all films",
						  responses: [
							APIResponse(code: "200", description: "Successful operation", array: FilmDTO.self)
						  ],
						  authorization: false),
				APIAction(method: .get,
						  route: "/api/v2/films/reviews/{film_id}",
						  summary: "get reviews",
						  description: "get all reviews by film id",
						  parameters: [
							APIParameter(name: "film_id",
										 parameterLocation: .path,
										 description: "film id",
										 required: true,
										 dataType: .uuid)
						  ],
						  responses: [
							APIResponse(code: "200", description: "Successful operation", array: ReviewDTO.self)
						  ],
						  authorization: false),
				APIAction(method: .get,
						  route: "/api/v2/films/filtering_param/{genre}",
						  summary: "filtering",
						  description: "filtering by existing genres",
						  parameters: [
							APIParameter(name: "genre",
										 parameterLocation: .path,
										 required: true,
										 deprecated: false,
										 allowEmptyValue: true,
										 dataType: .string)
						  ],
						  responses: [
							APIResponse(code: "200", description: "Successful operation", array: FilmDTO.self),
							APIResponse(code: "404", description: "Genre not found")
						  ],
						  authorization: false)
			])
		)
		.add(
			APIController(name: "Review", description: "user review" , actions: [
				APIAction(method: .delete,
						  route: "/api/v2/reviews/jwt/delete/{review_id}",
						  summary: "delete review",
						  description: "delete review by id",
						  parameters: [
							APIParameter(name: "review_id",
										 parameterLocation: .path,
										 description: "review id",
										 required: true,
										 deprecated: false,
										 allowEmptyValue: false,
										 dataType: .uuid)
						  ],
						  responses: [
							APIResponse(code: "200", description: "Successful operation"),
							APIResponse(code: "404", description: "Review not found"),
						  ],
						  authorization: false),
				APIAction(method: .get,
						  route: "/api/v2/reviews/jwt/make/{film_id}/{text}",
						  summary: "update review",
						  description: "update review",
						  parameters: [
							APIParameter(name: "film_id",
										 parameterLocation: .path,
										 description: "film id",
										 required: true,
										 deprecated: false,
										 allowEmptyValue: false,
										 dataType: .uuid),
							APIParameter(name: "text",
										 parameterLocation: .path,
										 description: "review text",
										 required: true,
										 deprecated: false,
										 allowEmptyValue: false,
										 dataType: .string)
						  ],
						  responses: [
							APIResponse(code: "200", description: "Successful operation"),
							APIResponse(code: "404", description: "Film not found"),
						  ],
						  authorization: false),
				APIAction(method: .get,
						  route: "/api/v2/reviews/jwt/update/{film_id}/{new_review}",
						  summary: "update review",
						  description: "update review",
						  parameters: [
							APIParameter(name: "film_id",
										 parameterLocation: .path,
										 description: "film id",
										 required: true,
										 deprecated: false,
										 allowEmptyValue: false,
										 dataType: .uuid),
							APIParameter(name: "new_review",
										 parameterLocation: .path,
										 description: "new review text",
										 required: true,
										 deprecated: false,
										 allowEmptyValue: false,
										 dataType: .string)
						  ],
						  responses: [
							APIResponse(code: "200", description: "Successful operation"),
							APIResponse(code: "404", description: "Review/Film not found"),
						  ],
						  authorization: false),
			])
		)
		.add(
			APIController(name: "User", description: "user actions", actions: [
				APIAction(method: .get,
						  route: "/api/v2/user/id/{access_token}",
						  summary: "get user",
						  description: "get user by id",
						  parameters: [
							APIParameter(name: "access_token",
										 parameterLocation: .path,
										 description: "user token",
										 required: true,
										 deprecated: true,
										 allowEmptyValue: false,
										 dataType: .uuid)
						  ],
						  responses: [
							APIResponse(code: "200", description: "Successful operation"),
							APIResponse(code: "401", description: "Invalid access token"),
							APIResponse(code: "404", description: "User not found"),
						  ],
						  authorization: false),
				APIAction(method: .put,
						  route: "/api/v2/user/id",
						  summary: "update user",
						  description: "update user by id",
						  parameters: [
							APIParameter(name: "access_token",
										 parameterLocation: .header,
										 description: "user token",
										 required: true,
										 deprecated: true,
										 allowEmptyValue: false,
										 dataType: .uuid)
						  ],
						  request: APIRequest(object: UserUpdate.self),
						  responses: [
							APIResponse(code: "200", description: "Successful operation"),
							APIResponse(code: "401", description: "Invalid user id supplied"),
							APIResponse(code: "404", description: "User not found"),
						  ],
						  authorization: false),
				APIAction(method: .delete,
						  route: "/api/v2/user/id/{access_token}",
						  summary: "delete user",
						  description: "delete user by id",
						  parameters: [
							APIParameter(name: "access_token",
										 parameterLocation: .path,
										 description: "user token",
										 required: true,
										 deprecated: true,
										 allowEmptyValue: false,
										 dataType: .uuid)
						  ],
						  responses: [
							APIResponse(code: "200", description: "Successful operation"),
							APIResponse(code: "401", description: "Invalid user id supplied"),
							APIResponse(code: "404", description: "User not found"),
						  ],
						  authorization: false),
			])
		)
		.add([
			APIObject(object: TokenResponse(access_token: "string", refresh_token: "string")),
			APIObject(object: TokensID(user_id: UUID(), access_token: "string", refresh_token: "string")),
			APIObject(object: UserReg(email: "string", password: "string")),
			APIObject(object: UserUpdate(token: "string", fio: "string", email: "string", password: "string")),
			APIObject(object: FilmDTO(id: UUID(), name: "string", age_rating: 0, box_office: 0, date: Date())),
			APIObject(object: ReviewDTO()),
			APIObject(object: UUID()),
			APIObject(object: UserRights(rawValue: 2))
		])
	
	let doc = openAPIBuilder.built()
	
	do {
		let jsonEncoder = JSONEncoder()
		jsonEncoder.outputFormatting = .prettyPrinted
		let jsonData = try jsonEncoder.encode(doc)
		let json = String(data: jsonData, encoding: .utf8)
		try json?.write(
			toFile: "/Users/kirilltitov/Documents/BMSTU/6sem/course/course-project/src/Server/Sources/App/Setup/file.txt",
			atomically: true,
			encoding: .utf8
		)
		print(json)
	} catch {
		print(error)
	}
}

