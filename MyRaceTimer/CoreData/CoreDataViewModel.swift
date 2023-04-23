//
//  CoreDataViewModel.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/18/23.
//

import Foundation
import CoreData

public enum ResultType: String {
    case Start = "start"
    case Finish = "finish"
}

@MainActor class CoreDataViewModel: ObservableObject {
    private let viewContext = PersistenceController.shared.viewContext
    
    @Published var recordings: [Recording] = []
    @Published var duplicatePlates: [String] = []
    
    @Published var results: [Result] = []
    
    @Published var selectedRecording: Recording?
        
    @Published var resultName: String = ""
    @Published var resultType: ResultType = ResultType.Start
    
    @Published var selectedResult: Result? {
        didSet {
            UserDefaults.standard.set(selectedResult?.wrappedId.uuidString ?? "", forKey: "selectedResultIdString")
            selectedRecording = nil
            updateRecordings()
        }
    }
    
    @Published var timeElapsedString: String = "0s"
    @Published var timerIsActive: Bool = false
    
    @Published var presentingImportSuccessModal: Bool = false
    @Published var presentingImportFailModal: Bool = false
    
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    var secondsSinceLastRecording: Double = 0.0
    
    init() {
        if let selectedResultIdString = UserDefaults.standard.object(forKey: "selectedResultIdString") as? String {
            if let selectedResult = resultFromIdString(selectedResultIdString) {
                self.selectedResult = selectedResult
                self.resultName = selectedResult.wrappedName
                self.resultType = selectedResult.wrappedType
            } else {
                createResult()
            }
        } else {
            createResult()
        }
        
        updateRecordings()
        updateResults()
    }
    
    func handleRecordTime() {
        if let selectedResult = self.selectedResult {
            let recordingsWithoutTimestamp: [Recording] = selectedResult.wrappedRecordingsWithoutTimestamps
            
            if recordingsWithoutTimestamp.isEmpty {
                createRecording()
            } else {
                let currentTime = Double(Date().timeIntervalSince1970)
                
                for recording in recordingsWithoutTimestamp {
                    recording.setValue(currentTime, forKey: "timestamp")
                }
                
                do {
                    try viewContext.save()
                    updateRecordings()
                    secondsSinceLastRecording = 0.0
                    timeElapsedString = "0s"
                    timerIsActive = true
                } catch {
                    viewContext.rollback()
                    print("Unable to set Recordings Timestamps: \(error)")
                }
            }
        }
    }
    
    func importResult(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = viewContext
            do {
                let result = try decoder.decode(Result.self, from: data)
                if let currentResult = selectedResult {
                    if currentResult.wrappedRecordings.isEmpty && currentResult.wrappedName.isEmpty {
                        viewContext.delete(currentResult)
                    }
                }
                
                do {
                    try viewContext.save()
                    selectedResult = result
                    updateResults()
                    updateRecordings()
                    resultName = result.wrappedName
                    resultType = result.wrappedType
                    timerIsActive = false
                    presentingImportSuccessModal = true
                } catch {
                    viewContext.rollback()
                }
            } catch {
                presentingImportFailModal = true
                print("\(error)")
            }
        } catch {
            if url.startAccessingSecurityScopedResource() {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.managedObjectContext] = viewContext
                    do {
                        let result = try decoder.decode(Result.self, from: data)
                        if let currentResult = selectedResult {
                            if currentResult.wrappedRecordings.isEmpty && currentResult.wrappedName.isEmpty {
                                viewContext.delete(currentResult)
                            }
                        }
                        
                        do {
                            try viewContext.save()
                            selectedResult = result
                            updateResults()
                            updateRecordings()
                            resultName = result.wrappedName
                            resultType = result.wrappedType
                            timerIsActive = false
                            presentingImportSuccessModal = true
                        } catch {
                            viewContext.rollback()
                        }
                    } catch {
                        presentingImportFailModal = true
                        print("\(error)")
                    }
                } catch {
                    presentingImportFailModal = true
                    print("\(error)")
                }
            } else {
                presentingImportFailModal = true
                print("\(error)")
            }
            
            url.stopAccessingSecurityScopedResource()
        }
    }
    
    // Create
    
    func createResult(name: String = "", type: ResultType = ResultType.Start) {
        let result = Result(context: viewContext)
        let resultId: UUID = UUID()
        
        result.id = resultId
        result.createdDate = Double(Date().timeIntervalSince1970)
        result.updatedDate = Double(Date().timeIntervalSince1970)
        result.type = type.rawValue
        result.name = name
        
        do {
            try viewContext.save()
            selectedResult = result
            updateResults()
            resultName = result.wrappedName
            resultType = result.wrappedType
        } catch {
            print("Failed to save Result!")
        }
    }
    
    func createRecording(withoutTimestamp: Bool = false) {
        if let selectedResult = self.selectedResult {
            let recording = Recording(context: viewContext)
            
            recording.id = UUID()
            recording.plate = ""
            recording.createdDate = Double(Date().timeIntervalSince1970)
            if withoutTimestamp {
                recording.timestamp = 0.0
            } else {
                recording.timestamp = Double(Date().timeIntervalSince1970)
            }
            recording.result = selectedResult
            
            selectedResult.setValue(Double(Date().timeIntervalSince1970), forKey: "updatedDate")
            
            do {
                try viewContext.save()
                updateRecordings()
                selectedRecording = recording
                if !withoutTimestamp {
                    secondsSinceLastRecording = 0.0
                    timeElapsedString = "0s"
                    timerIsActive = true
                }
            } catch {
                print("Failed to save Recording!")
            }
        } else {
            print("No selected Result found, Recording was not created!")
        }
    }
    
    // READ
    
    private func resultFromIdString(_ idString: String) -> Result? {
        if let id = UUID(uuidString: idString) {
            let fetchRequest: NSFetchRequest<Result> = Result.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            fetchRequest.fetchLimit = 1
            return try? viewContext.fetch(fetchRequest).first
        } else {
            return nil
        }
    }
    
    private func updateRecordings() {
        if let selectedResult = self.selectedResult {
            recordings = selectedResult.wrappedRecordings
            duplicatePlates = recordings.plates().duplicates()
        } else {
            print("No selected Result found, Recordings were not updated!")
        }
    }
    
    private func updateResults() {
        let fetchRequest = NSFetchRequest<Result>(entityName: "Result")
        let sortDescriptor = NSSortDescriptor(key: "updatedDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            results = try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch Results!")
        }
    }
    
    func recordingIsSelected(_ recording: Recording) -> Bool {
        return self.selectedRecording == recording
    }
    
    func isDuplicate(recording: Recording) -> Bool {
        if recording.wrappedPlate != "" {
            if duplicatePlates.contains(recording.wrappedPlate) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func recordingPlaceLabel(recording: Recording) -> String {
        return String(recordings.firstIndex(where: {$0.wrappedId == recording.wrappedId}) ?? 0)
    }
    
    func displayedResults() -> [Result] {
        var displayedResults: [Result] = []
        
        for result in results {
            if result.wrappedId != selectedResult?.wrappedId ?? UUID() {
                displayedResults.append(result)
            }
        }
        
        return displayedResults
    }

    // UPDATE
    
    func setResultType(_ type: ResultType) {
        if let selectedResult = self.selectedResult {
            selectedResult.setValue(type.rawValue, forKey: "type")
            selectedResult.setValue(Double(Date().timeIntervalSince1970), forKey: "updatedDate")
            
            do {
                try viewContext.save()
                updateResults()
            } catch {
                viewContext.rollback()
                print("Unable to set Result tpye: \(error)")
            }
        } else {
            print("No selected Result found, Result type was not set!")
        }
    }
    
    func setResultName(_ name: String) {
        if let selectedResult = self.selectedResult {
            selectedResult.setValue(name, forKey: "name")
            selectedResult.setValue(Double(Date().timeIntervalSince1970), forKey: "updatedDate")
            
            do {
                try viewContext.save()
                updateResults()
            } catch {
                viewContext.rollback()
                print("Unable to set Result name: \(error)")
            }
        } else {
            print("No selected Result found, Result name was not set!")
        }
    }
    
    func selectResult(_ result: Result) {
        
        result.setValue(Double(Date().timeIntervalSince1970), forKey: "updatedDate")
        
        if let currentResult = selectedResult {
            if currentResult.wrappedRecordings.isEmpty && currentResult.wrappedName.isEmpty {
                viewContext.delete(currentResult)
            }
        }
        
        do {
            try viewContext.save()
            selectedResult = result
            resultName = result.wrappedName
            resultType = result.wrappedType
            timerIsActive = false
            updateResults()
        } catch {
            viewContext.rollback()
            print("Unable to set Result updated date: \(error)")
        }
    }
    
    func selectRecording(_ recording: Recording) {
        if self.selectedRecording == recording {
            selectedRecording = nil
        } else {
            selectedRecording = recording
        }
    }
    
    func appendPlateDigit(_ digit: Int) {
        guard digit < 10 && digit >= 0 else {
            return
        }
        if let selectedResult = self.selectedResult {
            if let selectedRecording = self.selectedRecording {
                var plate = selectedRecording.wrappedPlate
                
                if plate.count < 6 {
                    plate.append(String(digit))
                    selectedRecording.setValue(plate, forKey: "plate")
                    selectedResult.setValue(Double(Date().timeIntervalSince1970), forKey: "updatedDate")
                    
                    do {
                        try viewContext.save()
                        updateRecordings()
                        updateResults()
                    } catch {
                        viewContext.rollback()
                        print("Unable to append plate digit: \(error)")
                    }
                }
            }
        }
    }
    
    func deleteLastPlateDigit() {
        if let selectedRecording = self.selectedRecording {
            let plate = selectedRecording.wrappedPlate
            
            if plate.count > 0 {
                selectedRecording.setValue(String(plate.dropLast(1)), forKey: "plate")
                do {
                    try viewContext.save()
                    updateRecordings()
                } catch {
                    viewContext.rollback()
                    print("Unable to delete last plate digit: \(error)")
                }
            }
        }
    }
    
    // DELETE
    
    func deleteSelectedRecording() {
        if let selectedRecording = self.selectedRecording {
            viewContext.delete(selectedRecording)
            do {
                try viewContext.save()
                updateRecordings()
            } catch {
                viewContext.rollback()
                print("Unable to delete selected Recording: \(error)")
            }
        }
    }
    
    func deleteSelectedResult() {
        if let selectedResult = self.selectedResult {
            viewContext.delete(selectedResult)
            do {
                try viewContext.save()
                createResult()
            } catch {
                viewContext.rollback()
                print("Unable to delete selected Recording: \(error)")
            }
        }
    }
    
    func clearRecordings() {
        for recording in recordings {
            viewContext.delete(recording)
            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
                print("Unable to delete all results: \(error)")
            }
        }
        updateResults()
        updateRecordings()
    }
    
    func updateTime() {
        secondsSinceLastRecording += 1.0
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        let formattedString = formatter.string(from: TimeInterval(secondsSinceLastRecording)) ?? ""
        timeElapsedString = formattedString
    }
    
    func selectedResultIsEmpty() -> Bool {
        if selectedResult?.wrappedName.isEmpty ?? true && selectedResult?.wrappedRecordings.isEmpty ?? true {
            return true
        } else {
            return false
        }
    }
}
