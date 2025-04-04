//
//  CameraView.swift
//  CameraTest
//
//  Created by ADMIN UNACH on 01/04/25.
//
import SwiftUI
import AVFoundation

struct CameraView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var camera: CameraModel
    @Binding var capturedImage: UIImage?
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                if camera.isTaken {
                    HStack {
                        Spacer()
                        Button(action: camera.reTake) {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 10)
                    }
                }
                
                Spacer()
                
                HStack {
                    if camera.isTaken {
                        Button("Confirmar") {
                            // Guardar la imagen y regresar
                            if !camera.picData.isEmpty {
                                    capturedImage = UIImage(data: camera.picData)
                                }
                                dismiss()
                        }
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .padding(.leading)
                        
                        Spacer()
                    } else {
                        Button(action: camera.takePic) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        }
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear(perform: camera.Check)
    }
}



class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var picData = Data(count: 0)
    
    func Check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { status in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func setUp() {
        do {
            self.session.beginConfiguration()
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func takePic() {
        let settings = AVCapturePhotoSettings()
        DispatchQueue.global(qos: .userInitiated).async {
            self.output.capturePhoto(with: settings, delegate: self)
        }
    }
    
    func reTake() {
        DispatchQueue.main.async {
            self.session.startRunning()
            withAnimation {
                self.isTaken = false
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil, let imageData = photo.fileDataRepresentation() else {
            print("Error al procesar la foto: \(error?.localizedDescription ?? "Desconocido")")
            return
        }
        
        DispatchQueue.main.async {
            self.picData = imageData
            self.session.stopRunning()
            withAnimation {
                self.isTaken = true
            }
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
