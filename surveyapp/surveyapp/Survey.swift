//
//  Survey.swift
//  surveyapp
//
//  Created by Jillian Igoe on 4/6/25.
//

// Survey.swift
import Foundation

struct Survey: Identifiable, Codable {
    let id: UUID
    var vesselName: String
    var clientName: String
    var location: String
    var surveyDate: Date
    var estimatedValue: String
    var notes: String
    var photoData: [Data]

    init(
        id: UUID = UUID(),
        vesselName: String,
        clientName: String,
        location: String,
        surveyDate: Date,
        estimatedValue: String,
        notes: String = "",
        photoData: [Data] = []
    ) {
        self.id = id
        self.vesselName = vesselName
        self.clientName = clientName
        self.location = location
        self.surveyDate = surveyDate
        self.estimatedValue = estimatedValue
        self.notes = notes
        self.photoData = photoData
    }
}
