//
//  News.swift
//  Newsific
//
//  Created by István Juhász on 2022. 08. 05..
//

import Foundation

struct APIResponse: Codable {
    var news: [News]
}

struct News: Codable {
    let id: String
    let title: String
    let author: String
    let image: String
    let category: [String]
    let published: String
    
    var convertedPublished: String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"

        
        if let date = dateFormatterGet.date(from: published) {
            return Date().offsetFrom(date: date) + " ago"
        } else {
           return "Error"
        }
    }
}
