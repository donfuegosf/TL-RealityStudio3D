//
//  FirstMenuView.swift
//  GuidedCapture
//
//  Created by Antonesei Ioan on 11.04.2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI

struct FirstMenuView: View {
    @StateObject var appModel = AppDataModel.instance  // Assuming this is your global app model
        
        var body: some View {
            NavigationView {
                VStack {
                    NavigationLink(destination: ContentView()) {
                        Text("Enter Scan Mode")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: MessageView()) {
                        Text("Show Message")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .environmentObject(appModel)
        }
    }

    struct MessageView: View {
        var body: some View {
            Text("Here I am")
                .font(.title)
                .padding()
        }
    }

#Preview {
    FirstMenuView()
}
