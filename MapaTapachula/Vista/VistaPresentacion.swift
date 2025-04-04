//
//  VistaPresentacion.swift
//  MapaTapachula
//
//  Created by abel cameras on 03/04/25.
//

import SwiftUI

struct VistaPresentacion: View {
    @State private var isShowingMenu = false
    @State private var currentStep = 0 // Controla qué imagen se muestra
    
    let images = ["Plastico", "Vidrio", "Papel", "Metal", "Carton", "Logo", ""]
    let words = ["Recicla", "Reduce", "Reutiliza", "Reciclar hoy...", "...Es salvar el mañana", "", ""]
    
    @State var isLogo:Bool = false
    @State var cerrarBlanco: Bool = false
    @State var abrirBlanco: Bool = false
    
    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea(edges: .all)
            Color.white
                .frame(height: cerrarBlanco ? 0 : 750)
            Color.white
                .frame(height: abrirBlanco ? 750 : 0)
            
            
            VStack {
                
                Image(images[currentStep])
                    .resizable()
                    .scaledToFit()
                    .frame(width: isLogo ? 250 : 100, height: isLogo ? 250 : 100) // Tamaño constante para todas las imágenes
                
                Text(words[currentStep]) // Muestra la palabra correspondiente
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
            }
        }
        .onAppear {
            withAnimation{
                cerrarBlanco = true
            }
            withAnimation{
                runAnimationSequence( )
            }
        }.fullScreenCover(isPresented: $isShowingMenu) {
            VistaPrincipalMovil()
        }
    }
    
    func runAnimationSequence() {
        for i in 0..<images.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 1.2)) {
                withAnimation {
                    if i == 5 {
                        isLogo = true // Muestra el logo
                        abrirBlanco = true // Abre el blanco solo después de mostrar el logo
                       
                    }
                    
                    if i == 6{
                        isShowingMenu = true
                    }
                    currentStep = i // Cambia la imagen en la secuencia
                }
            }
        }
        
        for i in 0..<words.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 1.2)) { // Reducir el tiempo a 1 segundo
                withAnimation {
                    currentStep = i // Cambia la palabra
                }
            }
        }
    }
}

#Preview {
    VistaPresentacion()
}
