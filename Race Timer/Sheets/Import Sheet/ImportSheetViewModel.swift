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
}
