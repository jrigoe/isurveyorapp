//
//  NewSurveyView.swift
//  surveyapp
//
//  Created by Jillian Igoe on 4/6/25.
//
import SwiftUI

struct NewSurveyView: View {
    @Environment(\.dismiss) var dismiss

    @State private var vesselName = ""
    @State private var clientName = ""
    @State private var location = ""
    @State private var estimatedValue = ""
    @State private var surveyDate = Date()
    @State private var notes = ""
    @State private var photos: [UIImage] = []
    @State private var showingImagePicker = false

    var onSave: (Survey) -> Void

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
            .navigationTitle("New Survey")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let imageData = photos.compactMap { $0.jpegData(compressionQuality: 0.8) }
                        let newSurvey = Survey(
                            vesselName: vesselName,
                            clientName: clientName,
                            location: location,
                            surveyDate: surveyDate,
                            estimatedValue: estimatedValue,
                            notes: notes,
                            photoData: imageData
                        )
                        onSave(newSurvey)
                        SurveyStorage.shared.save([newSurvey])
                        dismiss()
                    }
                    .disabled(vesselName.isEmpty || clientName.isEmpty)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(images: $photos)
            }
        }
    }
}
