//
//  matchingTests.swift
//  FitFinderTests
//
//  Created by Noah Frew on 5/5/21.
//

import XCTest
@testable import FitFinder

class matchingTests: XCTestCase {
    var sut: OutfitSubmissionSwiftUIView!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = OutfitSubmissionSwiftUIView()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        //sut.articlesOfClothing
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
