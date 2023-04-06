//
//  NewsAPI.swift
//  NewsApp
//
//  Created by SNEAHAAL on 05/04/23.
//


import Foundation

// MARK: - NewsAPIStructure
struct NewsAPIStructure: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Decodable {
    let source: Source
    let author, title, description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
}

// MARK: - Source
struct Source: Decodable {
    let id: ID
    let name: Name
}

enum ID: String, Decodable {
    case techcrunch = "techcrunch"
}

enum Name: String, Decodable {
    case techCrunch = "TechCrunch"
}
