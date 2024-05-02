//
//  ImagePickerView.swift
//  NC1_TIMCooker
//
//  Created by Eldenabih Tavirazin Lutvie on 29/04/24.
//

import SwiftUI

import AVFoundation

struct ImagePickerView: View {
    @Binding var image: UIImage?
    @Binding var showCamera: Bool

    var body: some View {
        CameraView(image: $image, showCamera: $showCamera)
            .edgesIgnoringSafeArea(.all)
    }
    
    static func checkPermissionsAndOpenCamera(showCamera: Bool, completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { success in
            if success {
                completion(true)
            } else {
                print("Camera access denied")
                completion(false)
            }
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var showCamera: Bool

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.showCamera = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showCamera = false
        }
    }
}
