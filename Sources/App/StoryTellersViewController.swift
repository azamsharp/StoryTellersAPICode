//
//  StoryTellersViewController.swift
//  StoryTellersAPI
//
//  Created by Mohammad Azam on 12/6/16.
//
//

import Foundation
import Vapor
import VaporSQLite
import HTTP

final class StoryTellersViewController {

    private let dataAccess :DataAccess! 
    
    init() {
        self.dataAccess = DataAccess()
    }
    
    func addRoutes(drop :Droplet) {
        
        // genres with stories
        drop.get("genres","having-stories",handler: controller.genresHavingStories)
        
        // genres all
        drop.get("genres","all",handler :controller.genresAll)
        
        // stories by genreId
        drop.get("genre",Int.self,handler :controller.storiesByGenreId)
        
        // create a new story
        drop.post("story",handler :controller.createStory)
        
        // stories by userId
        drop.get("stories",String.self, handler :controller.storiesByUserId)
        
        // mark as favorite 
        drop.post("story","favorite",handler :controller.markAsFavorite)

    }
    
    func createStory(_ req :Request) throws -> ResponseRepresentable {
        
        guard  let json = req.json,
            let title = json["title"]?.string,
            let abstract = json["abstract"]?.string,
            let detail = json["detail"]?.string,
            let genreId = json["genreId"]?.int,
            let userId = json["userId"]?.string
            else {
                fatalError("Missing arguments!")
        }
        
        var story = Story()
        story.title = title
        story.abstract = abstract
        story.detail = detail
        story.genreId = genreId
        story.userId = userId
        
        story = self.dataAccess.saveStory(story: story)
        return try JSON(node: ["id":story.id!])
    }
    
    func markAsFavorite(_ req :Request) throws -> ResponseRepresentable  {
        
        guard let json = req.json,
            let userId = json["userId"]?.string,
            let storyId = json["storyId"]?.string else {
                fatalError("Missing arguments")
        }
        
        self.dataAccess.markAsFavorite(userId: userId, storyId: storyId)
        return try JSON(node :["status":"200"])
    }
    
    func storiesByUserId(_ req :Request,_ userId :String) throws -> ResponseRepresentable {
        return try JSON(node: self.dataAccess.getStoriesByUserId(userId: userId))
    }
    
    func storiesByGenreId(_ req :Request,_ genreId :Int) throws -> ResponseRepresentable {
       
        return try JSON(node: self.dataAccess.getStoriesByGenreId(genreId: genreId))
    }
    
    func genresAll(_ req :Request) throws -> ResponseRepresentable {
        
        return try JSON(node :self.dataAccess.getAllGenres())
    }
    
    func genresHavingStories(_ req :Request) throws -> ResponseRepresentable {
        
        return try JSON(node :self.dataAccess.getGenresHavingStories())
    }

}


