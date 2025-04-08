//
//  PhotoGalleryView.swift
//  surveyapp
//
//  Created by Jillian Igoe on 4/7/25.
//
import SwiftUI

struct PhotoGalleryView: View {
    @Binding var images: [UIImage]
    @State private var selectedImage: UIImage?
    @State private var showingPreview = false
    @State private var showingMarkup = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(images.indices, id: \.self) { index in
                    Image(uiImage: images[index])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 2)
                        .contextMenu {
                            Button("Annotate") {
                                selectedImage = images[index]
                                showingMarkup = true
                            }
                            Button("Delete", role: .destructive) {
                                images.remove(at: index)
                            }
                        }
                        .onTapGesture {
                            selectedImage = images[index]
                            showingPreview = true
                        }
                }
            }
        }
        .sheet(isPresented: $showingPreview) {
            if let selected = selectedImage {
                ImagePreviewView(image: selected)
            }
        }
        .sheet(isPresented: $showingMarkup) {
            if let selected = selectedImage {
                MarkupView(baseImage: selected) { editedImage in
                    if let index = images.firstIndex(of: selected) {
                        images[index] = editedImage
                    }
                }
            }
        }
    }
}
