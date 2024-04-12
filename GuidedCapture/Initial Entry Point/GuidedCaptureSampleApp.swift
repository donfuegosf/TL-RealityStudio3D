/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Top-level app structure of the view hierarchy.
*/

import SwiftUI

@main
struct GuidedCaptureSampleApp: App {
    @StateObject var viewModel = SharedViewModel() 
    static let subsystem: String = "com.example.apple-samplecode.GuidedCapture"
    
    var body: some Scene {
        WindowGroup {
            if #available(iOS 17.0, *) {
                FirstMenuView().environmentObject(viewModel)
            }
        }
    }
}
