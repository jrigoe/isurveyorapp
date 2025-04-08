//
//  SignatureView.swift
//  surveyapp
//
//  Created by Jillian Igoe on 4/6/25.
//
import SwiftUI

struct SignatureView: View {
    @Binding var signatureImage: UIImage?

    @State private var path = Path()
    @State private var lastPoint: CGPoint?

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .border(Color.gray, width: 1)
                    .frame(width: 300, height: 150)
                
                PathView(path: $path)
                    .frame(width: 300, height: 150)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if let last = lastPoint {
                                path.addLine(to: value.location)
                            } else {
                                path.move(to: value.location)
                            }
                            lastPoint = value.location
                        }
                        .onEnded { _ in
                            lastPoint = nil
                        }
                    )
            }

            HStack {
                Button("Clear") {
                    path = Path()
                    signatureImage = nil
                }
                Spacer()
                Button("Save Signature") {
                    signatureImage = signatureImageFromPath(path)
                }
            }
            .padding(.horizontal)
        }
    }

    private func signatureImageFromPath(_ path: Path) -> UIImage {
        let size = CGSize(width: 300, height: 150)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            UIColor.black.setStroke()
            path.stroke()
        }
    }
}

struct PathView: View {
    @Binding var path: Path

    var body: some View {
        path
            .stroke(Color.black, lineWidth: 2)
    }
}
