//
//  Model.swift
//  NewsApp
//
//  Created by Nodirbek on 17/04/22.
//

import Foundation



struct Welcome: Codable{
    let articles: [Article]
}

struct Article: Codable{
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let content: String?
}

struct Source: Codable{
    let name: String
}
