//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Kudryashov Andrey on 23.12.2023.
//

import Foundation
import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show (quiz step: QuizStepViewModel)
    func showAlert(alertInformation: AlertModel)
    
    func showAnswerResult(isCorrect: Bool)
    
    func showLoadingIndicator ()
    
    func hideLoadingIndicator ()
    
    func showNetworkError(message: String)
    
    func activeButton (isCorrect: Bool)
    
    func resetBorderWith()
    
    func indicator()
}
