//
//  File.swift
//  
//
//  Created by Kirill Titov on 18.01.2022.
//

import Foundation
import JWT
import Vapor


extension String {
	var bytes: [UInt8] { .init(self.utf8) }
}

extension JWKIdentifier {
	static let `public` = JWKIdentifier(string: "public")
	static let `private` = JWKIdentifier(string: "private")
}

func configureJWK(_ app: Application) throws {
	let privateKey = try String(contentsOfFile: "/Users/kirilltitov/Documents/BMSTU/6sem/course/course-project/src/Server/jwtRS256.key" /*app.directory.workingDirectory + "jwtRS256.key"*/)
	let privateSigner = try JWTSigner.rs256(key: .private(pem: privateKey.bytes))
	
	let publicKey = try String(contentsOfFile: "/Users/kirilltitov/Documents/BMSTU/6sem/course/course-project/src/Server/jwtRS256.key.pub" /*app.directory.workingDirectory + "jwtRS256.key.pub"*/)
	let publicSigner = try JWTSigner.rs256(key: .public(pem: publicKey.bytes))
	 
	app.jwt.signers.use(privateSigner, kid: .private)
	app.jwt.signers.use(publicSigner, kid: .public, isDefault: true)
}

