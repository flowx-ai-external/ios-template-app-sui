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
        NavigationView {
            VStack(spacing: 24) {
                Spacer()
                
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal, 8)
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(.separator), lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 6).fill(Color(.systemBackground)))
                    )
                SecureField("Password", text: $password)
                    .padding(.horizontal, 8)
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(.separator), lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 6).fill(Color(.systemBackground)))
                    )
                
                Button("Login") {
                    submitForm()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Login")
        }
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
        
        FXTheme.sharedInstance.setupTheme(withUuid: ProcessConstants.FXThemeId,
                                          workspaceId: ProcessConstants.FXWorkspaceId,
                                          completion: nil)
    }
    
}

#Preview {
    LoginView(isPresented: .constant(true)) { }
}
