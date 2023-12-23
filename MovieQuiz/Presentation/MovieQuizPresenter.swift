//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Kudryashov Andrey on 19.12.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService
    
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var correctAnswers = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
    }
    
    // Метод положительной загрузки данных с сервера
    func didLoadDataFromServer() {
        viewController?.indicator()
        questionFactory?.requestNextQuestion()
    }
    
    // Метод отрицательной загрузки данных с сервера
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    //    Метод работы кнопки ДА
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    //    Метод работы кнопки НЕТ
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    //    Метод конвертации из "Список вопросов" QuizQuestion в "Вопрос показан" QuizStepViewModel
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel (
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    //    Метод расчета следующего вопроса
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    //    Метод счета индекса вопроса
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    //    Метод обнуления индекса вопроса
    private func restartGame() {
        currentQuestionIndex = 0
        self.correctAnswers = 0
    }
    
    //    Метод логики ответов
    private func didAnswer (isYes: Bool) {
        
        guard let currentQuestion = currentQuestion else { return }
        
        let givenAnswer = isYes
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        viewController?.activeButton(isCorrect: true)
        viewController?.showAnswerResult(isCorrect: isCorrect)
        
        if isCorrect {
            correctAnswers += 1
        }
        
        //        Задержка по времени
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    //    Метод логики вопросов
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    // Метод сброса вопросов
    func resetGame (_: UIAlertAction) {
        self.restartGame()
        self.questionFactory?.requestNextQuestion()
    }
    
    //    Метод вывода нового вопроса или итогового результата
    private func showNextQuestionOrResults() {
        viewController?.activeButton(isCorrect: false)
        viewController?.resetBorderWith()
        
        if isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let text = """
            Ваш результат: \(correctAnswers) из \(questionsAmount)!
            Количество сыграных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.convertToString())
            Средняя точность: \(Int(statisticService.totalAccuracy))%
            """
            
            let alertInformation = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз",
                completion: resetGame)
            
            viewController?.showAlert(alertInformation: alertInformation)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    

}

