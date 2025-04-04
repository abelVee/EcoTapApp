import SwiftUI
import AVFoundation
import SafariServices

// MARK: - Barcode Scanner View
struct BarcodeScannerView: UIViewControllerRepresentable {
    @Binding var scannedCode: String?
    @Binding var scannedType: String?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        let viewController = ScannerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ScannerDelegate {
        var parent: BarcodeScannerView
        
        init(_ parent: BarcodeScannerView) {
            self.parent = parent
        }
        
        func didFindCode(_ code: String, type: String) {
            parent.scannedCode = code
            parent.scannedType = type
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func didFailWithError(_ error: Error) {
            print("Scanner error: \(error.localizedDescription)")
        }
    }
}

// MARK: - Scanner Protocol
protocol ScannerDelegate: AnyObject {
    func didFindCode(_ code: String, type: String)
    func didFailWithError(_ error: Error)
}

// MARK: - Scanner View Controller
class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    weak var delegate: ScannerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            delegate?.didFailWithError(NSError(domain: "Camera not found", code: -1))
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            delegate?.didFailWithError(error)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            delegate?.didFailWithError(NSError(domain: "Cannot add camera input", code: -2))
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean13, .ean8, .code128, .upce, .pdf417]
            
            // Mejorar detección
            metadataOutput.rectOfInterest = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        } else {
            delegate?.didFailWithError(NSError(domain: "Cannot setup scanner", code: -3))
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // Marco de enfoque
        addFocusFrame()
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    private func addFocusFrame() {
        let focusFrame = UIView()
        focusFrame.layer.borderColor = UIColor.green.cgColor
        focusFrame.layer.borderWidth = 2
        focusFrame.frame = CGRect(x: view.center.x - 100, y: view.center.y - 100, width: 200, height: 200)
        view.addSubview(focusFrame)
        
        // Animación
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            focusFrame.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let code = readableObject.stringValue else { return }
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            let type: String
            switch readableObject.type {
            case .qr: type = "QR"
            case .ean13: type = "EAN13"
            case .ean8: type = "EAN8"
            case .code128: type = "CODE128"
            case .upce: type = "UPC-E"
            case .pdf417: type = "PDF417"
            default: type = "OTHER"
            }
            
            delegate?.didFindCode(code, type: type)
        }
    }
}

// MARK: - Main Content View
struct ContentScanner: View {
    @State private var showScanner = false
    @State private var scannedCode: String?
    @State private var scannedType: String?
    @State private var scannedMaterial: MaterialType?
    @State private var showingSafariView = false
    
    enum MaterialType: String, CaseIterable {
        case plastic, glass, paper, aluminum, copper, other
        
        var icon: String {
            switch self {
            case .plastic: return "molecule"
            case .glass: return "cube.transparent"
            case .paper: return "newspaper"
            case .aluminum: return "cylinder"
            case .copper: return "bolt"
            case .other: return "questionmark.circle"
            }
        }
        
        var color: Color {
            switch self {
            case .plastic: return .blue
            case .glass: return .green
            case .paper: return .brown
            case .aluminum: return .gray
            case .copper: return .orange
            case .other: return .purple
            }
        }
        
        var impactDescription: String {
            switch self {
            case .plastic:
                return """
                🚯 Impacto en la ciudad:
                - Tarda 450 años en degradarse
                - Contamina ríos y océanos
                - Puede obstruir desagües causando inundaciones
                ♻ Reciclaje: Contenedor amarillo
                """
                
            case .glass:
                return """
                🚯 Impacto en la ciudad:
                - No se degrada naturalmente
                - Puede causar incendios al concentrar luz solar
                - Heridas a personas y animales
                ♻ Reciclaje: Contenedor verde (sin tapas metálicas)
                """
                
            case .paper:
                return """
                🚯 Impacto en la ciudad:
                - Su producción deforesta bosques
                - En vertederos produce metano
                - Tinta contamina suelos
                ♻ Reciclaje: Contenedor azul (sin manchas de grasa)
                """
                
            case .aluminum:
                return """
                🚯 Impacto en la ciudad:
                - Minería destruye ecosistemas
                - Producción consume mucha energía
                - Puede acumular agua y criar mosquitos
                ♻ Reciclaje: Contenedor amarillo (limpiar antes)
                """
                
            case .copper:
                return """
                🚯 Impacto en la ciudad:
                - Minería altamente contaminante
                - Oxidación contamina suelos
                - Puede ser robado afectando infraestructura
                ♻ Reciclaje: Punto limpio especializado
                """
                
            case .other:
                return """
                ℹ Consejo:
                Consulta en tu municipio el punto limpio más cercano.
                Los residuos no identificados pueden contaminar:
                - Suelos
                - Aguas subterráneas
                - Aire por quema incontrolada
                """
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 5) {
                HeaderView()
                
                if scannedType == "QR" {
                    QRResultView(code: scannedCode ?? "", showingSafariView: $showingSafariView)
                } else if let material = scannedMaterial {
                    ProductResultView(material: material, code: scannedCode ?? "")
                } else {
                    EmptyStateView()
                }
                
                Spacer()
                
                ScanButton(action: {
                    showScanner = true
                    scannedMaterial = nil
                    scannedCode = nil
                    scannedType = nil
                })
            }
            .padding(.top, 60)
        }
        .sheet(isPresented: $showScanner) {
            BarcodeScannerView(scannedCode: $scannedCode, scannedType: $scannedType)
                .onDisappear {
                    if let code = scannedCode, let type = scannedType {
                        processScannedCode(code: code, type: type)
                    }
                }
        }
        .sheet(isPresented: $showingSafariView) {
            if let url = URL(string: scannedCode ?? "") {
                SafariView(url: url)
            }
        }
    }
    
    func processScannedCode(code: String, type: String) {
        if type == "QR" {
            return // Solo procesamos códigos de barras para materiales
        }
        
        let cleanCode = code.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        // Base de datos ampliada de productos conocidos
        let knownProducts: [String: MaterialType] = [
            "7501055310883": .plastic,
            "75007614": .plastic,
            "750076140003": .plastic,
            "750104531012": .glass,
            "500533003880": .plastic,  // Botella de agua purificadora
            "500015940739": .plastic,  // Coca-Cola
            "500011263422": .plastic,  // Pepsi
            "400053803880": .plastic, // Ejemplo adicional
            "800512000123": .glass     // Ejemplo de vidrio
        ]
        
        // Primero verificamos si el código completo está en la base de datos
        if let material = knownProducts[cleanCode] {
            scannedMaterial = material
            return
        }
        
        // Lógica mejorada para códigos no registrados
        switch cleanCode.prefix(3) {
        case "500", "501", "502", "503", "504", "505", "506", "507", "508", "509":
            // Códigos que comienzan con 500-509 son típicamente del Reino Unido
            // Muchos productos de bebidas en estos códigos son plásticos
            scannedMaterial = .plastic
            
        case "750":
            // Códigos mexicanos
            if cleanCode.hasPrefix("750076") { scannedMaterial = .plastic }
            else if cleanCode.hasPrefix("750105") { scannedMaterial = .plastic }
            else if cleanCode.hasPrefix("750104") { scannedMaterial = .glass }
            else { scannedMaterial = .plastic } // Por defecto plástico para códigos mexicanos
            
        case "40"..."49":
            // Códigos que comienzan con 40-49 son típicamente de Alemania
            scannedMaterial = .plastic
            
        case "20"..."29":
            // Códigos que comienzan con 20-29 son típicamente envases de vidrio
            scannedMaterial = .glass
            
        case "690"..."699":
            // Códigos chinos - muchos son plásticos
            scannedMaterial = .plastic
            
        default:
            // Para otros casos, verificamos la longitud del código
            if cleanCode.count == 8 || cleanCode.count == 12 || cleanCode.count == 13 {
                // Si tiene formato estándar de código de barras, asumimos plástico (el más común)
                scannedMaterial = .plastic
            } else {
                scannedMaterial = .other
            }
        }
    }
}

// MARK: - Impact Details View
struct ImpactDetailsView: View {
    let impact: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                Text("IMPACTO EN LA CIUDAD")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.red)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                let parts = impact.components(separatedBy: "\n")
                ForEach(parts, id: \.self) { part in
                    if part.contains("🚯") {
                        Text(part)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .padding(.top, 4)
                    } else if part.contains("♻") {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "arrow.3.trianglepath")
                                .foregroundColor(.green)
                            Text(part)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        .padding(.top, 8)
                    } else if part.contains("ℹ") {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                            Text(part)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        .padding(.top, 8)
                    } else {
                        HStack(alignment: .top, spacing: 8) {
                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundColor(.gray)
                                .padding(.top, 6)
                            Text(part)
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
            )
        }
    }
}

// MARK: - Recycling Tips View
struct RecyclingTipsView: View {
    let material: ContentScanner.MaterialType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "arrow.3.trianglepath")
                    .foregroundColor(.green)
                Text("CÓMO RECICLAR CORRECTAMENTE")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.green)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                let tips = recyclingTips(for: material)
                ForEach(tips.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 24, height: 24)
                            Text("\(index + 1)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.green)
                        }
                        
                        Text(tips[index])
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
            )
        }
    }
    
    func recyclingTips(for material: ContentScanner.MaterialType) -> [String] {
        switch material {
        case .plastic:
            return [
                "Limpia los envases antes de reciclarlos para evitar contaminación",
                "Separa las tapas de los envases, ya que suelen ser de diferente material",
                "Compacta las botellas para ahorrar espacio en el contenedor"
            ]
        case .glass:
            return [
                "No mezcles vidrio con cristal (como vasos o ventanas), tienen composiciones diferentes",
                "Retira las tapas metálicas antes de depositar el vidrio",
                "No introduzcas vidrio roto en bolsas, deposítalo directamente"
            ]
        case .paper:
            return [
                "No recicles papel manchado de grasa o comida (va al orgánico)",
                "Retira los elementos plásticos como ventanillas de sobres",
                "No es necesario quitar las grapas o clips pequeños"
            ]
        case .aluminum:
            return [
                "Limpia las latas de alimentos antes de reciclarlas",
                "Puedes compactar las latas para ahorrar espacio",
                "Las bandejas de aluminio deben estar limpias"
            ]
        case .copper:
            return [
                "Acumula cables y piezas en un lugar seguro hasta llevarlos a reciclar",
                "Los centros de reciclaje pagan por cobre limpio y bien separado",
                "Nunca quemes cables para extraer cobre, libera toxinas peligrosas"
            ]
        case .other:
            return [
                "Consulta en tu municipio los puntos limpios disponibles",
                "Para electrónicos, busca centros de reciclaje especializados",
                "Separa los componentes cuando sea posible (baterías, plásticos, metales)"
            ]
        }
    }
}

// MARK: - Fun Facts View
struct FunFactsView: View {
    let material: ContentScanner.MaterialType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.orange)
                Text("DATOS CURIOSOS")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.orange)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                let facts = funFacts(for: material)
                ForEach(facts.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "sparkles")
                            .foregroundColor(.yellow)
                        
                        Text(facts[index])
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
            )
        }
    }
    
    func funFacts(for material: ContentScanner.MaterialType) -> [String] {
        switch material {
        case .plastic:
            return [
                "Reciclar una botella de plástico puede ahorrar energía suficiente para mantener encendida una bombilla de 60W durante 3 horas",
                "El plástico en el océano mata más de 1 millón de animales marinos cada año",
                "Una bolsa de plástico tarda hasta 400 años en degradarse"
            ]
        case .glass:
            return [
                "El vidrio se puede reciclar infinitamente sin perder calidad",
                "Reciclar vidrio ahorra un 30% de energía comparado con producirlo nuevo",
                "Una botella de vidrio tarda aproximadamente 4,000 años en descomponerse"
            ]
        case .paper:
            return [
                "Reciclar una tonelada de papel salva 17 árboles",
                "El papel reciclado usa un 60% menos de energía que hacer papel nuevo",
                "Cada persona usa en promedio 190 kg de papel al año"
            ]
        case .aluminum:
            return [
                "Reciclar aluminio ahorra un 95% de la energía necesaria para producirlo nuevo",
                "Una lata de aluminio puede ser reciclada y estar de vuelta en el estante en 60 días",
                "Las latas de aluminio son los envases más reciclados del mundo"
            ]
        case .copper:
            return [
                "El cobre es 100% reciclable sin pérdida de calidad",
                "Cerca del 80% del cobre extraído sigue en uso hoy día",
                "Reciclar cobre usa un 85% menos de energía que producirlo nuevo"
            ]
        case .other:
            return [
                "Los residuos electrónicos contienen oro, plata y otros metales preciosos",
                "Reciclar un teléfono móvil puede ahorrar suficiente energía para cargar un laptop durante 44 horas",
                "Los vertederos son la tercera fuente más grande de metano, un potente gas de efecto invernadero"
            ]
        }
    }
}

// MARK: - Safari View
struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

// MARK: - QR Result View
struct QRResultView: View {
    let code: String
    @Binding var showingSafariView: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "qrcode")
                .font(.system(size: 60))
                .foregroundColor(.purple)
            
            VStack(alignment: .leading, spacing: 10) {
                if code.isValidURL {
                    Text("Enlace detectado:")
                        .font(.headline)
                    
                    Text(code)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .lineLimit(2)
                    
                    Button(action: {
                        showingSafariView = true
                    }) {
                        HStack {
                            Image(systemName: "safari")
                            Text("Abrir en navegador")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                } else {
                    Text("Contenido del QR:")
                        .font(.headline)
                    
                    Text(code)
                        .font(.body)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    Button(action: {
                        UIPasteboard.general.string = code
                    }) {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("Copiar contenido")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Product Result View
struct ProductResultView: View {
    let material: ContentScanner.MaterialType
    let code: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header con icono y título
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(material.color.opacity(0.2))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: material.icon)
                            .font(.system(size: 50))
                            .foregroundColor(material.color)
                    }
                    
                    Text(material.rawValue.capitalized)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(material.color)
                        .padding(.top, 5)
                }
                .padding(.top, 20)
                
                // Sección de Impacto Ambiental
                ImpactDetailsView(impact: material.impactDescription)
                    .padding(.horizontal, 20)
                
                // Sección de Consejos de Reciclaje
                RecyclingTipsView(material: material)
                    .padding(.horizontal, 20)
                
                // Datos Curiosos
                FunFactsView(material: material)
                    .padding(.horizontal, 20)
                
                // Mensaje para códigos no reconocidos
                if material == .other {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.purple)
                            Text("CÓDIGO NO RECONOCIDO")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.purple)
                        }
                        
                        Text("El código \(code) no está en nuestra base de datos. Hemos clasificado el material como 'Otro' basado en el formato del código.")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                        
                        Text("¿Es esta clasificación incorrecta? Por favor contáctanos para ayudarnos a mejorar.")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Header View
struct HeaderView: View {
    var body: some View {
        VStack {
            Image(systemName: "barcode.viewfinder")
                .font(.system(size: 50))
                .foregroundColor(.green)
            
            Text("EcoScanner")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            Text("Escanea códigos QR o de barras")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "barcode")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Escanea un código")
                .font(.title2)
                .foregroundColor(.gray)
            
            Text("QR para credenciales o código de barras para productos")
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 120)
    }
}

// MARK: - Scan Button
struct ScanButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "barcode.viewfinder")
                Text("Escanear")
            }
            .padding()
            .frame(width: 200)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(25)
            .shadow(radius: 5)
        }
        .padding(.bottom, 10)
    }
}

// MARK: - Extensión para validar URLs
extension String {
    var isValidURL: Bool {
        if let url = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}

#Preview {
    ContentScanner()
}
