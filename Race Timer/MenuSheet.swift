//
//  MenuSheet.swift
//  Race Timer
//
//  Created by niko dittmar on 8/4/22.
//

import SwiftUI

struct MenuSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ViewModel = ViewModel()
    
    let coreDM: DataController = DataController()
    
    var resetAction: () -> ()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Password"), footer: Text("Ask the race host for the password.")) {
                        SecureField("Password", text: $viewModel.password)
                    }
                    Button("RESET RECORDINGS", role: .destructive) {
                        viewModel.verifyPassword()
                    }
                }
            }
            .navigationBarTitle(Text("Reset Recordings"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert("Are you sure you want to delete all recordings?", isPresented: $viewModel.presentingResetWarning, actions: {
                Button("No", role: .cancel, action: {})
                Button("Yes", role: .destructive, action: {
                    self.resetAction()
                    presentationMode.wrappedValue.dismiss()
                })
            }, message: {
                Text("This cannot be undone.")
            })
            .alert("Incorrect Password", isPresented: $viewModel.incorrectPasswordWarning, actions: {
                Button("Ok", role: .cancel, action: {})
            })
        }
    }
}

extension MenuSheet {
    @MainActor class ViewModel: ObservableObject {
        @Published var password: String = ""
        @Published var presentingResetWarning: Bool = false
        @Published var incorrectPasswordWarning: Bool = false
        
        func verifyPassword() {
            if password == "2022Enduro" {
                presentingResetWarning = true
            } else {
                incorrectPasswordWarning = true
            }
        }
        
    }
}
