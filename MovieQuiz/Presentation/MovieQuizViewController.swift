import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Properties
    
    //    Подключаем Storyboard к коду
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // Объявляем значения переменных и ссылки на протоколы и делегаты
    private var correctAnswers = 0
    private var questionFactory: QuestionFactoryProtocol?
    private let alertPresenter: AlertPresenterProtocol = AlertPresenter()
    private var statisticService: StatisticService = StatisticServiceImplementation()
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewController = self
        
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
        }
        
    
    // MARK: - Private functions
    
    //    Метод вывода на экран вопроса
    func show (quiz step: QuizStepViewModel){
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    //    Метод работы кнопки
    func activeButton (isCorrect: Bool){
        if isCorrect {
            yesButton.isEnabled = false
            noButton.isEnabled = false
            
        } else {
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
    }
    
    //    Метод изменения рамки после выбора ответа
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        //        Задержка по времени
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    //    Метод вывода нового вопроса или итогового результата
    private func showNextQuestionOrResults() {
        activeButton(isCorrect: false)
        imageView.layer.borderWidth = 0
        
        if presenter.isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            
            let text = """
            Ваш результат: \(correctAnswers) из \(presenter.questionsAmount)!
            Количество сыграных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.convertToString())
            Средняя точность: \(Int(statisticService.totalAccuracy))%
            """
            
            let alertInformation = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз",
                completion: resetGame)
            
            alertPresenter.show(alertInformation: alertInformation, viewController: self)
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertError = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз",
            completion: resetGame)
        
        alertPresenter.show(alertInformation: alertError, viewController: self)
    }
    
    // Метод сброса вопросов
    private func resetGame (_: UIAlertAction) {
        self.presenter.resetQuestionIndex()
        self.correctAnswers = 0
        self.questionFactory?.requestNextQuestion()
    }
    
    // Метод активации индикатора загрузки
    private func showLoadingIndicator () {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    // Метод деактивации индикатора загрузки
    private func hideLoadingIndicator () {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    // Метод отрицательной загрузки данных с сервера
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // Метод положительной загрузки данных с сервера
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
}
