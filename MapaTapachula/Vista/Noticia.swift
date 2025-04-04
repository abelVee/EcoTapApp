import SwiftUI

struct Noticia: View {
    let noticias = [
        NoticiaItem(
            titulo: "Nueva Campaña de Reciclaje en Tapachula",
            contenido: "El municipio lanza una nueva iniciativa para incrementar el reciclaje de plásticos y vidrio en la ciudad. Se instalarán 50 nuevos puntos de recolección.",
            fecha: "15 Mayo 2023",
            imagen: "ReciclajeTapachula",
            destacada: true
        ),
        NoticiaItem(
            titulo: "Talleres Gratuitos de Composta",
            contenido: "A partir del próximo mes, se impartirán talleres gratuitos para enseñar a los ciudadanos cómo crear su propia composta en casa y reducir los desechos orgánicos.",
            fecha: "28 Abril 2023",
            imagen: "Composta",
            destacada: true
        ),
        NoticiaItem(
            titulo: "Premian a Escuelas por Proyectos Ecológicos",
            contenido: "10 escuelas de la región recibieron reconocimientos por sus innovadores proyectos de sustentabilidad y cuidado del medio ambiente.",
            fecha: "5 Abril 2023",
            imagen: "Universidad",
            destacada: false
        ),
        NoticiaItem(
            titulo: "Inauguran Nuevo Centro de Acopio",
            contenido: "El nuevo centro permitirá procesar hasta 5 toneladas  diarias de material reciclable,   creando además 20 nuevos empleos en la comunidad.",
            
            
            fecha: "22 Marzo 2023",
            imagen: "CentroAcopio",
            destacada: false
        ),
        NoticiaItem(
            titulo: "Nuevo Programa de Reforestación",
            contenido: "La iniciativa plantará 10,000 árboles nativos en áreas urbanas durante este año, mejorando la calidad del aire en la ciudad.",
            fecha: "10 Junio 2023",
            imagen: "Reforestacion",
            destacada: true
        )
    ]
    
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var noticiasDestacadas: [NoticiaItem] {
        noticias.filter { $0.destacada }
    }
    
    var noticiasNormales: [NoticiaItem] {
        noticias.filter { !$0.destacada }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Título principal
                    Text("Noticias Ambientales")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("VerdeTierno"))
                        .padding(.top, 20)
                    
                    // Carrusel horizontal de noticias destacadas
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Destacadas")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        GeometryReader { geometry in
                            TabView(selection: $currentIndex) {
                                ForEach(0..<noticiasDestacadas.count, id: \.self) { index in
                                    NoticiaDestacadaCard(noticia: noticiasDestacadas[index])
                                        .frame(width: geometry.size.width - 40, height: 250)
                                        .tag(index)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                            .frame(height: 300)
                            .onReceive(timer) { _ in
                                withAnimation {
                                    currentIndex = (currentIndex + 1) % noticiasDestacadas.count
                                }
                            }
                        }
                        .frame(height: 300)
                    }
                    
                    // Lista vertical de noticias normales
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Últimas Noticias")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        ForEach(noticiasNormales) { noticia in
                            NoticiaCard(noticia: noticia)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarTitle("", displayMode: .inline)
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        }
    }
}

struct NoticiaItem: Identifiable {
    let id = UUID()
    let titulo: String
    let contenido: String
    let fecha: String
    let imagen: String
    let destacada: Bool
}

struct NoticiaDestacadaCard: View {
    let noticia: NoticiaItem
    
    var body: some View {
        NavigationLink(destination: NoticiaDetalle(noticia: noticia)) {
            ZStack(alignment: .bottomLeading) {
                // Imagen de fondo
                Image(noticia.imagen)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width - 40, height: 250)
                    .clipped()
                    .cornerRadius(15)
                
                // Gradiente para mejorar legibilidad del texto
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .cornerRadius(15)
                
                // Contenido de la tarjeta
                VStack(alignment: .leading, spacing: 5) {
                    Text(noticia.fecha)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(noticia.titulo)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    Text(noticia.contenido)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(3)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct NoticiaCard: View {
    let noticia: NoticiaItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(noticia.imagen)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(12)
            
            Text(noticia.fecha)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(noticia.titulo)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(noticia.contenido)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            NavigationLink(destination: NoticiaDetalle(noticia: noticia)) {
                Text("Leer más")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color("VerdeTierno"))
                    .padding(.top, 5)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct NoticiaDetalle: View {
    let noticia: NoticiaItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Imagen principal
                Image(noticia.imagen)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .frame(maxWidth: .infinity)
                    .clipped()
                
                // Contenido de texto con padding adecuado
                VStack(alignment: .leading, spacing: 15) {
                    // Fecha
                    Text(noticia.fecha)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                    
                    // Título con padding y alineación
                    Text(noticia.titulo)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 40)
                        .fixedSize(horizontal: false, vertical: true) // Permite múltiples líneas
                    
                    // Divisor
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Contenido con formato y padding
                    Text(noticia.contenido.replacingOccurrences(of: "  ", with: " ")) // Elimina espacios dobles
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineSpacing(6) // Espaciado entre líneas
                        .padding(.horizontal, 40)
                        .fixedSize(horizontal: false, vertical: true) // Ajuste de texto
                    
                    // Espaciador final
                    Spacer().frame(height: 30)
                }
                .frame(maxWidth: .infinity) // Asegura que use todo el ancho disponible
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}
#Preview {
    Noticia()
}
