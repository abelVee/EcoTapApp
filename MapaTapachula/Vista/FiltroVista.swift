//
//  FiltroVista.swift
//  MapaTapachula
//
//  Created by abel cameras on 20/03/25.
//

import Foundation
import SwiftUI
// Vista de filtro
struct FiltroVista: View {
    @Binding var showRecicladoras: Bool
    @Binding var showEmpresas: Bool
    @Binding var showMisiones: Bool
    @Binding var showRecicladores: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Filtrar por:")
                .foregroundColor(.black)
                .font(.headline)
                .padding(.bottom, 5)
            
            // Filtro para Recicladoras
            HStack {
                Image(systemName: "arrow.3.trianglepath") // Símbolo para recicladoras
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.green)
                Text("Recicladoras")
                    .foregroundColor(.black)
                Spacer()
                Toggle("", isOn: $showRecicladoras)
                    .labelsHidden()
            }
            
            // Filtro para Empresas
            HStack {
                Image(systemName: "building.2") // Símbolo para empresas
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
                Text("Empresas")
                    .foregroundColor(.black)
                Spacer()
                Toggle("", isOn: $showEmpresas)
                    .labelsHidden()
            }
            
            // Filtro para Misiones
            HStack {
                Image(systemName: "flag.fill") // Símbolo para misiones
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.orange)
                Text("Misiones")
                    .foregroundColor(.black)
                Spacer()
                Toggle("", isOn: $showMisiones)
                    .labelsHidden()
            }
            
            // Filtro para Recicladores
            HStack {
                Image(systemName: "person.fill") // Símbolo para recicladores
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.purple)
                Text("Recicladores")
                    .foregroundColor(.black)
                Spacer()
                Toggle("", isOn: $showRecicladores)
                    .labelsHidden()
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
