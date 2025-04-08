//
//  ContenView.swift
//  surveyapp
//
//  Created by Jillian Igoe on 4/6/25.
//
import SwiftUI

// MARK: - Main Survey List View

struct MainSurveyView: View {

    @State private var surveys = [
        Survey(vesselName: "Endeavour", clientName: "Captain Nemo", location: "Woods Hole, MA", surveyDate: Date(), estimatedValue: "$125,000", notes: "Test notes", photoData: []),
        Survey(vesselName: "Sea Breeze", clientName: "Jill Igoe", location: "Falmouth, MA", surveyDate: Date(), estimatedValue: "$87,000", notes: "Test notes", photoData: []),
        Survey(vesselName: "Ocean Star", clientName: "Loretta R.", location: "Nantucket, MA", surveyDate: Date(), estimatedValue: "$112,500", notes: "Test notes", photoData: [])
    ]

    @State private var showingAddForm = false // for the sheet

    var body: some View {
        NavigationStack {
            List {
                ForEach(surveys) { survey in
                    if let index = surveys.firstIndex(where: { $0.id == survey.id }) {
                        NavigationLink(destination: SurveyDetailView(survey: $surveys[index])) {
                            surveyRow(for: survey)
                        }
                    }
                }
            }
            .navigationTitle("Welcome to iSurveyor")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Add New Survey (Form)") {
                            showingAddForm = true
                        }
                        Button("Quick Add Survey") {
                            addNewSurvey()
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddForm) {
                NewSurveyView { newSurvey in
                    surveys.append(newSurvey)
                    SurveyStorage.shared.save(surveys) // auto-save after new survey is added
                }
            }
        }
    }

    // MARK: - Survey Row View

    func surveyRow(for survey: Survey) -> some View {
        VStack(alignment: .leading) {
            Text(survey.vesselName).font(.headline)
            Text("Client: \(survey.clientName)").font(.subheadline)
            Text(survey.surveyDate.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Quick Add Survey

    func addNewSurvey() {
        let newSurvey = Survey(
            vesselName: "New Vessel",
            clientName: "New Client",
            location: "Unknown",
            surveyDate: Date(),
            estimatedValue: "$0.00",
            notes: "",
            photoData: []
        )
        surveys.append(newSurvey)
        SurveyStorage.shared.save(surveys) // auto-save after quick add
    }
}
