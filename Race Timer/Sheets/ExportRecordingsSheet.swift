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

enum stage {
    case Cinderella
    case Chaparral
    case CastlePark
}

struct ExportRecordingsSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ContentViewViewModel
        
    var body: some View {
        NavigationView {
            VStack {
                Form {
//                    if coreDM.getAllResults().count == 1 {
//                        Text("Exporting \(coreDM.getAllResults().count) Recording.")
//                    } else {
//                        Text("Exporting \(coreDM.getAllResults().count) Recordings.")
//                    }
                    Section(header: Text("Stage Name")) {
                        TextField("Stage Name", text: $viewModel.stageName)
                    }
                    Section(header: Text("Results Type")) {
                        Picker("Timing Position", selection: $viewModel.recordingsType) {
                            Text("Stage Start")
                                .tag(TimingMode.start)
                            Text("Stage Finish")
                                .tag(TimingMode.finish)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    Section(header: Text("Actions")) {
                        Button("Save") {
                            viewModel.updateTimingResultDetails()
                        }
                        Button("Export") {
                            
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Save/Export Result"), displayMode: .inline)
            .toolbar {
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
        let coreDM: DataController = DataController()
        
        @Published var recordingsType: recordingsType = .start
        @Published var stage: stage = .Cinderella
        @Published var sheetFile: URL? = nil
        @Published var stageName: String = ""
        
        
        
        init() {

        }
        
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }
        
        func createCsv(results: [Result]) {
            var stageName: String = ""
            var timingPosition: String = ""
            
            switch recordingsType {
            case .start:
                timingPosition = "Start"
            case .finish:
                timingPosition = "Finish"
            }
            
            switch stage {
            case .Cinderella:
                stageName = "Cinderella"
            case .Chaparral:
                stageName = "Chaparral"
            case .CastlePark:
                stageName = "Castle_Park"
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH-mm"
            
            let currentTime = Date()
            
            let currentTimeString = dateFormatter.string(from: currentTime)
            
            let fileName = "\(stageName)_\(timingPosition)_\(currentTimeString)"
            
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

