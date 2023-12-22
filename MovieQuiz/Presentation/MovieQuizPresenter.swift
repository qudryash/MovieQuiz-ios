//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Kudryashov Andrey on 19.12.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var correctAnswers = 0
    
    private var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
    }
    
    //    Метод конвертации из "Список вопросов" QuizQuestion в "Вопрос показан" QuizStepViewModel
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel (
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // Метод положительной загрузки данных с сервера
    func didLoadDataFromServer() {
        viewController?.activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    // Метод отрицательной загрузки данных с сервера
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
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
    private func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    //    Метод работы кнопки ДА
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    //    Метод работы кнопки НЕТ
    func noButtonClicked() {
        didAnswer(isYes: false)
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
    private func resetGame (_: UIAlertAction) {
        self.resetQuestionIndex()
        self.correctAnswers = 0
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
    
    // Метод показа Алерта с информацией об ошибке
    private func showNetworkError(message: String) {
        viewController?.hideLoadingIndicator()
        
        let alertError = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз",
            completion: resetGame)
        
        viewController?.showAlert(alertInformation: alertError)
    }
}

