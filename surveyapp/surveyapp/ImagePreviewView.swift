//
//  ImagePreviewView.swift
//  surveyapp
//
//  Created by Jillian Igoe on 4/7/25.
//
import SwiftUI

struct ImagePreviewView: View {
    let image: UIImage
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .padding()

            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}

