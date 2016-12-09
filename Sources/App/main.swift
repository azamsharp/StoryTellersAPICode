import Vapor
import VaporSQLite

let drop = Droplet()
try drop.addProvider(VaporSQLite.Provider.self)

let controller = StoryTellersViewController()
controller.addRoutes(drop :drop)
drop.run()
