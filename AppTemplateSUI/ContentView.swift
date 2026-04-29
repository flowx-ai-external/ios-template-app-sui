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

    @Published var navigationController: UINavigationController!
    @Published var isProcessPresented: Bool = false

    var themeFetched: ReadOnlyCurrentValueSubject<Bool, Never>
    var cancellables: Set<AnyCancellable> = []

    init() {
        self.themeFetched = FXTheme.sharedInstance.themeFetched
    }

    func startProcess() {
        themeFetched.sink { fetched in
            if fetched {
                DispatchQueue.main.async {
                    self.startProcessRequest()
                }
            }
        }
        .store(in: &cancellables)
    }

    func startProcessRequest() {
        let navigationController = FXNavigationViewController.navigationController()
        navigationController.modalPresentationStyle = .overFullScreen
        self.navigationController = navigationController
        self.isProcessPresented = true

        FlowX.sharedInstance.startProcess(navigationController: navigationController,
                                          workspaceId: ProcessConstants.FXWorkspaceId,
                                          projectId: ProcessConstants.FXProjectId,
                                          name: ProcessConstants.FXProcess,
                                          params: [:],
                                          isModal: true,
                                          showLoader: true) { [weak self] in
            self?.isProcessPresented = false
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
                FlowxProcessView(viewController: viewModel.navigationController)
                    .preferredColorScheme(.light)
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
