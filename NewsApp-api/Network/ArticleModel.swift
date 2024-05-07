//
//  ArticleModel.swift
//  NewsApp-api
//
//  Created by Alex  on 07.05.2024.
//

import Foundation

struct ArticleModel: Decodable {
	let section: String
	let title: String
	let abstract: String
	let published_date: String
	let uri: String
	let url: String
	let multimedia: [Multimedia]
}

struct Multimedia: Decodable {
	let url: String
	let format: String
	let height: Int
	let width: Int
	let type: String
	let subtype: String
	let caption: String
	let copyright: String
}

struct Query: Decodable {
	let status: String
	let results: [ArticleModel]
} 
