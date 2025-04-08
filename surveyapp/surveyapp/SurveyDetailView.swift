//
//  SurveyDetailView.swift
//  surveyapp
//
//  Created by Jillian Igoe on 4/6/25.
//
import SwiftUI

struct SurveyDetailView: View {
    @Binding var survey: Survey
    @State private var showingEditForm = false
    @State private var signatureImage: UIImage? = nil

    var body: some View {
        List {
            Section("Survey Info") {
                Text("Vessel: \(survey.vesselName)")
                Text("Client: \(survey.clientName)")
                Text("Location: \(survey.location)")
                Text("Estimated Value: \(survey.estimatedValue)")
                Text("Date: \(survey.surveyDate.formatted(date: .long, time: .omitted))")
            }

            Section("Notes") {
                Text(survey.notes.isEmpty ? "No notes provided." : survey.notes)
            }

            Section("Photos") {
                if survey.photoData.isEmpty {
                    Text("No photos uploaded.")
                } else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(survey.photoData, id: \.self) { data in
                                if let image = UIImage(data: data) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .shadow(radius: 2)
                                        .padding(.trailing, 5)
                                }
                            }
                        }
                    }
                }
            }

            Section("Signature") {
                SignatureView(signatureImage: $signatureImage)
                    .frame(width: 300, height: 150)
            }

            Section {
                Button(action: {
                    exportToPDF(survey: survey)
                }) {
                    Text("Export to PDF")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle(survey.vesselName)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditForm = true
                }
            }
        }
        .sheet(isPresented: $showingEditForm) {
            EditSurveyView(survey: survey) { updatedSurvey in
                survey = updatedSurvey
                SurveyStorage.shared.save([updatedSurvey])
            }
        }
    }

    func exportToPDF(survey: Survey) {
        print("📄 Export logic goes here for \(survey.vesselName)")
        // PDF export logic will be added next!
    }
}
