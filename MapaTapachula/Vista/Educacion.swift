import SwiftUI
import AVKit
import AVFoundation
import WebKit

struct Educacion: View {
    let categoriasReciclaje = [
        CategoriaReciclaje(nombre: "Plástico", imagen: "Plastico", color: .blue, consejos: [
            "Lava los envases antes de reciclarlos",
            "Retira las tapas y etiquetas",
            "No recicles plásticos de un solo uso como cubiertos"
        ]),
        CategoriaReciclaje(nombre: "Vidrio", imagen: "Vidrio", color: .green, consejos: [
            "Separa por colores si es posible",
            "Retira tapas y corchos",
            "No incluyas cerámica o cristal"
        ]),
        CategoriaReciclaje(nombre: "Papel", imagen: "Papel", color: .yellow, consejos: [
            "Retira grapas y clips",
            "No recicles papel sucio o con comida",
            "Compacta las cajas antes de reciclar"
        ]),
        CategoriaReciclaje(nombre: "Metal", imagen: "Metal", color: .gray, consejos: [
            "Aplasta las latas para ahorrar espacio",
            "Separa aluminio de otros metales",
            "Retira residuos de alimentos"
        ]),
        CategoriaReciclaje(nombre: "Cartón", imagen: "Carton", color: .brown, consejos: [
            "Desarma las cajas para ahorrar espacio",
            "Retira cualquier material no cartón (plásticos, cintas)",
            "No recicles cartón con restos de comida o grasa",
            "Si está mojado o muy sucio, no es reciclable"
        ])
    ]
    
    let principiosEconomiaCircular = [
        PrincipioEconomiaCircular(
            titulo: "Diseño sostenible",
            descripcion: "Productos diseñados para ser reutilizados, reparados y reciclados",
            icono: "leaf.arrow.circlepath"
        ),
        PrincipioEconomiaCircular(
            titulo: "Reducción de residuos",
            descripcion: "Minimizar la generación de desechos desde el origen",
            icono: "trash.slash"
        ),
        PrincipioEconomiaCircular(
            titulo: "Reutilización",
            descripcion: "Extender la vida útil de los productos y materiales",
            icono: "arrow.triangle.2.circlepath"
        ),
        PrincipioEconomiaCircular(
            titulo: "Reciclaje",
            descripcion: "Transformar residuos en nuevos recursos",
            icono: "arrow.3.trianglepath"
        ),
        PrincipioEconomiaCircular(
            titulo: "Valorización",
            descripcion: "Convertir residuos en energía o nuevos materiales",
            icono: "bolt.circle"
        )
    ]
    
    let videosEducativos = [
        VideoEducativo(
            titulo: "El viaje del reciclaje",
            source: .youtube(url: "https://www.youtube.com/watch?v=6pdjY0aFY8k", thumbnail: "https://img.youtube.com/vi/6pdjY0aFY8k/mqdefault.jpg")
        ),
        VideoEducativo(
            titulo: "Economía circular explicada",
            source: .youtube(url: "https://www.youtube.com/watch?v=wc_65-yf6zU",
                           thumbnail: "https://img.youtube.com/vi/wc_65-yf6zU/mqdefault.jpg")
        ),
        VideoEducativo(
            titulo: "Cómo reciclar plástico",
            source: .youtube(url: "https://www.youtube.com/watch?v=WOR0ytnVuB4",
                           thumbnail: "https://img.youtube.com/vi/WOR0ytnVuB4/mqdefault.jpg")
        ),
        VideoEducativo(
            titulo: "Impacto ambiental del reciclaje",
            source: .youtube(url: "https://www.youtube.com/watch?v=qd3B_vKJVeA",
                           thumbnail: "https://img.youtube.com/vi/qd3B_vKJVeA/mqdefault.jpg")
        )
    ]
    
    let juegosEducativos = [
        JuegoEducativo(titulo: "Clasifica los residuos", descripcion: "Aprende a separar correctamente", icono: "trash", color: .green),
        JuegoEducativo(titulo: "Memoria ecológica", descripcion: "Encuentra las parejas de reciclaje", icono: "square.grid.2x2", color: .blue),
        JuegoEducativo(titulo: "Quiz del reciclaje", descripcion: "Pon a prueba tus conocimientos", icono: "questionmark", color: .orange),
        JuegoEducativo(titulo: "Ruta del reciclaje", descripcion: "Lleva cada residuo a su contenedor", icono: "arrow.triangle.turn.up.right.diamond", color: .purple)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Encabezado
                VStack {
                    Text("Aprendamos a Reciclar")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("VerdeTierno"))
                    
                    Text("y Economía Circular")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Sección de categorías de reciclaje
                VStack(alignment: .leading, spacing: 15) {
                    Text("Cómo Reciclar Correctamente")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(categoriasReciclaje, id: \.nombre) { categoria in
                                CategoriaReciclajeView(categoria: categoria)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Sección de videos educativos
                VStack(alignment: .leading, spacing: 15) {
                    Text("Videos Educativos")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(videosEducativos, id: \.titulo) { video in
                                VideoEducativoView(video: video)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Sección de juegos educativos
                VStack(alignment: .leading, spacing: 15) {
                    Text("Juegos Educativos")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(juegosEducativos, id: \.titulo) { juego in
                            JuegoEducativoView(juego: juego)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Sección de economía circular
                VStack(alignment: .leading, spacing: 15) {
                    Text("Principios de Economía Circular")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ForEach(principiosEconomiaCircular, id: \.titulo) { principio in
                            PrincipioEconomiaCircularView(principio: principio)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Beneficios del reciclaje
                VStack(alignment: .leading, spacing: 15) {
                    Text("Beneficios del Reciclaje")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        BeneficioView(icono: "globe", titulo: "Ahorro energético", descripcion: "Hasta un 30% menos de energía")
                        BeneficioView(icono: "drop", titulo: "Ahorro de agua", descripcion: "Reduce el consumo hasta un 50%")
                        BeneficioView(icono: "tree", titulo: "Menos deforestación", descripcion: "Protege los bosques")
                        BeneficioView(icono: "wind", titulo: "Menos contaminación", descripcion: "Reduce emisiones de CO₂")
                    }
                    .padding(.horizontal)
                }
                
                // Llamado a la acción
                VStack(spacing: 15) {
                    Text("¡Empieza hoy mismo!")
                        .font(.headline)
                    
                    Text("Pequeñas acciones generan grandes cambios en nuestro planeta")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(.vertical, 20)
            }
            .padding(.bottom, 30)
        }
        .navigationBarTitle("Educación", displayMode: .inline)
    }
}

// Modelos de datos
enum VideoSource {
    case local(name: String, thumbnail: String)
    case youtube(url: String, thumbnail: String)
}

struct VideoEducativo {
    let titulo: String
    let source: VideoSource
}

struct JuegoEducativo {
    let titulo: String
    let descripcion: String
    let icono: String
    let color: Color
}

struct CategoriaReciclaje {
    let nombre: String
    let imagen: String
    let color: Color
    let consejos: [String]
}

struct PrincipioEconomiaCircular {
    let titulo: String
    let descripcion: String
    let icono: String
}

// Componentes reutilizables
struct VideoEducativoView: View {
    let video: VideoEducativo
    @State private var showVideoPlayer = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                // Mostrar la miniatura según el tipo de video
                switch video.source {
                case .local(_, let thumbnail):
                    Image(thumbnail)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 120)
                        .clipped()
                case .youtube(_, let thumbnail):
                    AsyncImage(url: URL(string: thumbnail)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 120)
                                .clipped()
                        } else if phase.error != nil {
                            Color.gray.opacity(0.2)
                                .frame(width: 200, height: 120)
                                .overlay(
                                    Image(systemName: "exclamationmark.triangle")
                                        .foregroundColor(.white)
                                )
                        } else {
                            ProgressView()
                                .frame(width: 200, height: 120)
                        }
                    }
                }
                
                // Icono de play superpuesto
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
            }
            .frame(width: 200, height: 120)
            .cornerRadius(12)
            .onTapGesture {
                switch video.source {
                case .local:
                    showVideoPlayer = true
                case .youtube(let url, _):
                    if let url = URL(string: url) {
                        UIApplication.shared.open(url)
                    }
                }
            }
            .sheet(isPresented: $showVideoPlayer) {
                if case let .local(name, _) = video.source {
                    if let url = Bundle.main.url(forResource: name, withExtension: "mp4") {
                        VideoPlayer(player: AVPlayer(url: url))
                            .edgesIgnoringSafeArea(.all)
                    } else {
                        Text("Video no encontrado")
                    }
                }
            }
            
            Text(video.titulo)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(width: 200, alignment: .leading)
                .padding(.top, 5)
        }
    }
}

struct JuegoEducativoView: View {
    let juego: JuegoEducativo
    
    var body: some View {
        NavigationLink(destination: {
            if juego.titulo == "Memoria ecológica" {
                MemoriaReciclaje()
            } else {
                // Puedes añadir otras vistas para otros juegos aquí
                Text("Próximamente: \(juego.titulo)")
                    .navigationTitle(juego.titulo)
            }
        }) {
            VStack(spacing: 8) {
                Image(systemName: juego.icono)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(juego.color)
                    .padding(15)
                    .background(juego.color.opacity(0.1))
                    .cornerRadius(10)
                
                Text(juego.titulo)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(juego.descripcion)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle()) // Esto evita que el botón cambie de color al presionarlo
    }
}

struct CategoriaReciclajeView: View {
    let categoria: CategoriaReciclaje
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                Circle()
                    .fill(categoria.color.opacity(0.2))
                    .frame(width: 70, height: 70)
                
                Image(categoria.imagen)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .foregroundColor(categoria.color)
            }
            
            Text(categoria.nombre)
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 5) {
                ForEach(categoria.consejos.prefix(2), id: \.self) { consejo in
                    HStack(alignment: .top) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 5, height: 5)
                            .padding(.top, 6)
                        Text(consejo)
                            .font(.caption)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding()
        .frame(width: 150)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct PrincipioEconomiaCircularView: View {
    let principio: PrincipioEconomiaCircular
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: principio.icono)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(Color("VerdeTierno"))
                .padding(10)
                .background(Color("VerdeTierno").opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(principio.titulo)
                    .font(.headline)
                Text(principio.descripcion)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct BeneficioView: View {
    let icono: String
    let titulo: String
    let descripcion: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icono)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(Color("VerdeTierno"))
                .padding(10)
                .background(Color("VerdeTierno").opacity(0.1))
                .cornerRadius(10)
            
            Text(titulo)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text(descripcion)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// WebView para YouTube (opcional)
struct YouTubeWebView: UIViewRepresentable {
    let videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else { return }
        uiView.load(URLRequest(url: youtubeURL))
    }
}

// Función auxiliar para extraer el ID de YouTube
func extractYouTubeID(from url: String) -> String? {
       let pattern = "(?<=v(=|/))([\\w-]+)(&|/?|$)"
       guard let regex = try? NSRegularExpression(pattern: pattern),
             let match = regex.firstMatch(in: url, range: NSRange(url.startIndex..., in: url)) else {
           return nil
       }
       return String(url[Range(match.range, in: url)!])
   }


#Preview {
            Educacion()
        
}
