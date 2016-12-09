//
//  Models.swift
//  StoryTellersAPI
//
//  Created by Mohammad Azam on 11/16/16.
//
//

import Foundation
import Vapor
import HTTP

struct Genre : NodeRepresentable  {
    
    var id :Int?
    var title :String!
    var detail :String!
    var numberOfStories :Int?
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node :["id":self.id,"title":self.title,"detail":self.detail,"numberOfStories":self.numberOfStories])
    }
}

extension Genre {
    
    init?(node :Node) {
        
        self.id = node["id"]?.int
        self.numberOfStories = node["numberOfStories"]?.int
        
        guard let title = node["title"]?.string,
        let detail = node["detail"]?.string
        
             else { return nil }
        
        self.title = title
        self.detail = detail
        
    }
}

struct Story : NodeRepresentable {
    
    var id :Int?
    var title :String!
    var abstract :String!
    var detail :String!
    var genreId :Int!
    var userId :String!
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: ["id":self.id, "title":self.title,"abstract":self.abstract,"detail":self.detail,"userId":self.userId])
    }
}

extension Story {
    
    init?(node :Node) {
        self.id = node["id"]?.int
        
        guard let title = node["title"]?.string,
            let abstract = node["abstract"]?.string,
            let detail = node["detail"]?.string,
            let userId = node["userId"]?.string
        else {
                return nil
        }
        
        self.title = title
        self.abstract = abstract
        self.detail = detail
        self.userId = userId
    }
}








