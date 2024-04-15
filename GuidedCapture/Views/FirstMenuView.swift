//
//  FirstMenuView.swift
//  GuidedCapture
//
//  Created by Antonesei Ioan on 11.04.2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI

struct ButtonStyleModifier: ViewModifier {
    var backgroundColor: Color = .blue
    
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
    }
}

extension View {
    func buttonModifier() -> some View {
        self.modifier(ButtonStyleModifier())
    }
}


struct FirstMenuView: View {
    @EnvironmentObject var viewModel: SharedViewModel
    @StateObject var appModel = AppDataModel.instance  // Assuming this is your global app model
        
    var body: some View {

               VStack {
                   Spacer() // Pushes everything below to the bottom
                   Text("Welcome to Reality Studio")
                       .font(.largeTitle)
                       .padding(.top, 40)  // Adds top padding to the welcome message

                   Spacer() // Creates space between the message and buttons

                   NavigationLink(destination: ContentView()) {
                       Text("Enter Scan Mode")
                           .buttonModifier()
                   }

                   NavigationLink(destination: FilePickerView()) {
                       Text("Enter Documents Folder")
                           .buttonModifier()

                   }
                   NavigationLink(destination: BranchedFilePickerView().environmentObject(viewModel)) {
                       Text("Enter Simple AR mode")
                           .buttonModifier()
                   }
                   NavigationLink(destination: ScansFolderView()) {
                       Text("View to delete Folders")
                           .buttonModifier()
                   }
                   .padding(.bottom, 20)  // Adds bottom padding to lower button for spacing from the bottom edge
               }
       }
   }


