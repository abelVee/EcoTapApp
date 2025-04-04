import SwiftUI
//tilin
struct Cita: View {
    
    @FocusState private var focusState: Field?
    
    @State var dateTime = Date()
    let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    @State private var showAlert = false
    @State private var alertMessage = "Debe haber al menos 1 kg de material"
    
    var closedRange = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
    
    @State private var isLoading: Bool = false
    @State private var showSuccess: Bool = false
    
    @State var plastico: Double = 0.0
    @State var metal: Double = 0.0
    @State var carton: Double = 0.0
    @State var vidrio: Double = 0.0
    @State var papel: Double = 0.0
    
    @StateObject var locationManager = LocationManager()
    @State var direccion: String = ""
    @State var latitud: Double = 0.0
    @State var longitud: Double = 0.0
    
    @State var showCameraView: Bool = false
    
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea(.all, edges: .all)
                .opacity(1)
            VStack(spacing: 0){
                
                Text("Agendar una cita")
                    .font(.system(size: 45))
                    .fontWeight(.bold)
                    .foregroundStyle(.verdeTierno)
                    .shadow(color: .white ,radius: 4)
                    .offset(y: -30)
                
                Text("1. Selecciona una fecha")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .padding(.top)
                    .offset(x: -60)
                
                
                DatePicker("Fecha", selection: $dateTime, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.bottom)
                
                Text("2. Selecciona materiales")
                    .font(.title2)
                   .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .offset(x: -60)
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 300, height: 300)
                    .foregroundStyle(Color.white)
                    .shadow(color: .gray, radius: 5)                   .opacity(0.9)
                    .overlay{
                        VStack{
                            Material(image: "Plastico", material: $plastico)
                            Material(image: "Metal", material: $metal)
                            Material(image: "Carton", material: $carton)
                            Material(image: "Vidrio", material: $vidrio)
                            Material(image: "Papel", material: $papel)
                        }
                    }
                
                MultiField(
                    title: "Ingresa tu dirección",
                    text: $direccion,
                    desc: "Espera o Ingresa dirección...",
                    lines: 3,
                    currentField: .direccion,
                    nextField: nil,
                    focusedField: $focusState
                ).padding(.top)
                
                
                
                
                Button {
                    guard !direccion.isEmpty else {
                            alertMessage = "Por favor ingresa una dirección válida"
                            showAlert = true
                            return
                        }
                        
                        // Validar que al menos un material tenga más de 1 kg
                        guard plastico > 1 || metal > 1 || carton > 1 || vidrio > 1 || papel > 1 else {
                            alertMessage = "Debes incluir al menos un material con más de 1 kg"
                            showAlert = true
                            return
                        }
                    
                    Task {
                        await generarCita()
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 250, height: 60)
                        .foregroundStyle(Color.red)
                        .shadow(color: .white, radius: 5)
                        .overlay{
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Generar Cita")
                                    .font(.title)
                                    .bold()
                                    .foregroundStyle(.white)
                            }
                        }
                        .opacity(0.95)
                        .padding()
                }.disabled(isLoading)
                .alert("Atención", isPresented: $showAlert) {
                    Button("Entendido", role: .cancel) { }
                } message: {
                    Text(alertMessage)
                }
                .alert("Cita creada", isPresented: $showSuccess) {
                    Button("OK", role: .cancel) {
                        // Resetear el formulario si es necesario
                        dateTime = Date.now
                        plastico = 0
                        metal = 0
                        carton = 0
                        vidrio = 0
                        papel = 0
                        direccion = ""
                    }
                } message: {
                    Text("Tu cita se ha agendado correctamente")
                }
                
                
            }
        }.onAppear {
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
    
    private func generarCita() async {
        isLoading = true
        do {
            try await subirCita()
            showSuccess = true
        } catch {
            print("Error al generar cita: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    private func subirCita() async throws {
        let cita = CitaS(
            dia: dayFormatter.string(from: dateTime),
            hora: timeFormatter.string(from: dateTime),
            plastico: plastico,
            metal: metal,
            carton: carton,
            vidrio: vidrio,
            papel: papel,
            direccion: direccion,
            latitud: latitud,
            longitud: longitud
        )
        
        var request = URLRequest(url: URL(string: "http://\(adress):8080/cita")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(cita)
        
        _ = try await URLSession.shared.data(for: request)
    }
}

private struct Material: View {
    @FocusState private var isFocused: Bool
    let image: String
    @Binding var material: Double
    var body: some View {
        HStack{
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
            UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20)
                .foregroundStyle(.red)
                .frame(width: 45, height: 35)
                .onTapGesture {
                    withAnimation{
                    if material > 0 {material -= 1}
                    }
                }
                .overlay{
                    Text("-")
                        .font(.custom("Montserrat", size: 40))
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                        .shadow(radius: 5)
                }
            
            TextField("Cantidad", value: $material, format: .number.precision(.fractionLength(1)))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .frame(width: 50, height: 35)
                .submitLabel(.done)
                .focused($isFocused)
                .onSubmit {
                    isFocused = false
                }
            
            UnevenRoundedRectangle(bottomTrailingRadius: 20, topTrailingRadius: 20)
                .foregroundStyle(.verdeTierno)
                .frame(width: 45, height: 35)
                .onTapGesture {
                    withAnimation{material += 1}
                }
                .overlay{
                    Text("+")
                        .font(.custom("Montserrat", size: 40))
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                        .shadow(radius: 5)
                }
            Text("kg")
                .font(.custom("Montserrat", size: 20))
        }.padding(6)
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




struct CitaS: Codable {
    var dia: String?
    var hora: String?
    var plastico: Double?
    var metal: Double?
    var carton: Double?
    var vidrio: Double?
    var papel: Double?
    var direccion: String
    var latitud: Double
    var longitud: Double
}

private enum Field {
        case direccion, none
    }


#Preview {
    Cita()
}
