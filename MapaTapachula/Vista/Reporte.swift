//
//  SubirReporteView.swift
//  CameraTest
//
//  Created by ADMIN UNACH on 01/04/25.
//
import SwiftUI

let adress = "10.34.249.28"

struct Reporte: View {
    @State private var titulo: String = ""
    @State private var descripcion: String = ""
    @State private var capturedImage: UIImage?
    @State private var showCameraView: Bool = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading: Bool = false
    @State private var showSuccess: Bool = false
    
    @StateObject var locationManager = LocationManager()
    @State var direccion: String = ""
    @State var latitud: Double = 0.0
    @State var longitud: Double = 0.0
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                Text("Reporte de\nBasurero\nClandestino")
                    .font(.system(size: 40))
                    .fontWeight(.black)
                    .foregroundStyle(.verdeTierno)
                    .shadow(color: .white, radius: 5)
                    .offset(x: -50, y: 20)
                
                TitleField(title: "Título", text: $titulo, desc: "Ingresa un título...", focusedField: $focusedField, field: .titulo, nextfield: .descripcion).padding(.top)
                MultiField(
                    title: "Descripción",
                    text: $descripcion,
                    desc: "Ingresa una descripción...",
                    lines: 4,
                    currentField: .descripcion,
                    nextField: .direccion,
                    focusedField: $focusedField
                )
                MultiField(
                    title: "Dirección",
                    text: $direccion,
                    desc: "Espera o Ingresa dirección...",
                    lines: 4,
                    currentField: .direccion,
                    nextField: nil,
                    focusedField: $focusedField
                )
                
                // Mostrar imagen capturada o botón para tomar foto
                if let image = capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .cornerRadius(12)
                        .overlay(
                            Button {
                                showCameraView = true
                            } label: {
                                Image(systemName: "camera")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .clipShape(Circle())
                            },
                            alignment: .topTrailing
                        )
                        .shadow(radius: 5)
                } else {
                    Image("imagenReporte")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .onTapGesture {
                            showCameraView = true
                        }
                        .shadow(radius: 5)
                }
                
                Button {
                    guard !titulo.isEmpty else {
                            alertMessage = "Por favor ingresa un título"
                            showAlert = true
                            return
                        }
                        
                        guard !descripcion.isEmpty else {
                            alertMessage = "Por favor ingresa una descripción"
                            showAlert = true
                            return
                        }
                        
                        guard capturedImage != nil else {
                            alertMessage = "Debes tomar una fotografía del basurero"
                            showAlert = true
                            return
                        }
                    
                    Task {
                        await generarReporte()
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 250, height: 60)
                        .foregroundStyle(Color.red)
                        .shadow(color: .white, radius: 5)
                        .overlay {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Generar Reporte")
                                    .font(.custom("Montserrat", size: 23))
                                    .bold()
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(.bottom)
                }
                .disabled(isLoading)
                .alert("Atención", isPresented: $showAlert) {
                    Button("Entendido", role: .cancel) { }
                } message: {
                    Text(alertMessage)
                }
            }
        }
        .fullScreenCover(isPresented: $showCameraView) {
            CameraView(camera: CameraModel(), capturedImage: $capturedImage)
        }
        .alert("Reporte enviado", isPresented: $showSuccess) {
            Button("OK", role: .cancel) {
                // Resetear el formulario
                titulo = ""
                descripcion = ""
                direccion = ""
                capturedImage = nil
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
        .onChange(of: locationManager.address) { old, newAddress in
            if !newAddress.isEmpty {
                direccion = newAddress
                latitud = locationManager.latitude
                longitud = locationManager.longitude
            }
        }
    }
    
    private func generarReporte() async {
        isLoading = true
        
        do {
            // 1. Subir la imagen
            let imageName = try await subirImagen()
            
            // 2. Subir el reporte
            try await subirReporte(nombreImagen: imageName)
            
            // Mostrar éxito
            showSuccess = true
        } catch {
            print("Error al generar reporte: \(error.localizedDescription)")
            // Mostrar error al usuario
        }
        
        isLoading = false
    }
    
    private func subirImagen() async throws -> String {
        guard let image = capturedImage,
              let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw NSError(domain: "Imagen no válida", code: 0)
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "http://\(adress):8080/reporte/imagen")!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        let filename = "\(UUID().uuidString).jpg"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"imagen\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return filename
    }
    
    private func subirReporte(nombreImagen: String) async throws {
        let reporte = ReporteS(
            titulo: titulo,
            descripcion: descripcion,
            direccion: direccion,
            latitud: latitud,
            longitud: longitud,
            fecha: nil,
            nombreImagen: nombreImagen
        )
        
        var request = URLRequest(url: URL(string: "http://\(adress):8080/reporte")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(reporte)
        
        _ = try await URLSession.shared.data(for: request)
    }
}



private struct TitleField: View {
    let title: String
    @Binding var text: String
    let desc: String
    @FocusState.Binding var focusedField: Field?
    let field: Field
    let nextfield: Field
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.black)
            TextField(desc, text: $text, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .font(.title2)
                .frame(width: 365)
                .background(.clear).shadow(radius: 5)
                .focused($focusedField, equals: field)
                .submitLabel(.next)
                .onSubmit {
                    if !(nextfield == .none){
                        focusedField = nextfield
                    }
                    else {focusedField = nil}
                }
            
        }
    }
}


private struct MultiField: View {
    let title: String
    @Binding var text: String
    let desc: String
    let lines: Int
    let currentField: Field
    let nextField: Field?
    @FocusState.Binding var focusedField: Field?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.black)
            
            TextField(desc, text: $text, axis: .vertical)
                .lineLimit(lines, reservesSpace: true)
                .textFieldStyle(.roundedBorder)
                .font(.title2)
                .frame(width: 365)
                .shadow(radius: 0)
                .background(.clear)
                .shadow(radius: 5)
                .focused($focusedField, equals: currentField)
                .submitLabel(.done)
                .onSubmit {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Listo") {
                                focusedField = nil
                        }
                    }
                }
        }
    }
}



struct ReporteS: Codable {
    var titulo: String
    var descripcion: String
    var direccion: String
    var latitud: Double
    var longitud: Double
    var fecha: String?
    var nombreImagen: String
}

#Preview {
    Reporte()
}

private enum Field {
        case titulo, descripcion, direccion, none
    }
