//
//  PuntosManager.swift
//  MapaTapachula
//
//  Created by abel cameras on 29/03/25.
//

import Foundation


class PuntosManager: ObservableObject {
    @Published var puntos: Int = 1250
    
    func restarPuntos(_ cantidad: Int) {
        puntos -= cantidad
    }
    
    func sumarPuntos(_ cantidad: Int) {
        puntos += cantidad
    }
}
