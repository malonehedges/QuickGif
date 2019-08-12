//
//  APIResponse.swift
//  QuickGif
//
//  Created by Malone Hedges on 8/12/19.
//  Copyright © 2019 Malone Hedges. All rights reserved.
//

import UIKit

struct APIResponse: Codable {
    let data: [APIGif]
    let pagination: APIPagination
    let meta: APIMeta
}

struct APIGif: Codable {
    let id: String
    let title: String
    let images: APIGifImageContainer
    // ...
}

struct APIGifImageContainer: Codable {
    let original: APIGifImage
    let fixed_width_small: APIGifImage
    // ...
}

struct APIGifImage: Codable {
    let url: URL
    // ...
}

struct APIPagination: Codable {
    let total_count: Int
    let count: Int
    let offset: Int
}

struct APIMeta: Codable {
    let status: Int
    let msg: String?
}
