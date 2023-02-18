//
//  ImportSheetViewModel.swift
//  Race Timer
//
//  Created by niko dittmar on 2/17/23.
//

import Foundation

extension ContentViewViewModel {
    func importStageResult(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(StageResult.self, from: data)
                importedStageResult = result
                presentingMenuSheet = false
                presentingImportSheet = true
            } catch {
                presentingImportErrorWarning = true
            }
        } catch {
            if url.startAccessingSecurityScopedResource() {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(StageResult.self, from: data)
                        importedStageResult = result
                        presentingMenuSheet = false
                        presentingImportSheet = true
                    } catch {
                        presentingImportErrorWarning = true
                    }
                } catch {
                    presentingImportErrorWarning = true
                }
            } else {
                presentingImportErrorWarning = true
            }
            
            url.stopAccessingSecurityScopedResource()
        }
    }
    
    func importStageName() -> String {
        return importedStageResult?.name ?? ""
    }
    
    func importStageResultType() -> String {
        if importedStageResult?.start == true {
            return "Stage Start"
        } else if importedStageResult?.start == false {
            return "Stage End"
        } else {
            return ""
        }
    }
    
    func importStageRecordingsList() -> [Recording] {
        return importedStageResult?.recordings ?? []
    }
    
    func importRecordingTimeString(double: Double) -> String {
        let date: Date = Date(timeIntervalSince1970: double)
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss.SS"
        
        return dateFormatter.string(from: date)
    }
    
    func addStageResultToCoreData() {
        var timingMode: TimingMode = .finish
        if importedStageResult?.start == true {
            timingMode = .start
        }
        if timingResultSet.unwrappedName.isEmpty && timingResultSet.resultArray.isEmpty {
            //If the current timing set is empty, populate it with imported data.
            coreDM.setTimingResultName(timingResultSet, name: importedStageResult?.name ?? "")
            coreDM.setTimingResultType(timingResultSet, timingMode: timingMode)
            coreDM.bulkCreateResults(timingResult: timingResultSet, recordings: importedStageResult?.recordings ?? [])
        } else {
            //Make a new timing result set.
            coreDM.createFullTimingResult(mode: timingMode, name: importedStageResult?.name ?? "", recordings: importedStageResult?.recordings ?? [])
        }

        
        syncResults()
    }
}
