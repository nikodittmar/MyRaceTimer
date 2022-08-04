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

extension URL: Identifiable {
    public var id: UUID {
        return UUID()
    }
}

struct ExportRecordingsSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ViewModel = ViewModel()
    
    let coreDM: DataController = DataController()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Text("Exporting \(coreDM.getAllResults().count) Recording(s).")
                    Section(header: Text("Stage")) {
                        Picker("Stage", selection: $viewModel.stage) {
                            Text("Cinderella")
                                .tag(stage.Cinderella)
                            Text("Chaparral")
                                .tag(stage.Chaparral)
                            Text("Castle Park")
                                .tag(stage.CastlePark)
                        }
                        .pickerStyle(.inline)
                        .labelsHidden()
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
                }
            }
            .navigationBarTitle(Text("Export Recordings"), displayMode: .inline)
            .sheet(item: $viewModel.sheetFile) { file in
                ActivityViewController(itemsToShare: [file])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.createCsv(results: coreDM.getAllResults())
                    } label: {
                        Text("Export")
                            .fontWeight(.bold)
                    }
                }
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
        @Published var stage: stage = .Cinderella
        @Published var sheetFile: URL? = nil
        
        
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

struct ExportRecordingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        ExportRecordingsSheet()
    }
}

