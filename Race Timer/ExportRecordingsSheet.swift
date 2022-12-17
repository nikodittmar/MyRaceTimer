//
//  ExportRecordingsSheet.swift
//  Race Timer
//
//  Created by niko dittmar on 7/24/22.
//

import SwiftUI

enum recordingsType {
    case start
    case finish
}

enum exportWarnings {
    case none
    case duplicatePlates
    case missingPlates
    case both
}

struct ExportRecordingsSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ViewModel = ViewModel()
    
    var warnings: exportWarnings
    
    let coreDM: DataController = DataController()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    
                    Section {
                        VStack(alignment: .leading, spacing: 10) {
                            if coreDM.getAllResults().count == 1 {
                                Text("Exporting \(coreDM.getAllResults().count) Recording.")
                            } else {
                                Text("Exporting \(coreDM.getAllResults().count) Recordings.")
                            }
                            if warnings == .both {
                                Label("Duplicate Plate Numbers", systemImage: "exclamationmark.circle")
                                    .foregroundColor(Color.yellow)
                                Label("Missing Plate Numbers", systemImage: "exclamationmark.circle")
                                    .foregroundColor(Color.yellow)
                            } else if warnings == .duplicatePlates {
                                Label("Duplicate Plate Numbers", systemImage: "exclamationmark.circle")
                                    .foregroundColor(Color.yellow)
                            } else if warnings == .missingPlates {
                                Label("Missing Plate Numbers", systemImage: "exclamationmark.circle")
                                    .foregroundColor(Color.yellow)
                            }
                        }
                    }
                    Section(header: Text("Race")) {
                        TextField("Stage Name", text: $viewModel.raceName)
                    }
                    Section(header: Text("Stage")) {
                        TextField("Stage Name", text: $viewModel.stageName)
                    }
                    Section(header: Text("Timing Position")) {
                        Picker("Timing Position", selection: $viewModel.recordingsType) {
                            Text("Start")
                                .tag(recordingsType.start)
                            Text("Finish")
                                .tag(recordingsType.finish)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    Section {
                        Button {
                            
                        } label: {
                            Label("Send Results to Other Device", systemImage: "square.and.arrow.up")
                        }
                        Button {
                            
                        } label: {
                            Label("Save Results on Device", systemImage: "arrow.down.to.line")
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Export Recordings"), displayMode: .inline)
            .sheet(item: $viewModel.sheetFile) { file in
                ActivityViewController(itemsToShare: [file])
            }
            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        viewModel.createCsv(results: coreDM.getAllResults())
//                    } label: {
//                        Text("Export")
//                            .fontWeight(.bold)
//                    }
//                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

extension ExportRecordingsSheet {
    @MainActor class ViewModel: ObservableObject {
        @Published var recordingsType: recordingsType = .start
        @Published var sheetFile: URL? = nil
        
        @Published var raceName: String = ""
        @Published var stageName: String = ""
        
        
        init() {

        }
        
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }
        
        func createCsv(results: [Result]) {
            var raceName: String = raceName.replacingOccurrences(of: " ", with: "_")
            var stageName: String = stageName.replacingOccurrences(of: " ", with: "_")
            var timingPosition: String = ""
            
            if raceName == "" {
                raceName = "Untitled_Race"
            }
            
            if stageName == "" {
                stageName = "Untitled_Stage"
            }
            
            switch recordingsType {
            case .start:
                timingPosition = "Start"
            case .finish:
                timingPosition = "Finish"
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH-mm"
            
            let currentTime = Date()
            
            let currentTimeString = dateFormatter.string(from: currentTime)
            
            let fileName = "\(raceName)-\(stageName)-\(timingPosition)-\(currentTimeString)"
            
            var csvString: String = ""
            
            
            for result in results {
                csvString.append("\(result.unwrappedPlate),\(result.timeString)\n")
            }
            
            let fileURL = getDocumentsDirectory().appendingPathComponent("\(fileName).csv")
            
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("no file to delete")
            }
            
            do {
                try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
                sheetFile = fileURL

            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
}


