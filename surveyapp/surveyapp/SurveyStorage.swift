//
//  SurveyStorage.swift
//  surveyapp
//
//  Created by Jillian Igoe on 4/6/25.
//
import Foundation

// MARK: - Survey Storage Helper

class SurveyStorage {
    static let shared = SurveyStorage()
    private let filename = "surveys.json"

    // File URL to save the data
    private var fileURL: URL {
        let manager = FileManager.default
        let documents = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent(filename)
    }

    // Save surveys to disk
    func save(_ surveys: [Survey]) {
        do {
            let data = try JSONEncoder().encode(surveys)
            try data.write(to: fileURL)
            print("✅ Surveys saved to disk")
        } catch {
            print("❌ Failed to save surveys:", error)
        }
    }

    // Load surveys from disk
    func load() -> [Survey] {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode([Survey].self, from: data)
            print("📂 Surveys loaded from disk")
            return decoded
        } catch {
            print("⚠️ No saved surveys found (or failed to load)")
            return []
        }
    }
}

