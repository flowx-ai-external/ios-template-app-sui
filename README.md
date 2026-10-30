# iOS Template Application (SwiftUI)

This application is a template iOS app integrating the FlowX Renderer for running processes and the FlowX Auth library for managing the user session.
The project contains sample implementations of custom components and custom validators.

## Project Setup Guide

This document outlines the necessary steps to configure the project to connect to your FLOWX.AI environment.

### Prerequisites

Ensure you have the following:
- Xcode 26 or newer
- [CocoaPods](https://cocoapods.org) installed
- FlowX repository credentials (username and password)
- Organization ID
- Environment-specific URLs (Base URL, Image Base URL, Engine Path, Authentication URL)
- Keycloak Client ID
- The UUID of the theme to be applied
- Workspace, Project and Process identifiers for starting a process

### Configuration Steps

The key configuration areas are detailed below:

1. **FlowX Repository Access**

   To enable CocoaPods to download the FLOWX.AI SDK, you must configure your repository credentials.

   - **File**: `~/.netrc` (in your home directory; create it if it does not exist)
   - **Action**: Add the following entry containing your credentials received from FlowX.

    ```
    machine nexus-jx.dev.rd.flowx.ai
    login {username}
    password {password}
    ```

2. **FLOWX.AI SDK Version**

    Specify the version of the FLOWX.AI iOS libraries.

    - **File**: `Podfile` (in the root project directory)
    - **Action**: Locate the FlowX pods and update the version number as necessary. Note: use a FLOWX platform compatible version of the SDK.

    ```ruby
    # Pods for AppTemplateSUI
    pod 'FXAuthLibrary'
    pod 'FlowXRenderer', '10.5.11'
    ```

    Then, from the root project directory, run:

    ```
    pod install
    ```

    and open `AppTemplateSUI.xcworkspace` in Xcode.

3. **Environment configuration**

   Define the connection parameters for your specific FLOWX.AI environment.

   - **File**: `AppTemplateSUI/Constants/EnvironmentConstants.swift`
   - **Action**: Fill in the values returned for each environment case.

    ```swift
    enum EnvironmentConstants {

        static let environment: EnvironmentConstants = .dev

        case dev

        var baseURL: String { ... }       // your base url
        var assetsBaseURL: String { ... } // your assets base url
        var authBaseURL: String { ... }   // your authentication url
        var authClientId: String { ... }  // your Keycloak client id
        var enginePath: String { ... }    // your engine path
    }
    ```

4. **SDK configuration**

   Specify the organization id, workspace, project, process name and theme to be used.

   - **File**: `AppTemplateSUI/Constants/ProcessConstants.swift`
   - **Action**: Set the appropriate values for the constants.

    ```swift
    struct ProcessConstants {
        static let FXOrganizationId = "your_organization_id"
        static let FXWorkspaceId = "your_workspace_id"
        static let FXProjectId = "your_project_id"
        static let FXProcess = "your_process_name"
        static let FXThemeId = "your_theme_uuid"
    }
    ```

   These values are consumed in `AppTemplateSUI/AppTemplateSUIApp.swift`, where the auth and FlowX SDKs are configured at app launch:

    ```swift
    FXConfig.sharedInstance.configure { (config) in
        config.organizationId = ProcessConstants.FXOrganizationId
        config.language = "en"
        config.locale = "en-US"
        config.enginePath = EnvironmentConstants.environment.enginePath
        config.baseURL = EnvironmentConstants.environment.baseURL
        config.assetsBaseURL = EnvironmentConstants.environment.assetsBaseURL
        config.logLevel = .verbose
    }
    ```

5. **Theme configuration**

   Specify the workspace and the theme to be applied during process rendering.

   - **File**: `AppTemplateSUI/AppTemplateSUIApp.swift`
   - **Action**: Locate the `FXTheme.sharedInstance.setupTheme` method call. It uses the `FXThemeId` and `FXWorkspaceId` values configured in `ProcessConstants.swift`.

    ```swift
    FXTheme.sharedInstance.setupTheme(withUuid: ProcessConstants.FXThemeId,
                                      workspaceId: ProcessConstants.FXWorkspaceId,
                                      completion: nil)
    ```

6. **Process definition**

   Configure how a process is started.

   - **File**: `AppTemplateSUI/ContentView.swift`
   - **Action**: Locate the `FlowX.sharedInstance.startProcess` method call. It uses the workspace, project and process name configured in `ProcessConstants.swift`; adjust the `params` or presentation options if needed.

    ```swift
    FlowX.sharedInstance.startProcess(navigationController: navigationController,
                                      workspaceId: ProcessConstants.FXWorkspaceId,
                                      projectId: ProcessConstants.FXProjectId,
                                      name: ProcessConstants.FXProcess,
                                      params: [:],
                                      isModal: true,
                                      showLoader: true) { processInstanceUuid in
        print(processInstanceUuid)
    } onProcessEnded: {
        // handle process end
    }
    ```

## Author

Bogdan Ionescu, bogdan.ionescu@flowx.ai

## License

Copyright FlowX.ai 2026
