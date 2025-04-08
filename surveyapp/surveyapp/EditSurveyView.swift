//
//  EditSurvey.swift
//  surveyapp
//
//  Created by Jillian Igoe on 4/6/25.
//
// EditSurveyView.swift
import SwiftUI

struct EditSurveyView: View {
    @Environment(\.dismiss) var dismiss

    var originalSurvey: Survey
    var onSave: (Survey) -> Void

    @State private var vesselName: String
    @State private var clientName: String
    @State private var location: String
    @State private var estimatedValue: String
    @State private var surveyDate: Date
    @State private var notes: String
    @State private var photos: [UIImage]
    @State private var showingImagePicker = false

    init(survey: Survey, onSave: @escaping (Survey) -> Void) {
        self.originalSurvey = survey
        self._vesselName = State(initialValue: survey.vesselName)
        self._clientName = State(initialValue: survey.clientName)
        self._location = State(initialValue: survey.location)
        self._estimatedValue = State(initialValue: survey.estimatedValue)
        self._surveyDate = State(initialValue: survey.surveyDate)
        self._notes = State(initialValue: survey.notes)
        self._photos = State(initialValue: survey.photoData.compactMap { UIImage(data: $0) })
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Vessel Info") {
                    TextField("Vessel Name", text: $vesselName)
                    TextField("Client Name", text: $clientName)
                    TextField("Location", text: $location)
                    TextField("Estimated Value", text: $estimatedValue)
                }

                Section("Survey Date") {
                    DatePicker("Date", selection: $surveyDate, displayedComponents: .date)
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }

                Section("Photos") {
                    PhotoGalleryView(images: $photos)

                    Button {
                        showingImagePicker = true
                    } label: {
                        Label("Add Photos", systemImage: "plus.circle")
                    }
                }
            }
            .navigationTitle("Edit Survey")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let imageData = photos.compactMap { $0.jpegData(compressionQuality: 0.8) }
                        let updatedSurvey = Survey(
                            id: originalSurvey.id,
                            vesselName: vesselName,
                            clientName: clientName,
                            location: location,
                            surveyDate: surveyDate,
                            estimatedValue: estimatedValue,
                            notes: notes,
                            photoData: imageData
                        )
                        onSave(updatedSurvey)
                        SurveyStorage.shared.save([updatedSurvey])
                        dismiss()
                    }
                }
            }
            .onChange(of: vesselName) { _ in autoSave() }
            .onChange(of: clientName) { _ in autoSave() }
            .onChange(of: location) { _ in autoSave() }
            .onChange(of: estimatedValue) { _ in autoSave() }
            .onChange(of: notes) { _ in autoSave() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(images: $photos)
            }
        }
    }

    func autoSave() {
        let updatedSurvey = Survey(
            id: originalSurvey.id,
            vesselName: vesselName,
            clientName: clientName,
            location: location,
            surveyDate: surveyDate,
            estimatedValue: estimatedValue,
            notes: notes,
            photoData: photos.compactMap { $0.jpegData(compressionQuality: 0.8) }
        )
        onSave(updatedSurvey)
        SurveyStorage.shared.save([updatedSurvey])
        print("🔄 Auto-saved: \(updatedSurvey.vesselName)")
    }
}
