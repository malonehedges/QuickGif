//
//  GiphyAPI.swift
//  QuickGif
//
//  Created by Malone Hedges on 8/12/19.
//  Copyright © 2019 Malone Hedges. All rights reserved.
//

import UIKit
import RxSwift

class GiphyAPI {
    
    static let shared = GiphyAPI()
    
    let apiKey: String
    
    init(apiKey: String = "H9bJsQfiiw7v3OMj0oYtYlQcX8FPyjTM") {
        self.apiKey = apiKey
    }
    
    func getSearchResults(_ query: String) -> Observable<[GifSearchResult]> {
        // Avoid unnecessary network requests for empty queries
        if query.isEmpty {
            return Observable.just([])
        }
        
        var searchComponents = URLComponents(string: "https://api.giphy.com/v1/gifs/search")!
        searchComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "limit", value: "25"),
            URLQueryItem(name: "offset", value: "0"),
            URLQueryItem(name: "rating", value: "G"),
            URLQueryItem(name: "lang", value: "en"),
            URLQueryItem(name: "q", value: query)
        ]
        let searchRequest = URLRequest(url: searchComponents.url!)
        
        return URLSession.shared.rx.data(request: searchRequest)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { data in
                let decoder = JSONDecoder()
                let response = try decoder.decode(APIResponse.self, from: data)
                return response.data.map {
                    GifSearchResult(title: $0.title, gifURL: $0.images.fixed_width_small.url)
                }
            }
            .observeOn(MainScheduler.instance)
    }
}
