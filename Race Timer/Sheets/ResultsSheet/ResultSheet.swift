//
//  ResultSheet.swift
//  Race Timer
//
//  Created by niko dittmar on 2/18/23.
//

import SwiftUI

struct ResultsSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ResultsSheetViewModel = ResultsSheetViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Race Results")) {
                        NavigationLink("Calculate", destination: SelectRecordings())
                    }
                    Section(header: Text("Name Lists")) {
                        Button("Create New Name List") {
                            
                        }
                        Button("Import Name List") {
                            
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Race Results"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .environmentObject(viewModel)
    }
}
