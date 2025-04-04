import SwiftUI

struct Misiones: View {
    @State private var misiones = [
        Mision(
            id: "1",
            titulo: "Reciclaje Básico",
            descripcion: "Recicla 5 botellas de plástico y llévalas a un centro de acopio",
            progreso: 0.4,
            puntos: 100,
            icono: "trash",
            color: .green,
            completada: false
        ),
        Mision(
            id: "2",
            titulo: "Explorador Ecológico",
            descripcion: "Visita 3 puntos de reciclaje en el mapa interactivo",
            progreso: 0.8,
            puntos: 150,
            icono: "map",
            color: .blue,
            completada: false
        ),
        Mision(
            id: "3",
            titulo: "Reporte Ciudadano",
            descripcion: "Reporta un problema ambiental usando la aplicación",
            progreso: 1.0,
            puntos: 200,
            icono: "exclamationmark.bubble",
            color: .orange,
            completada: true
        ),
        Mision(
            id: "4",
            titulo: "Taller de Conciencia",
            descripcion: "Asiste a un taller de educación ambiental",
            progreso: 0.0,
            puntos: 250,
            icono: "book",
            color: .purple,
            completada: false
        ),
        Mision(
            id: "5",
            titulo: "Recolector Experto",
            descripcion: "Recicla 20 artículos en un mes",
            progreso: 0.65,
            puntos: 300,
            icono: "arrow.3.trianglepath",
            color: .teal,
            completada: false
        )
    ]
    
    @State private var mostrarCompletadas = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Text("Misiones")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("VerdeTierno"))
                        
                        Spacer()
                        
                        // Filtro de misiones
                        Button(action: {
                            mostrarCompletadas.toggle()
                        }) {
                            Text(mostrarCompletadas ? "Mostrar todas" : "Mostrar completadas")
                                .font(.subheadline)
                                .foregroundColor(Color("VerdeTierno"))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Resumen de puntos
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Tus puntos")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Text("1,250")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color("VerdeTierno"))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Color("VerdeTierno"))
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // Lista de misiones
                    LazyVStack(spacing: 15) {
                        ForEach(misionesFiltradas) { mision in
                            MisionCard(mision: mision)
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
    
    var misionesFiltradas: [Mision] {
        mostrarCompletadas ? misiones.filter { $0.completada } : misiones
    }
}

struct Mision: Identifiable {
    let id: String
    let titulo: String
    let descripcion: String
    let progreso: Double
    let puntos: Int
    let icono: String
    let color: Color
    let completada: Bool
}

struct MisionCard: View {
    let mision: Mision
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                // Icono
                ZStack {
                    Circle()
                        .fill(mision.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: mision.icono)
                        .foregroundColor(mision.color)
                        .font(.system(size: 20))
                }
                
                // Contenido
                VStack(alignment: .leading, spacing: 5) {
                    Text(mision.titulo)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(mision.descripcion)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Barra de progreso
                    ProgressView(value: mision.progreso, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: mision.color))
                        .padding(.top, 5)
                }
                
                Spacer()
                
                // Puntos
                VStack {
                    Text("\(mision.puntos)")
                        .font(.headline)
                        .foregroundColor(mision.color)
                    
                    Text("pts")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Botón de acción
            if !mision.completada {
                Button(action: {
                    // Acción para completar misión
                }) {
                    Text(mision.progreso > 0 ? "Continuar misión" : "Comenzar misión")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(mision.color)
                        .cornerRadius(8)
                }
            } else {
                HStack {
                    Spacer()
                    Label("Completada", systemImage: "checkmark.seal.fill")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    Spacer()
                }
                .padding(8)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            mision.completada ?
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.green, lineWidth: 2) : nil
        )
    }
}

#Preview {
    Misiones()
}
