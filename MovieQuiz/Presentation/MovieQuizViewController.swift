import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - Properties
    
    //    Подключаем Storyboard к коду
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    private var presenter: MovieQuizPresenter?
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter?.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter?.noButtonClicked()
    }
    
    // Объявляем значения переменных и ссылки на протоколы и делегаты





    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.cornerRadius = 20

        
        showLoadingIndicator()
    

    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter?.didReceiveNextQuestion(question: question)
        }
        
    
    // MARK: - Private functions
    
    //    Метод вывода на экран вопроса
    func show (quiz step: QuizStepViewModel){
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    

    
    //    Метод изменения рамки после выбора ответа
    func showAnswerResult(isCorrect: Bool) {

        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        //        Задержка по времени
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter?.showNextQuestionOrResults()
        }
    }
    
    func resetBorderWith() {
        
        imageView.layer.borderWidth = 0
    }
    
    // Метод активации индикатора загрузки
    func showLoadingIndicator () {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    // Метод деактивации индикатора загрузки
    func hideLoadingIndicator () {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    //    Метод работы кнопки
    func activeButton (isCorrect: Bool){
        yesButton.isEnabled = !isCorrect
        noButton.isEnabled = !isCorrect
    }
    
    func showAlert(alertInformation: AlertModel) {
        
        let alert = UIAlertController (
            title: alertInformation.title,
            message: alertInformation.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction (
            title:alertInformation.buttonText,
            style: .default,
            handler: alertInformation.completion)
        
        alert.view.accessibilityIdentifier = "Game results"
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

}
