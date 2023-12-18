//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Kudryashov Andrey on 19.12.2023.
//

import UIKit

final class MovieQuizPresenter {
    //    Метод конвертации из "Список вопросов" QuizQuestion в "Вопрос показан" QuizStepViewModel
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel (
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}

