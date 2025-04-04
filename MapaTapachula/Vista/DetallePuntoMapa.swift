//
//  DetallePuntoMapa.swift
//  MapaTapachula
//
//  Created by abel cameras on 20/03/25.
//

import SwiftUI
import MapKit

struct AnnotationDetailView: View {
    let annotation: Annotation
    
    var body: some View {
        VStack(spacing: 20) {
            // Título centrado en la parte superior
            Text(annotation.title)
                .font(.largeTitle) // Fuente más grande
                .bold()
                .multilineTextAlignment(.center) // Texto centrado
                .foregroundColor(.black) // Texto en negro
                .padding(.top, 20) // Espaciado superior
            
            
            // Descripción centrada y separada
            Text(annotation.description)
                .font(.body)
                .multilineTextAlignment(.center) // Texto centrado
                .foregroundColor(.black) // Texto en negro
                .padding(.horizontal, 20) // Espaciado horizontal
                .lineSpacing(8) // Espaciado entre líneas
            
            // Espaciador para empujar el botón hacia abajo
            Spacer()
            
            // Botón "Cómo llegar" centrado en la parte inferior
            Button(action: {
                // Acción para "Cómo llegar"
                openMaps(with: annotation.coordinate)
            }) {
                Text("Cómo llegar")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity) // Botón ancho
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20) // Espaciado horizontal
            .padding(.bottom, 20) // Espaciado inferior
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ocupar todo el espacio disponible
        .background(Color.white.opacity(0.9)) // Fondo semitransparente
        .cornerRadius(15) // Bordes redondeados
        .shadow(radius: 10) // Sombra
    }

    

    
    private func openMaps(with coordinate: CLLocationCoordinate2D) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = annotation.title
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}




