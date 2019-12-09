//
//  ContentModel.swift
//  RUMBL
//
//  Created by ds-mayur on 12/9/19.
//  Copyright © 2019 Mayur Rathod. All rights reserved.
//

import Foundation

// MARK: - ContentModelElement
struct ContentModel: Codable {
    var title: String?
    var nodes: [Node]?
}

// MARK: - Node
struct Node: Codable {
    var video: Video?
}

// MARK: - Video
struct Video: Codable {
    var encodeURL: String?

    enum CodingKeys: String, CodingKey {
        case encodeURL = "encodeUrl"
    }
}
