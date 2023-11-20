//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Kudryashov Andrey on 20.11.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    var delegate: QuestionFactoryDelegate? { get set }
}
