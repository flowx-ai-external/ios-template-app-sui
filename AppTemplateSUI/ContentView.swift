//
//  ContentView.swift
//  AppTemplateSUI
//
//  Created by Bogdan Ionescu on 23.10.2023.
//

import SwiftUI
import FlowXRenderer
import FXAuthLibrary
import Combine

class ContentViewModel: ObservableObject {
    let uuid = UUID()

    @Published var processViewController: UIViewController!
    @Published var isProcessPresented: Bool = false
    
    var themeFetched: ReadOnlyCurrentValueSubject<Bool, Never>
    var cancellables: Set<AnyCancellable> = []

    init() {
        self.themeFetched = FXTheme.sharedInstance.themeFetched
    }
    
    func startProcess() {
        themeFetched.sink { fetched in
            if fetched {
                self.startProcessRequest()
            }
        }
        .store(in: &cancellables)
    }
    
    func startProcessRequest() {
        FlowX.sharedInstance.startProcess(name: ProcessConstants.templateProcess,
                                          params: [:],
                                          isModal: true,
                                          showLoader: true) { processRootViewController in
            if let processRootViewController = processRootViewController {
                processRootViewController.modalPresentationStyle = .overFullScreen
                self.processViewController = processRootViewController
                self.isProcessPresented = true
            }
        }
    }
}

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel()
    @State var isLoggedIn: Bool = false
    @State var isLoginPresented: Bool = false
    
    var body: some View {
                
        VStack {
            
            Text("Dashboard")
                .font(.title)
            
            Spacer()
            
            Button("Start process") {
                if isLoggedIn {
                    viewModel.startProcess()
                }
            }
            .fullScreenCover(isPresented: $viewModel.isProcessPresented) {
                FlowxProcessView(viewController: viewModel.processViewController)
                .ignoresSafeArea()
            }

            Spacer()
            
            if isLoggedIn {
                Button("Logout") {
                    FXAuth.sharedInstance.logout {
                        isLoggedIn = false
                    }
                }
            } else {
                Button("Login") {
                    isLoginPresented = true
                }
            }

        }
        .padding()
        .sheet(isPresented: $isLoginPresented, content: {
            LoginView(isPresented: $isLoginPresented) {
                isLoggedIn = true
            }
        })
        .onAppear {
            isLoggedIn = FXAuth.sharedInstance.accessToken != nil
        }
    }
}

#Preview {
    ContentView()
}
