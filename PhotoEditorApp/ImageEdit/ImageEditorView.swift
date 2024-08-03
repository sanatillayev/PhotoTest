//
//  ImageEditorView.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 30/07/24.
//

import SwiftUI
import PencilKit

struct ImageEditorView: View {
    @StateObject var viewModel = ImageEditorViewModel()
    @State private var showingImagePicker = false
    @State private var isAlertPresenting = false
    @State private var isDrawingEnabled = false

    var body: some View {
        VStack(spacing: 24) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        PKCanvasRepresentation(canvasView: viewModel.canvasView)
                            .opacity(isDrawingEnabled ? 1.0 : 0.0)
                    )
            } else {
                Text("No Image Selected")
            }

            HStack(spacing: 16) {
                Button(action: {
                    viewModel.loadImage(from: .photoLibrary)
                }) {
                    Text("Select Image")
                }

                Button(action: {
                    viewModel.saveDrawing()
                }) {
                    Text("Save Image")
                }
            }

            Toggle("Enable Drawing", isOn: $isDrawingEnabled)
                .padding()
        }
        .padding(.vertical, 40)
        .padding(.horizontal, 16)
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { selectedImage in
                viewModel.image = selectedImage
            }
        }
        .alert(isPresented: $isAlertPresenting) {
            Alert(title: Text("Error"), message: Text(viewModel.error ?? ""))
        }
    }
}

struct PKCanvasRepresentation: UIViewRepresentable {
    var canvasView: PKCanvasView

    func makeUIView(context: Context) -> PKCanvasView {
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}

struct ImagePickerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    var sourceType: UIImagePickerController.SourceType
    var completionHandler: (UIImage) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(completionHandler: completionHandler)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let completionHandler: (UIImage) -> Void

        init(completionHandler: @escaping (UIImage) -> Void) {
            self.completionHandler = completionHandler
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                completionHandler(selectedImage)
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
