//
//  EnvironmentConstants.swift
//  AppTemplate
//
//  Created by Bogdan Ionescu on 12.04.2023.
//

import Foundation

enum EnvironmentConstants {
    
    static let environment: EnvironmentConstants = .dev
    
    case dev
    
    var baseURL: String {
        switch self {
        case .dev:
            return ""
        }
    }
    
    var imageBaseURL: String {
        switch self {
        case .dev:
            return ""

        }

    }
        
    var authBaseURL: String {
        switch self {
        case .dev:
            return ""
        }
    }
    
    var authClientId: String {
        switch self {
        case .dev:
            return ""
        }
    }
    
    var enginePath: String {
        switch self {
        case .dev:
            return "onboarding"
        }
    }
}
