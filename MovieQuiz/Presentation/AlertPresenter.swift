//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Kudryashov Andrey on 21.11.2023.
//

import UIKit
class AlertPresenter: AlertPresenterProtocol {
    
    func show(alertInformation: AlertModel, viewController: UIViewController) {
        
        let alert = UIAlertController (
            title: alertInformation.title,
            message: alertInformation.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction (
            title:alertInformation.buttonText,
            style: .default,
            handler: alertInformation.completion)
        
        alert.addAction(action)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
