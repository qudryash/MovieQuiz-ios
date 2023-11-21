//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Kudryashov Andrey on 21.11.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (UIAlertAction) -> ()
}
