//
//  File.swift
//  
//
//  Created by Kirill Titov on 17.01.2022.
//

import Vapor
import JWT

struct UserJWTPayload: Authenticatable, JWTPayload {
	
	var id: UUID
	var fio: String
	var exp: ExpirationClaim
	
	func verify(using signer: JWTSigner) throws {
		try self.exp.verifyNotExpired()
	}
}
