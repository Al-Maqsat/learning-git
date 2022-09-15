//
//  Feed.swift
//  Milestone(Day59)
//
//  Created by Maksat Baiserke on 15.09.2022.
//

import Foundation

struct feed: Codable{
    var source: source
    var author: String?
    var title: String?
    var description: String?
    var publishedAt: String?
    var content: String?
}
