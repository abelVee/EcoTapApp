import SwiftUI


struct MenuBarra: View {
    @State private var selectedTab = 0 // Estado para controlar la pestaña seleccionada

       var body: some View {
           TabView(selection: $selectedTab) {
               // Pestaña 1
               Text("Inicio")
                   .tabItem {
                       Image(systemName: "house.fill")
                       Text("Inicio")
                   }
                   .tag(0)

               // Pestaña 2
               Text("Explorar")
                   .tabItem {
                       Image(systemName: "magnifyingglass")
                       Text("Explorar")
                   }
                   .tag(1)

               // Pestaña 3
               Text("Favoritos")
                   .tabItem {
                       Image(systemName: "heart.fill")
                       Text("Favoritos")
                   }
                   .tag(2)

               // Pestaña 4
               Text("Mensajes")
                   .tabItem {
                       Image(systemName: "message.fill")
                       Text("Mensajes")
                   }
                   .tag(3)

               // Pestaña 5
               Text("Perfil")
                   .tabItem {
                       Image(systemName: "person.fill")
                       Text("Perfil")
                   }
                   .tag(4)
           }
           .accentColor(.blue) // Color de los iconos seleccionados
       }
   }

#Preview {
    MenuBarra()
}
