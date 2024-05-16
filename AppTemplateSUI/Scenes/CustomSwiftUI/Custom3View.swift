//
//  Custom3View.swift
//  AppTemplate
//
//  Created by Bogdan Ionescu on 12.04.2023.
//

import SwiftUI
import FlowXRenderer

extension FXCustomComponentViewModel {
    
    var userApplication: UserApplication? {
        return (data as? [String: Any])?.decode()
    }
    
}

struct Custom3View: View {
    
    @ObservedObject var viewModel: FXCustomComponentViewModel
    
    @State var userApplication: UserApplication?
    
    var body: some View {
        
        let dataBinding = Binding<UserApplication?>(
            get: { viewModel.userApplication },
            set: { userApplication = $0 }
        )
        
        return VStack {
            Text("It was nice having you here, \(dataBinding.wrappedValue?.firstname ?? "Stranger")!")
                .font(.system(size: 24))
        }

    }
}
