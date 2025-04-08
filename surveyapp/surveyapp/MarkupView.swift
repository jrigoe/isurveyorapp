//
//  MarkupView.swift
//  surveyapp
//
//  Created by Jillian Igoe on 4/7/25.
//
import SwiftUI
import PencilKit

struct MarkupView: UIViewControllerRepresentable {
    var baseImage: UIImage
    var onSave: (UIImage) -> Void

    func makeUIViewController(context: Context) -> PKCanvasViewController {
        let controller = PKCanvasViewController()
        controller.baseImage = baseImage
        controller.onSave = onSave
        return controller
    }

    func updateUIViewController(_ uiViewController: PKCanvasViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {}
}

// MARK: - Canvas ViewController
class PKCanvasViewController: UIViewController {
    var baseImage: UIImage!
    var onSave: ((UIImage) -> Void)?

    private let canvasView = PKCanvasView()
    private let toolPicker = PKToolPicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Show background image
        let backgroundImageView = UIImageView(image: baseImage)
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.frame = view.bounds
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(backgroundImageView)

        // Configure canvas
        canvasView.frame = view.bounds
        canvasView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        canvasView.backgroundColor = .clear
        canvasView.becomeFirstResponder()
        canvasView.drawingPolicy = .anyInput
        view.addSubview(canvasView)

        // Set up PencilKit tool picker
        if let window = view.window ?? UIApplication.shared.windows.first {
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
            canvasView.becomeFirstResponder()
        }

        // Add Save button
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.frame = CGRect(x: view.bounds.width - 80, y: 40, width: 60, height: 30)
        saveButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        saveButton.addTarget(self, action: #selector(saveMarkup), for: .touchUpInside)
        view.addSubview(saveButton)
    }

    @objc private func saveMarkup() {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let renderedImage = renderer.image { context in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }

        onSave?(renderedImage)
        dismiss(animated: true)
    }
}
