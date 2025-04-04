import SwiftUI

struct VistaPrincipalMovil: View {
    @State private var floating = false
    @State private var isShowingContentView = false
    @State private var isShowingAsistenteView = false
    @State private var isShowingScannerView = false
    @State private var isShowingMisionView = false
    @State private var isShowingPremiosView = false
    @State private var isShowingNotificacionesView = false
    @State private var isShowingNoticiasView = false
    @State private var isShowingEducacionView = false
    @State private var isShowingPerfilView = false
    @State private var isShowingCitaView = false
    @State private var isShowingReporteView = false
    @State private var currentTitleIndex = 0
    @State private var timer: Timer?
    
    let titles = [
        (text: "¡APRENDAMOS\nCOMO RECICLAR!", icon: "Reciclar", color: Color("VerdeTierno")),
        (text: "¡ECONOMIA\nCIRCULAR!               ", icon: "EconomiaCircular", color: Color("Dorado"))
    ]
    
    var body: some View {
        ZStack {
            // Contenido condicional
            if isShowingEducacionView {
                NavigationStack {
                       Educacion()
                           .padding(.bottom, 70)
                   }
                   .frame(width: 405, height: 870)
            } else if isShowingScannerView {
                ContentScanner()
                    .padding(.bottom, 140)
                    .frame(width: 405, height: 900)
            } else if isShowingAsistenteView {
                AsistenteVirtual()
                    .padding(.bottom, 70)
            } else if isShowingContentView {
                ContentView()
                    .padding(.bottom, 70)
            } else if isShowingMisionView {
                Misiones()
                    .padding(.bottom, 70)
                    .frame(width: 405, height: 900)
            } else if isShowingPremiosView {
                Premios()
                    .padding(.bottom, 70)
                    .frame(width: 405, height: 900)
            } else if isShowingNotificacionesView {
                Notificaciones()
                    .padding(.bottom, 70)
                    .frame(width: 405, height: 900)
            } else if isShowingCitaView {
                Cita()
                    .padding(.bottom, 70)
                    .frame(width: 405, height: 900)
            } else if isShowingReporteView {
                Reporte()
                    .padding(.bottom, 70)
                    .frame(width: 405, height: 900)
            }else if isShowingNoticiasView {
                Noticia()
                    .padding(.bottom, 70)
            } else {
                NavigationView {
                    VStack {
                        ZStack {
                            Image("Tapachula3")
                                .resizable()
                                .frame(width: 415, height: 250)
                                .offset(y: 30)
                            
                            VStack {
                                VStack {
                                    Circle()
                                        .fill(Color.yellow)
                                        .frame(width: 90, height: 90)
                                        .overlay(
                                            Image("PerfilAbel")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 90, height: 90)
                                                .clipShape(Circle())
                                        )
                                        .offset(y: 50)
                                        .offset(x: -155)
                                        .onTapGesture {
                                            resetAllViews()
                                            withAnimation{
                                                isShowingPerfilView = true
                                            }
                                        }
                                }
                                
                                Text("ABEL VELAZQUEZ CAMERAS")
                                    .font(.custom("Impact", size: 20))
                                    .foregroundColor(.white)
                                    .offset(y: -27)
                                    .offset(x: 5)
                                
                                Text("Ciudadano")
                                    .font(.custom("Impact", size: 16))
                                    .foregroundColor(.white.opacity(0.8))
                                    .offset(y: -25)
                                    .offset(x: -60)
                            }
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    resetAllViews()
                                    withAnimation{
                                        isShowingNotificacionesView = true
                                    }
                                }) {
                                    Image(systemName: "bell.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.white)
                                        .offset(y: 18)
                                        .padding(.trailing, 20)
                                }
                            }
                        }
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 418, height: 780)
                                .cornerRadius(55)
                                .offset(y: -20)
                            
                            Button(action: {
                                resetAllViews()
                                withAnimation{
                                    isShowingEducacionView = true
                                }
                            }) {
                                Image("RectanguloAprendamos")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 390, height: 300)
                            }
                            .offset(y: -320)
                            
                            HStack(spacing: 130) {
                                Text(titles[currentTitleIndex].text)
                                    .font(.custom("Impact", size: currentTitleIndex == 0 ? 23 : 24))
                                    .foregroundColor(titles[currentTitleIndex].color)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Image(titles[currentTitleIndex].icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                            }
                            .transition(.opacity.combined(with: .scale))
                            .offset(y: -320)
                            
                            VStack {
                                HStack {
                                    VStack {
                                        Button(action: {
                                            resetAllViews()
                                            withAnimation{
                                                isShowingContentView = true
                                            }
                                        }) {
                                            ZStack {
                                                Rectangle()
                                                    .fill(Color.white)
                                                    .frame(width: 140, height: 180)
                                                    .cornerRadius(15)
                                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                                
                                                Image("Mapa")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 100)
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        Text("Mapa interactivo")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                    }
                                    .offset(y: -30)
                                    .offset(x: -25)
                                    
                                    VStack {
                                        Button(action: {
                                            resetAllViews()
                                            withAnimation{
                                                isShowingCitaView = true
                                            }
                                        }){
                                            ZStack {
                                                Rectangle()
                                                    .fill(Color.white)
                                                    .frame(width: 140, height: 180)
                                                    .cornerRadius(15)
                                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                                
                                                Image("Camion")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 100)
                                                    .foregroundColor(.green)
                                            }
                                            }
                                            Text("Recolección")
                                                .font(.headline)
                                                .foregroundColor(.gray)
                                        }
                                    .offset(y: -30)
                                    .offset(x: 30)
                                }
                                
                                HStack {
                                    VStack {
                                        Button(action: {
                                            resetAllViews()
                                            withAnimation{
                                                isShowingReporteView = true
                                            }
                                        }){
                                            ZStack {
                                                Rectangle()
                                                    .fill(Color.white)
                                                    .frame(width: 140, height: 180)
                                                    .cornerRadius(15)
                                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                                
                                                Image("Camara")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 100)
                                                    .foregroundColor(.purple)
                                            }}
                                        Text("Reporta un \n problema")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                    }
                                    .offset(y: -20)
                                    .offset(x: -25)
                                    
                                    VStack {
                                        Button(action: {
                                            resetAllViews()
                                            withAnimation{
                                                isShowingNoticiasView = true
                                            }
                                        }) {
                                            ZStack {
                                                Rectangle()
                                                    .fill(Color.white)
                                                    .frame(width: 140, height: 180)
                                                    .cornerRadius(15)
                                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                                
                                                Image("Noticia")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 100)
                                                    .foregroundColor(.orange)
                                            }
                                        }
                                        Text("Noticias")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                    }
                                    .offset(y: -30)
                                    .offset(x: 30)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            
            // Barra inferior
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(Color("VerdeTierno"))
                        .frame(width: 450, height: 87)
                        .cornerRadius(30)
                        .offset(y:20)
                    
                    HStack(spacing: -5) {
                        VStack {
                            Button(action: {
                                resetAllViews()
                            }) {
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40)
                                    .foregroundColor(.white)
                            }
                            Text("Inicio")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .offset(x: -5)
                        .offset(y: 12)
                        
                        VStack {
                            Button(action: {
                                resetAllViews()
                                withAnimation{
                                    isShowingPremiosView = true
                                }
                            }) {
                                Image(systemName: "gift.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                                    .foregroundColor(.white)
                            }
                            Text("Premio")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .offset(x: 34)
                        .offset(y: 12)
                        
                        VStack {
                            Image("Bot")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                                .offset(y: -30)
                                .offset(x: 50)
                        }
                        .offset(x: 5)
                        .offset(y: 12)
                        
                        Button(action: {
                            resetAllViews()
                            withAnimation{
                                isShowingAsistenteView = true
                            }
                        }) {
                            Image("Bot1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90)
                                .offset(y: floating ? -25 : -30)
                                .shadow(radius: 10)
                                .zIndex(1)
                        }
                        .offset(x: -34)
                        .offset(y: 8)
                        
                        VStack {
                            Button(action: {
                                resetAllViews()
                                withAnimation{
                                    isShowingMisionView = true
                                }
                            }) {
                                Image(systemName: "flag.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                                    .foregroundColor(.white)
                            }
                            Text("Misiones")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .offset(x: -18)
                        .offset(y: 12)
                        
                        VStack {
                            Button(action: {
                                resetAllViews()
                                withAnimation{
                                    isShowingScannerView = true
                                }
                            }) {
                                Image(systemName: "qrcode.viewfinder")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                                    .foregroundColor(.white)
                            }
                            Text("Scanner")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .offset(x: 10)
                        .offset(y: 12)
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height)
            if isShowingPerfilView {
                Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation{isShowingPerfilView = false}
                    }
                PerfilView(imagenPerfil: "PerfilAbel", nombre: "Abel Velazquez Cameras")
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
        }
        .onAppear {
            // Animación del botón flotante
            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                floating.toggle()
            }
            
            // Iniciar animación del título solo si estamos en la vista principal
            startTitleAnimation()
        }
        .onChange(of: isShowingContentView) { _ in startTitleAnimation() }
        .onChange(of: isShowingAsistenteView) { _ in startTitleAnimation() }
        .onChange(of: isShowingScannerView) { _ in startTitleAnimation() }
        .onChange(of: isShowingMisionView) { _ in startTitleAnimation() }
        .onChange(of: isShowingPremiosView) { _ in startTitleAnimation() }
        .onChange(of: isShowingNotificacionesView) { _ in startTitleAnimation() }
        .onChange(of: isShowingNoticiasView) { _ in startTitleAnimation() }
        .onChange(of: isShowingEducacionView) { _ in startTitleAnimation() }
        .onDisappear {
            stopTitleAnimation()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func resetAllViews() {
        isShowingCitaView = false
        isShowingPerfilView = false
        isShowingContentView = false
        isShowingAsistenteView = false
        isShowingScannerView = false
        isShowingMisionView = false
        isShowingPremiosView = false
        isShowingNotificacionesView = false
        isShowingNoticiasView = false
        isShowingEducacionView = false
        isShowingReporteView = false
        
        // Detener la animación cuando cambiamos de vista
        stopTitleAnimation()
    }
    
    private func startTitleAnimation() {
        // Solo iniciar si estamos en la vista principal
        guard !isShowingContentView && !isShowingAsistenteView && !isShowingScannerView &&
              !isShowingMisionView && !isShowingPremiosView && !isShowingNotificacionesView &&
              !isShowingNoticiasView && !isShowingEducacionView else {
            stopTitleAnimation()
            return
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                currentTitleIndex = (currentTitleIndex + 1) % titles.count
            }
        }
    }
    
    private func stopTitleAnimation() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    VistaPrincipalMovil()
}
