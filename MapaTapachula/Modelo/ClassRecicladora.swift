//
//  ClassRecicladora.swift
//  MapaTapachula
//
//  Created by abel cameras on 19/03/25.
//

import Foundation
import MapKit

// Clase que representa la anotación de la recicladora
class RecicladoraAnnotation: NSObject, Identifiable, MKAnnotation {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String? = "Empresa de reciclaje"
    var imageName: String? // Hacer imageName opcional
    
    init(coordinate: CLLocationCoordinate2D, title: String, imageName: String?) {
        self.coordinate = coordinate
        self.title = title
        self.imageName = imageName
    }
}
