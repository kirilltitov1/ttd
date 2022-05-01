import Fluent
import FluentPostgresDriver
import FluentMySQLDriver
import Vapor
import RxSwift
import Swiftgger
import Foundation
import JWT
import Leaf


// configures your application
public func configure(_ app: Application) throws {
	// uncomment to serve files from /Public folder
	app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
	app.http.server.configuration.serverName = "kino_app"
	
	let homePath = app.directory.workingDirectory
	let certPath = "/etc/cert.pem"
	let keyPath = "/etc/key.pem"
	
	let certs = try! NIOSSLCertificate.fromPEMFile(certPath)
		.map { NIOSSLCertificateSource.certificate($0) }
	let tls = TLSConfiguration.makeServerConfiguration(certificateChain: certs, privateKey: .file(keyPath))
	
	app.http.server.configuration = .init(hostname: "127.0.0.1",
										  port: 8080,
										  backlog: 256,
										  reuseAddress: true,
										  tcpNoDelay: true,
										  responseCompression: .disabled,
										  requestDecompression: .disabled,
										  supportPipelining: false,
										  supportVersions: Set<HTTPVersionMajor>([.one]),
										  tlsConfiguration: nil,
										  serverName: nil,
										  logger: nil)
	
	// создаем базу данных для админа
	app.databases.use(
		.postgres(hostname: "localhost",
				  port: 5432,
				  username: "postgres",
				  password: "5432",
				  database: "kino"),
		as: .admin)
	
	// создаем базу данных для пользователя
	app.databases.use(
		.postgres(hostname: "localhost",
				  port: 5432,
				  username: "client",
				  password: "5432",
				  database: "kino"),
		as: .user)
	
	// создаем базу данных для гостя
	app.databases.use(
		.postgres(hostname: "localhost",
				  port: 5432,
				  username: "guest",
				  password: "5432",
				  database: "kino"),
		as: .guest)
	
	//    app.databases.use(
	//        .mysql(
	//            hostname: "localhost",
	//            username: "root",
	//            password: "04071960",
	//            database: "kino",
	//            tlsConfiguration: .forClient(certificateVerification: .none)
	//        ), as: .mysql)
	
	
	// MARK: MIGRATION
	
	let creators: [Migration] = [CreateUser(),
								 CreateActor(),
								 CreateGenre(),
								 CreateFilm(),
								 CreateFilmGenre(),
								 CreateReview(),
								 CreateFilmography()]
	creators.forEach {
		//        app.migrations.add($0, to: .mysql)
		app.migrations.add($0, to: .admin)
	}
	
	// MARK: DB
	app.films.use { req in
		req.eventLoop.makeSucceededFuture(PostgresFilmsRepository(db: req.db(.admin)))
		//		Auth.auth(req: req).map { repo -> PostgresFilmsRepository in
		//		req PostgresFilmsRepository(db: req.db)
		//            PostgresFilmsRepository(db: req.db(.mysql))
		//		}
	}
	
	app.users.use { req in
		req.eventLoop.makeSucceededFuture(PostgresUserRepository(db: req.db(.admin)))
		//		Auth.auth(req: req).map { repo -> PostgresUserRepository in
		//			PostgresUserRepository(db: req.db)
		//            PostgresUserRepository(db: req.db(.mysql))
		//		}
	}
	
	app.reviews.use { req in
		req.eventLoop.makeSucceededFuture(PostgresReviewRepository(db: req.db(.admin)))
		//		Auth.auth(req: req).map { repo -> PostgresReviewRepository in
		//			PostgresReviewRepository(db: req.db)
		//            PostgresReviewRepository(db: req.db(.mysql))
		//		}
	}
	
	try configureJWK(app)
	
	
	// MARK: LOGGER
	app.logger.logLevel = .info
	try app.autoMigrate().wait()
	
	// MARK: Swagger
	swagger()
	
	app.views.use(.leaf)
	
	// MARK: ROUTER
	// register routes
	try routes(app)
}

extension DatabaseID {
	static var admin = DatabaseID(string: "admin")
	
	static var user = DatabaseID(string: "client")
	
	static var guest = DatabaseID(string: "guest")
}
