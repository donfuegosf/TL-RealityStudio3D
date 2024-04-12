//
//  FirstMenuView.swift
//  GuidedCapture
//
//  Created by Antonesei Ioan on 11.04.2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI

struct FirstMenuView: View {
    @EnvironmentObject var viewModel: SharedViewModel
    @StateObject var appModel = AppDataModel.instance  // Assuming this is your global app model
        
    var body: some View {
           NavigationView {
               VStack {
                   Spacer() // Pushes everything below to the bottom
                   Text("Welcome to Reality Studio")
                       .font(.largeTitle)
                       .padding(.top, 40)  // Adds top padding to the welcome message

                   Spacer() // Creates space between the message and buttons

                   NavigationLink(destination: ContentView()) {
                       Text("Enter Scan Mode")
                           .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                           .background(Color.blue)
                           .foregroundColor(.white)
                           .cornerRadius(10)
                           .padding(.horizontal)
                   }

                   NavigationLink(destination: FilePickerView()) {
                       Text("Enter Documents Folder")
                           .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                           .background(Color.green)
                           .foregroundColor(.white)
                           .cornerRadius(10)
                           .padding(.horizontal)
                   }
                   NavigationLink(destination: BranchedFilePickerView().environmentObject(viewModel)) {
                       Text("Enter Simple AR mode")
                           .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                           .background(Color.green)
                           .foregroundColor(.white)
                           .cornerRadius(10)
                           .padding(.horizontal)
                   }
                   .padding(.bottom, 20)  // Adds bottom padding to lower button for spacing from the bottom edge
               }
           }
           .environmentObject(appModel)
       }
   }


