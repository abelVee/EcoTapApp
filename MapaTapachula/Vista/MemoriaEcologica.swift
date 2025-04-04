import SwiftUI

struct MemoriaReciclaje: View {
    // Categorías de reciclaje con sus respectivos contenedores
    let categorias: [String: [String]] = [
        "Envases": ["🧴", "🥫", "🧃", "📦", "🍶", "🥤", "🍾", "🧂"],
        "Papel/Cartón": ["📰", "📚", "🧻", "📫", "📄", "🗞️", "🎁", "📊"],
        "Vidrio": ["🍷", "🍸", "🥃", "🍶", "🧴", "🔮", "🥛", "🍼"],
        "Orgánico": ["🍎", "🥕", "🍌", "🍞", "🌰", "🍖", "🥚", "🧀"]
    ]
    
    @State private var categoriaSeleccionada = "Envases"
    @State private var cartas: [Carta] = []
    @State private var intentos = 0
    @State private var paresEncontrados = 0
    @State private var cartaVolteada: Int?
    @State private var juegoTerminado = false
    @State private var mostrarInfo = false
    
    struct Carta: Identifiable {
        let id: Int
        let contenido: String
        var volteada: Bool = false
        var emparejada: Bool = false
    }
    
    var body: some View {
        VStack {
            // Encabezado con título e información
            HStack {
                Text("♻️ Memoria de Reciclaje")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.green)
                
                Button(action: { mostrarInfo.toggle() }) {
                    Image(systemName: "info.circle")
                        .font(.title)
                        .foregroundColor(.green)
                }
            }
            .padding(.top)
            
            // Selector de categorías
            Picker("Categoría de residuos", selection: $categoriaSeleccionada) {
                ForEach(Array(categorias.keys), id: \.self) { categoria in
                    Text(categoria).tag(categoria)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .onChange(of: categoriaSeleccionada) { _ in
                reiniciarJuego()
            }
            
            // Contador de intentos
            Text("Intentos: \(intentos)")
                .font(.headline)
                .padding(.vertical, 5)
            
            // Tablero de juego
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 15) {
                ForEach(cartas) { carta in
                    CartaView(carta: carta) {
                        voltearCarta(id: carta.id)
                    }
                }
            }
            .padding()
            
            // Botón de reinicio
            Button(action: reiniciarJuego) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Reiniciar Juego")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .onAppear {
            reiniciarJuego()
        }
        .alert("¡Reciclaje completado!", isPresented: $juegoTerminado) {
            Button("Jugar de nuevo") {
                reiniciarJuego()
            }
        } message: {
            Text("Has clasificado todos los residuos correctamente en \(intentos) intentos.\n\n¡Buen trabajo cuidando el planeta!")
        }
        .sheet(isPresented: $mostrarInfo) {
            InfoReciclajeView()
        }
        
        .offset(y:-50)
    }
    
    func voltearCarta(id: Int) {
        guard let indice = cartas.firstIndex(where: { $0.id == id }),
              !cartas[indice].volteada,
              !cartas[indice].emparejada else { return }
        
        cartas[indice].volteada = true
        
        if let cartaAnterior = cartaVolteada {
            intentos += 1
            
            if cartas[indice].contenido == cartas[cartaAnterior].contenido {
                cartas[indice].emparejada = true
                cartas[cartaAnterior].emparejada = true
                paresEncontrados += 1
                
                if paresEncontrados == cartas.count / 2 {
                    juegoTerminado = true
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    cartas[indice].volteada = false
                    cartas[cartaAnterior].volteada = false
                }
            }
            cartaVolteada = nil
        } else {
            cartaVolteada = indice
        }
    }
    
    func reiniciarJuego() {
        intentos = 0
        paresEncontrados = 0
        cartaVolteada = nil
        juegoTerminado = false
        
        let emojis = categorias[categoriaSeleccionada] ?? []
        let pares = (emojis + emojis).shuffled()
        
        cartas = pares.enumerated().map { index, contenido in
            Carta(id: index, contenido: contenido, volteada: false, emparejada: false)
        }
    }
}

struct CartaView: View {
    let carta: MemoriaReciclaje.Carta
    let accion: () -> Void
    
    var body: some View {
        ZStack {
            if carta.volteada || carta.emparejada {
                RoundedRectangle(cornerRadius: 10)
                    .fill(carta.emparejada ? Color.green.opacity(0.3) : Color.white)
                    .overlay(
                        Text(carta.contenido)
                            .font(.system(size: 32))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(carta.emparejada ? Color.green : Color.gray, lineWidth: 2)
                    )
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .overlay(
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    )
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onTapGesture {
            accion()
        }
        .rotation3DEffect(
            .degrees(carta.volteada || carta.emparejada ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: carta.volteada || carta.emparejada)
    }
}

struct InfoReciclajeView: View {
    let infoCategorias = [
        ("Envases", "Contenedor amarillo: Botellas de plástico, latas, briks, etc.", "🧴🥫🧃"),
        ("Papel/Cartón", "Contenedor azul: Periódicos, cajas, revistas, etc.", "📰📚🧻"),
        ("Vidrio", "Contenedor verde: Botellas, frascos, tarros, etc.", "🍷🍸🥃"),
        ("Orgánico", "Contenedor marrón: Restos de comida, cáscaras, etc.", "🍎🥕🍌")
    ]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Cómo clasificar los residuos").font(.headline)) {
                    ForEach(infoCategorias, id: \.0) { categoria in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(categoria.0)
                                    .font(.headline)
                                    .foregroundColor(.green)
                                Spacer()
                                Text(categoria.2)
                            }
                            Text(categoria.1)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Section {
                    Text("Reciclar correctamente ayuda a reducir la contaminación y conservar los recursos naturales. ¡Cada pequeño gesto cuenta!")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Información de Reciclaje")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Listo") {
                        // Cierra la vista
                    }
                }
            }
        }
    }
}

#Preview {
    MemoriaReciclaje()
}
