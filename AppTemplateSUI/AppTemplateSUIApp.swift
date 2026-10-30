//
//  AppTemplateSUIApp.swift
//  AppTemplateSUI
//
//  Created by Bogdan Ionescu on 23.10.2023.
//

import SwiftUI
import FlowXRenderer
import FXAuthLibrary

@main
struct AppTemplateSUIApp: App {
    
    let flowxDataSource = MyFXDataSource()
    
    init() {
        configureAuth()
        configureFlowX()
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func configureAuth() {
        FXAuthConfig.sharedInstance.configure { (config) in
            config.authBaseURL = EnvironmentConstants.environment.authBaseURL
            config.clientId = EnvironmentConstants.environment.authClientId
            
            config.useKeychainPersistence = true
            config.keychainServiceName = "FXTemplateAppSUIService"
            config.logEnabled = true
        }
    }
    
    func configureFlowX() {
        FXConfig.sharedInstance.configure { (config) in
            config.organizationId = ProcessConstants.FXOrganizationId
            config.language = "en"
            config.locale = "en-US"
            config.enginePath = EnvironmentConstants.environment.enginePath
            config.baseURL = EnvironmentConstants.environment.baseURL
            config.assetsBaseURL = EnvironmentConstants.environment.assetsBaseURL
            config.logLevel = .verbose
        }
        
        if let accessToken = FXAuth.sharedInstance.accessToken {
            FXSessionConfig.sharedInstance.configure { (config) in
                config.token = accessToken
                config.sessionManager = FXAuth.sharedInstance.sessionManager()
            }
            FlowX.sharedInstance.startSession()

            DispatchQueue.main.asyncAfter(deadline: .now()+4) {
                FXTheme.sharedInstance.setupTheme(withUuid: ProcessConstants.FXThemeId,
                                                  workspaceId: ProcessConstants.FXWorkspaceId,
                                                  completion: nil)
            }
        }
        
        FlowX.sharedInstance.dataSource = flowxDataSource

    }
    
}
