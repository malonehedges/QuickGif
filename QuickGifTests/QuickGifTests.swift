//
//  QuickGifTests.swift
//  QuickGifTests
//
//  Created by Malone Hedges on 8/12/19.
//  Copyright © 2019 Malone Hedges. All rights reserved.
//

import XCTest
@testable import QuickGif
import RxSwift

class QuickGifTests: XCTestCase {
    
    var giphyAPI: GiphyAPI!
    var disposeBag: DisposeBag!

    override func setUp() {
        giphyAPI = GiphyAPI()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        giphyAPI = nil
        disposeBag = nil
    }
    
    func testEmptySearchQuery() {
        let expectation = XCTestExpectation(description: "Receive results from getSearchResults")
        
        giphyAPI.getSearchResults("")
            .bind(onNext: { result in
                XCTAssertTrue(result.isEmpty)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testSpecificSearchQuery() {
        let expectation = XCTestExpectation(description: "Receive results from getSearchResults")
        
        giphyAPI.getSearchResults("vulfpeck")
            .bind(onNext: { result in
                XCTAssertEqual(result.count, 25)
                
                let firstThreeResultTitles = result.prefix(3).map { $0.title }
                XCTAssertEqual(firstThreeResultTitles, ["vulfpeck GIF", "band jamming GIF", "jack stratton funny dance GIF"])
                
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
}
