//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Kudryashov Andrey on 20.11.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
