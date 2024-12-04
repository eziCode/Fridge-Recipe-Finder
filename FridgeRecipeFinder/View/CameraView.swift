//
//  CameraView.swift
//  FridgeRecipeFinder
//
//  Created by Ezra Akresh on 12/3/24.
//

import SwiftUI
import AVKit

struct CameraView: UIViewRepresentable {
    var frameSize: CGSize
    @Binding var session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        /// Defining Camera Frame
        let view = UIViewType(frame: CGRect(origin: .zero, size: frameSize))
        view.backgroundColor = .clear
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.frame = .init(origin: .zero, size: frameSize)
        cameraLayer.videoGravity = .resizeAspectFill
        cameraLayer.masksToBounds = true
        view.layer.addSublayer(cameraLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard uiView.frame.size != frameSize else { return }
        uiView.frame.size = frameSize

        if let cameraLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            cameraLayer.frame = CGRect(origin: .zero, size: frameSize)
        }
    }
}
