//
//  ErrorHandling.swift
//  FinalProject
//
//  Created by Jin Seok Ahn on 11/10/18.
//  Copyright © 2018 Chaehun Ben Lim. All rights reserved.
//

import Foundation
import Firebase

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account."
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email."
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak, have at least 6 characters."
        case .wrongPassword:
            return "Wrong password."
        case .missingEmail:
            return "Please type in your e-mail."
        case .userNotFound:
            return "User not found. Please sign up."
        default:
            return "Unknown error occurred."
        }
    }
}

func stringError(_ error: Error) -> String {
    if let errorCode = AuthErrorCode(rawValue: error._code) {
        return errorCode.errorMessage
    }
    return "Undefined Error"
}
