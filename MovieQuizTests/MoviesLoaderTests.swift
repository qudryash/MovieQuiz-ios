//
//  MoviesLoaderTests.swift
//  MoviesLoaderTests
//
//  Created by Kudryashov Andrey on 17.12.2023.
//

import XCTest
@testable import MovieQuiz

final class MoviesLoaderTests: XCTestCase {


    func testSuccessLoading() throws {
        let loader = MoviesLoader ()
        
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            switch result {
            case .success(let movies):
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }

    func testFailureLoading() throws {

    }

}

