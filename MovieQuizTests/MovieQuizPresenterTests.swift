//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Kudryashov Andrey on 23.12.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func activeButton(isCorrect: Bool) {
    }
    
    func resetBorderWith() {
    }
    
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
    }
    
    func showAlert(alertInformation: MovieQuiz.AlertModel) {
    }
    
    func showAnswerResult(isCorrect: Bool) {
    }
    
    func showLoadingIndicator() {
    }
    
    func hideLoadingIndicator() {
    }
    
    func showNetworkError(message: String) {
    }
    
    func indicator() {
    }
}

final class MovieQuizPresenterTests: XCTestCase {

    func testPresenterConvertModel() throws {
            let viewControllerMock = MovieQuizViewControllerMock()
            let sut = MovieQuizPresenter(viewController: viewControllerMock)
            
            let emptyData = Data()
            let question = QuizQuestion(
                image: emptyData,
                text: "Question Text",
                correctAnswer: true)
            let viewModel = sut.convert(model: question)
            
             XCTAssertNotNil(viewModel.image)
            XCTAssertEqual(viewModel.question, "Question Text")
            XCTAssertEqual(viewModel.questionNumber, "1/10")
        }
    
}
