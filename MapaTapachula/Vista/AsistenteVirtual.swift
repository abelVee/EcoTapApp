import SwiftUI
import AVFoundation

struct AsistenteVirtual: View {
    @State private var conversacion: [(String, Bool)] = [
        ("Asistente: Hola, bienvenido. ¿En qué te puedo ayudar?", false)
    ]
    @State private var mostrarOpcionesContacto = false
    @State private var mostrarFormularioQueja = false
    @State private var mostrarManualEcotapa = false
    @State private var mostrarOpcionesPrincipales = true
    
    // Sintetizador de voz
    private let sintetizadorVoz = AVSpeechSynthesizer()
    
    let preguntas = [
        "Manual",
        "Contacto con técnico",
    ]
    
    var body: some View {
        ZStack {
            // Fondo blanco
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(conversacion, id: \.0) { mensaje, esUsuario in
                            HStack {
                                if esUsuario {
                                    Spacer()
                                    Text(mensaje)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                } else {
                                    HStack {
                                        Image("Bot1")
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                        Text(mensaje)
                                            .padding()
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                if mostrarOpcionesPrincipales && !mostrarFormularioQueja && !mostrarManualEcotapa && !mostrarOpcionesContacto {
                    VStack {
                        Text("Selecciona una opción:")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        ForEach(preguntas, id: \.self) { pregunta in
                            Button(action: { responderPregunta(pregunta) }) {
                                Text(pregunta)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    .offset(y: -40)
                }
                
                if mostrarManualEcotapa {
                    VStack {
                        Text("Manual sobre la Ecotapa")
                            .font(.headline)
                            .padding()
                        
                        Text("La Ecotapa es un sistema diseñado para la protección y manejo sostenible de recursos naturales. Su objetivo principal es promover prácticas que no solo beneficien el medio ambiente, sino que también impliquen un cambio positivo para la comunidad y la economía local. Este sistema se implementa a través de iniciativas como reciclaje, uso de energía renovable, y reducción de residuos, contribuyendo a un futuro más verde.")
                            .padding()
                            .foregroundColor(.black)
                            .font(.body)
                        
                        Button(action: {
                            mostrarManualEcotapa = false
                            mostrarOpcionesPrincipales = true
                            agregarMensaje("Asistente: ¿En qué más te puedo ayudar?")
                        }) {
                            Text("Volver al asistente")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .offset(y: -70)
                }
                
                VStack {
                    if mostrarOpcionesContacto {
                        Text("¿Deseas que te ponga en contacto con el técnico?")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                        
                        HStack {
                            Button(action: {
                                mostrarOpcionesPrincipales = false
                                agregarMensaje("Usuario: Sí", esUsuario: true)
                                llamarAlTecnico()
                                agregarMensaje("Asistente: Llamando al 962 223 6869...")
                                mostrarOpcionesContacto = false
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    mostrarOpcionesPrincipales = true
                                    agregarMensaje("Asistente: ¿En qué más te puedo ayudar?")
                                }
                            }) {
                                Text("Sí")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                mostrarOpcionesContacto = false
                                mostrarOpcionesPrincipales = true
                                agregarMensaje("Usuario: No", esUsuario: true)
                                agregarMensaje("Asistente: De acuerdo, si necesitas ayuda, avísame.")
                            }) {
                                Text("No")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .offset(y: -50)
            }
            .navigationTitle("Asistente Virtual")
        }
        .onAppear {
            // Reproducir el mensaje inicial al aparecer
            hablar(texto: "Hola, bienvenido. ¿En qué te puedo ayudar?")
        }
    }
    
    private func responderPregunta(_ pregunta: String) {
        mostrarOpcionesPrincipales = false
        agregarMensaje("Usuario: \(pregunta)", esUsuario: true)
        
        switch pregunta {
        case "Manual":
            mostrarManualEcotapa = true
            hablar(texto: "Aquí tienes el manual sobre la Ecotapa")
        case "Contacto con técnico":
            mostrarOpcionesContacto = true
            hablar(texto: "¿Deseas que te ponga en contacto con el técnico?")
        default:
            agregarMensaje("Asistente: No entiendo la pregunta.")
            hablar(texto: "No entiendo la pregunta")
        }
    }
    
    // Función para agregar mensaje y hablar
    private func agregarMensaje(_ mensaje: String, esUsuario: Bool = false) {
        conversacion.append((mensaje, esUsuario))
        
        // Solo hablar si es el asistente
        if !esUsuario {
            let textoParaHablar = mensaje.replacingOccurrences(of: "Asistente: ", with: "")
            hablar(texto: textoParaHablar)
        }
    }
    
    // Función para hablar con voz
    private func hablar(texto: String) {
        let utterance = AVSpeechUtterance(string: texto)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES") // Voz en español
        utterance.rate = 0.5 // Velocidad de habla (0.0 a 1.0)
        
        sintetizadorVoz.speak(utterance)
    }
    
    // Función para realizar la llamada al técnico
    private func llamarAlTecnico() {
        if let url = URL(string: "tel://9622696188"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("No se puede realizar la llamada")
        }
    }
}

#Preview {
    AsistenteVirtual()
}
