//
//  ContentView.swift
//  FridgeRecipeFinder
//
//  Created by Ezra Akresh on 12/3/24.
//

import SwiftUI
import AVKit

struct ScannerView: View {
    /// View Controller Properties
    @Binding var showScanner: Bool
    /// Bar Code Scanner Properties
    @State private var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var cameraPermission: Permission = .idle
    /// Bar Code Scanner AV Output
    @State private var barcodeOutput: AVCaptureMetadataOutput = .init()
    /// Error Properties
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @Environment(\.openURL) private var openURL
    /// Camera Barcode Output Delegate
    @StateObject private var barcodeDelegate = BarcodeScannerDelegate()
    /// Scanned Code
    @State private var scannedCode: String = ""
    var body: some View {
        VStack(spacing: 8) {
            Button {
                /// Close ScannerView
                session.stopRunning()
                showScanner = false
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(Color("BlueishPurple"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Place the barcode inside the frame")
                .font(.title3)
                .foregroundColor(.black.opacity(0.8))
                .padding(.top, 20)
            
            Text("Scanning will start automatically")
                .font(.callout)
                .foregroundColor(.gray)
            
            Spacer(minLength: 0)
            
            /// Scanner
            
            GeometryReader {
                let size = $0.size
                
                ZStack {
                    CameraView(frameSize: CGSize(width: size.width, height: size.width), session: $session)
                        .scaleEffect(0.97)
                    
                    ForEach(0...4, id: \.self) { index in
                        let rotation = Double(index) * 90
                        RoundedRectangle(cornerRadius: 2, style: .circular)
                        /// Trimming to get Scanner like Edges
                            .trim(from: 0.61, to: 0.64)
                            .stroke(Color("BlueishPurple"), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.init(degrees: rotation))
                    }
                }
                /// Square Shape
                .frame(width: size.width, height: size.width)
                /// Scanner Animation
                .overlay(alignment: .top, content: {
                    Rectangle()
                        .fill(Color("BlueishPurple"))
                        .frame(height: 2.5)
                        .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: isScanning ? 15 : -15)
                        .offset(y: isScanning ? size.width : 0)
                })
                /// To Make it Center
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 45)
            
            Spacer(minLength: 15)
            
            Button {
                if !session.isRunning && cameraPermission == .approved {
                    reactivateCamera()
                    activateScannerAnimation()
                }
            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
            
            Spacer(minLength: 45)
        }
        .padding(15)
        /// Checking Camera Permission, when the View is Visible
        .onAppear(perform: checkCameraPermission)
        .alert(errorMessage, isPresented: $showError) {
            /// Showing Setting's Button, if permission is denied
            if cameraPermission == .denied {
                Button("Settings") {
                    let settingsString = UIApplication.openSettingsURLString
                    if let settingsURL = URL(string: settingsString) {
                        /// Opening App's Settings, Using OpenURL SwiftUI API
                        openURL(settingsURL)
                    }
                }
                
                /// Along with Cancel Button
                Button("Cancel", role: .cancel) {}
            }
            
        }
        .onChange(of: barcodeDelegate.scannedCode) { newValue in
            if let code = newValue {
                scannedCode = code
                /// When the first scan is available, immediately stop the camera
                session.stopRunning()
                deactivateScannerAnimation()
                barcodeDelegate.scannedCode = nil
                showScanner = false
            }
        }
        .onDisappear {
            session.stopRunning()
        }
    }
    
    func reactivateCamera() {
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
    
    /// Activating Scanner Animation Method
    func activateScannerAnimation() {
        /// Adding Delay for Each Reversal
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
    
    /// Deactivating Scanner Animation Method
    func deactivateScannerAnimation() {
        /// Adding Delay for Each Reversal
        withAnimation(.easeInOut(duration: 0.85)) {
            isScanning = false
        }
    }
    
    /// Setting Up Camera
    func setupCamera() {
        do {
            /// Finding Back Camera
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInUltraWideCamera, .builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentError("UNKNOWN DEVICE ERROR")
                return
            }
            
            /// Camera Input
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(barcodeOutput) else {
                presentError("UNKNOWN INPUT/OUTPUT ERROR")
                return
            }
            
            /// Adding Input & Output to Camera Session
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(barcodeOutput)
            
            barcodeOutput.metadataObjectTypes = [
                .ean8,
                .ean13,
                .upce,
                .code128,
                .qr,
                .pdf417
            ]
            barcodeOutput.setMetadataObjectsDelegate(barcodeDelegate, queue: .main)
            session.commitConfiguration()
            /// Note: Session must be started on Background Thread
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            activateScannerAnimation()
            
        } catch {
            presentError(error.localizedDescription)
        }
    }
    
    /// Checking Camera Permission
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                cameraPermission = .approved
                if session.inputs.isEmpty {
                    /// New Setup
                    setupCamera()
                } else {
                    /// Already Existing One
                    reactivateCamera()
                }
            case .notDetermined:
                /// Request Camera Access
                if await AVCaptureDevice.requestAccess(for: .video) {
                    /// Permission Granted
                    cameraPermission = .approved
                    setupCamera()
                } else {
                    /// Permission Denied
                    cameraPermission = .denied
                    /// Presenting Error Message
                    presentError("Please Provide Access to Camera for scanning codes")
                }
            case .denied, .restricted:
                cameraPermission = .denied
                presentError("Please Provide Access to Camera for scanning codes")
            default: break
            }
        }
    }
    
    func presentError(_ message: String) {
        errorMessage = message
        showError.toggle()
    }
}

#Preview {
    ContentView()
}
