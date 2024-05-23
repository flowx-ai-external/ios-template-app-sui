//
//  LoginView.swift
//  AppTemplateSUI
//
//  Created by Bogdan Ionescu on 23.10.2023.
//

import SwiftUI
import FXAuthLibrary
import FlowXRenderer

struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    
    @Binding var isPresented: Bool
    var completion: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Login")
                .font(.title)

            Spacer()
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.none)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            Button("Login") {
                submitForm()
            }
            
            Spacer()
        }
        .padding()
    }
    
    func submitForm() {
        FXAuth.sharedInstance.loginUser(withUsername: email, password: password) { success, error in
            if success {
                self.handleSuccessfulLogin()
                self.isPresented = false
                self.completion()
            }
        }
    }
    
    func handleSuccessfulLogin() {
        FXSessionConfig.sharedInstance.configure { (config) in
            config.token = FXAuth.sharedInstance.accessToken
            config.sessionManager = FXAuth.sharedInstance.sessionManager()
        }
        
        if let accessToken = FXAuth.sharedInstance.accessToken {
            FlowX.sharedInstance.updateAuthorization(token: accessToken)
        }
        
        FXTheme.sharedInstance.setupTheme(withUuid: ProcessConstants.themeId,
                                          localFileUrl: Bundle.main.url(forResource: "theme", withExtension: "json"),
                                          completion: nil)
    }
    
}

#Preview {
    LoginView(isPresented: .constant(true)) { }
}
