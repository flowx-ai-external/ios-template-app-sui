//
//  MyFXDataSource.swift
//  AppTemplate
//
//  Created by Bogdan Ionescu on 12.04.2023.
//

import Foundation
import FlowXRenderer
import SwiftUI

class MyFXDataSource: FXDataSource {
    func controllerFor(componentIdentifier: String) -> FXController? {
        nil
    }
    
    func viewFor(componentIdentifier: String) -> FXView? {
        nil
    }
    
    func viewFor(componentIdentifier: String, customComponentViewModel: FXCustomComponentViewModel) -> AnyView? {
        switch componentIdentifier {
        case "myCustomComponent":
            return AnyView(Custom3View(viewModel: customComponentViewModel))
        default:
            return nil
        }
    }
    
    func navigationController() -> UINavigationController? {
        nil
    }
    
    func errorReceivedForAction(name: String?) {
        
    }
    
    func validate(validatorName: String, value: Any) -> Bool {
        switch validatorName {
        case "cnpValidator":
            let cnpValidator = CNPValidator(cnp: value as! String)
            return cnpValidator.isValid()
        default:
            return true
        }
    }
    
    func dismissRequested(forProcess process: String, navigationController: UINavigationController) {
        navigationController.dismiss(animated: true, completion: nil)
        FlowX.sharedInstance.stopProcess(name: process)
    }

    func viewForStepperHeader(stepViewModel: StepViewModel) -> AnyView? {
        return nil
    }
    
}
