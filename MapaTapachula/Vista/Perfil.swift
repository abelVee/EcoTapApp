//
//  Perfil.swift
//  MapaTapachula
//
//  Created by ADMIN UNACH on 01/04/25.
//

import SwiftUI

struct PerfilView: View {
    let imagenPerfil: String
    let nombre: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.black.opacity(0)
                .ignoresSafeArea(edges:.all)
            Color.white
                .ignoresSafeArea(edges: .all)
                .frame(width: UIScreen.main.bounds.width / 1.75)
                .shadow(radius: 5)
            VStack(alignment: .center, spacing: 0) {
                UnevenRoundedRectangle(bottomLeadingRadius: 180, bottomTrailingRadius: 180)
                    .fill(.verdeTierno)
                    .frame(height: 330)
                    .ignoresSafeArea(edges: .top)
                    .overlay{
                            
                            Image(imagenPerfil)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 180)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                .shadow(radius: 5)
                                .offset(y: 50)
                        }
                
                Text(nombre)
                    .font(.title)
                    .foregroundColor(.verdeTierno)
                    .fontWeight(.bold)
                
                VStack(spacing: 16) {
                    Buttons(img: "perfil", text: "Información\npersonal")
                    Buttons(img: "historial", text: "Historial de\nsolicitudes")
                    Buttons(img: "invitar", text: "Invitar\namigos")
                    Buttons(img: "ayuda", text: "Ayuda y\nsoporte")
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width / 1.75)
        }.ignoresSafeArea(edges: .all)
            .padding(.leading)
    }
}

#Preview {
    PerfilView(imagenPerfil: "Perfil", nombre: "Jose Alfredo")
}


private struct Buttons: View {
    let img: String
    let text: String
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.verdeTierno)
            .frame(width: UIScreen.main.bounds.width/2, height: 60)
            .overlay{
                Label(text, image: img)
                    .font(.title2)
                    .foregroundStyle(.white)
            }.shadow(color: .gray, radius: 4, y: 5)
            .padding(5)
    }
}
