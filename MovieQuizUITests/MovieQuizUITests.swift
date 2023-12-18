//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Kudryashov Andrey on 18.12.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    
    func testScreenCastNo() throws {
        app.buttons["Нет"].tap()
    }
    
    func testScreenCastYes() throws {
        app.buttons["Да"].tap()
    }
    
    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        XCTAssertTrue(firstPoster.exists)
        app.buttons["Yes"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertTrue(secondPoster.exists)

        
        XCTAssertFalse(firstPosterData == secondPosterData)
    }
    
    
    
}
