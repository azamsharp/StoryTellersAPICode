//
//  DataAccess.swift
//  StoryTellersAPI
//
//  Created by Mohammad Azam on 12/6/16.
//
//

import Foundation
import Vapor
import VaporSQLite
import HTTP

extension Node {
    
    func rowId() -> Int {
        return (self["id"]?.nodeArray?.first?.int)!
    }
}

class DataAccess {
    
    func markAsFavorite(userId :String, storyId :String) {
        
        try! drop.database?.driver.raw("insert into UserFavorites(userId, storyId,dateCreated,dateModified) values(?,?,datetime(),datetime())",[userId,storyId])
    }
    
    
    func saveStory(story :Story) -> Story {
        
        try! drop.database?.driver.raw("insert into Stories(title,abstract,detail,genreId,dateCreated,dateModified,userId) values(?,?,?,?,datetime(),datetime(),?);",[story.title,story.abstract,story.detail,story.genreId,story.userId])
        
         var newStory = story
        
        let node = try! drop.database?.driver.raw("select last_insert_rowid() as id")
        newStory.id = node?.rowId()
        return newStory
    }
    
    func getStoriesByUserId(userId :String) -> [Story] {
        
        guard let result = try! drop.database?.driver.raw("select s.id,s.title,s.abstract,s.detail,s.userId from Stories s where s.userId = ?",[userId]),
            let nodes = result.nodeArray else {
                fatalError("No stories found")
        }
        
        return nodes.flatMap(Story.init)
    }
    
    func getStoriesByGenreId(genreId :Int) -> [Story] {
        
        guard let result = try! drop.database?.driver.raw("select s.id,s.title,s.abstract,s.detail,s.userId from Stories s where s.genreId = ?",[genreId]),
            let nodes = result.nodeArray
            else {
                fatalError("No stories found")
        }
        
        return nodes.flatMap(Story.init)
    }
    
    func getGenresHavingStories() -> [Genre] {
        
        guard let result = try! drop.database?.driver.raw("select g.id,g.title,g.detail,count(s.genreId) as numberOfStories from Genres g join Stories s on s.genreId = g.id group by s.genreId;"),
            let nodes = result.nodeArray
            else {
                fatalError("No genres found")
        }
        
        return nodes.flatMap(Genre.init)
    }
    
    func getAllGenres() -> [Genre] {
        
        guard let result = try! drop.database?.driver.raw("select id,title,detail from Genres;"),
            let nodes = result.nodeArray
            else {
                fatalError("No genres found")
        }
        
        return nodes.flatMap(Genre.init)
    }
    
}



