import SwiftUI

struct Premios: View {
    @State private var premios = [
        Premio(
            id: "1",
            nombre: "EcoAmigo Básico",
            descripcion: "Canjea 500 puntos por un kit de reciclaje inicial",
            puntosRequeridos: 500,
            imagen: "leaf.fill",
            color: .green,
            disponible: true,
            canjeado: false
        ),
        Premio(
            id: "2",
            nombre: "Descuento Tienda Verde",
            descripcion: "20% de descuento en productos ecológicos",
            puntosRequeridos: 750,
            imagen: "tag.fill",
            color: .blue,
            disponible: true,
            canjeado: false
        ),
        Premio(
            id: "3",
            nombre: "Taller VIP",
            descripcion: "Acceso exclusivo a taller de sustentabilidad",
            puntosRequeridos: 1000,
            imagen: "person.badge.plus.fill",
            color: .purple,
            disponible: true,
            canjeado: true
        ),
        Premio(
            id: "4",
            nombre: "Kit Avanzado",
            descripcion: "Kit completo para compostaje doméstico",
            puntosRequeridos: 1500,
            imagen: "scissors",
            color: .orange,
            disponible: false,
            canjeado: false
        ),
        Premio(
            id: "5",
            nombre: "Reconocimiento Oficial",
            descripcion: "Certificado de ciudadano ecológico ejemplar",
            puntosRequeridos: 2000,
            imagen: "rosette",
            color: .yellow,
            disponible: true,
            canjeado: false
        )
    ]
    
    @State private var puntosUsuario = 1250
    @State private var mostrarCanjeados = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Text("Premios")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("VerdeTierno"))
                        
                        Spacer()
                        
                        Button(action: {
                            mostrarCanjeados.toggle()
                        }) {
                            Text(mostrarCanjeados ? "Mostrar todos" : "Mostrar canjeados")
                                .font(.subheadline)
                                .foregroundColor(Color("VerdeTierno"))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Resumen de puntos
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Tus puntos disponibles")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Text("\(puntosUsuario)")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(Color("VerdeTierno"))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Color("VerdeTierno"))
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // Lista de premios
                    LazyVStack(spacing: 15) {
                        ForEach(premiosFiltrados) { premio in
                            PremioCard(
                                premio: premio,
                                puntosUsuario: puntosUsuario,
                                onCanjear: { canjearPremio(premio) }
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.bottom, 20)
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
        }
    }
    
    private func canjearPremio(_ premio: Premio) {
        guard puntosUsuario >= premio.puntosRequeridos,
              !premio.canjeado,
              premio.disponible,
              let index = premios.firstIndex(where: { $0.id == premio.id }) else {
            return
        }
        
        // Restar los puntos
        puntosUsuario -= premio.puntosRequeridos
        
        // Marcar el premio como canjeado
        premios[index].canjeado = true
        
        // Mostrar confirmación (opcional)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    var premiosFiltrados: [Premio] {
        mostrarCanjeados ? premios.filter { $0.canjeado } : premios.filter { $0.disponible }
    }
}

struct Premio: Identifiable {
    let id: String
    let nombre: String
    let descripcion: String
    let puntosRequeridos: Int
    let imagen: String
    let color: Color
    let disponible: Bool
    var canjeado: Bool  // Cambiado a var para poder modificarlo
}

struct PremioCard: View {
    let premio: Premio
    let puntosUsuario: Int
    var onCanjear: () -> Void
    
    var puedeCanjear: Bool {
        puntosUsuario >= premio.puntosRequeridos && !premio.canjeado && premio.disponible
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 15) {
                // Icono
                ZStack {
                    Circle()
                        .fill(premio.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: premio.imagen)
                        .foregroundColor(premio.color)
                        .font(.system(size: 24))
                }
                
                // Contenido
                VStack(alignment: .leading, spacing: 5) {
                    Text(premio.nombre)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(premio.descripcion)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        
                        Text("\(premio.puntosRequeridos) puntos")
                            .font(.subheadline)
                            .foregroundColor(puedeCanjear ? premio.color : .gray)
                    }
                    .padding(.top, 5)
                }
                
                Spacer()
            }
            
            // Botón de acción
            if premio.canjeado {
                HStack {
                    Spacer()
                    Label("Canjeado", systemImage: "checkmark.seal.fill")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    Spacer()
                }
                .padding(8)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            } else if !premio.disponible {
                HStack {
                    Spacer()
                    Label("Próximamente", systemImage: "clock.fill")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            } else {
                Button(action: {
                    onCanjear()
                }) {
                    Text(puedeCanjear ? "Canjear premio" : "Puntos insuficientes")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(puedeCanjear ? .white : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(puedeCanjear ? premio.color : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .disabled(!puedeCanjear)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            premio.canjeado ?
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.green, lineWidth: 2) : nil
        )
        .opacity(premio.disponible ? 1.0 : 0.7)
    }
}

struct Premios_Previews: PreviewProvider {
    static var previews: some View {
        Premios()
    }
}
