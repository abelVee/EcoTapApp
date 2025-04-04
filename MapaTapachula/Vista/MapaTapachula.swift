import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var location = LocationView()
    
    // Coordenadas de las recicladoras
    let annotations = [
        Annotation(coordinate: CLLocationCoordinate2D(latitude: 14.913351255352786, longitude: -92.34027265140098), title: "RECICLADORA RECTA", imageName: "Senal Recicladora", type: .recicladora,description: "Descripción de RECICLADORA RECTA"),
        Annotation(coordinate: CLLocationCoordinate2D(latitude: 14.844539547014632, longitude: -92.3139900666361), title: "GRUPO RECYCLEZA", imageName: "Senal Recicladora", type: .recicladora,description: "Descripción de RECICLADORA RECTA"),
        Annotation(coordinate: CLLocationCoordinate2D(latitude: 14.80166, longitude: -92.33139), title: "PRO-LIFE RECICLADOS", imageName: "Senal Recicladora", type: .recicladora,description: "Descripción de RECICLADORA RECTA"),
        Annotation(coordinate: CLLocationCoordinate2D(latitude: 14.90743, longitude: -92.25380), title: "CIA MARIO/DIVISION RECICLAJE", imageName: "Senal Recicladora", type: .recicladora,description: "Descripción de RECICLADORA RECTA"),
        Annotation(coordinate: CLLocationCoordinate2D(latitude: 14.88197, longitude: -92.28242), title: "BIO PAPPEL S.A .B de C.V", imageName: "Senal Recicladora", type: .recicladora,description: "Descripción de RECICLADORA RECTA"),
        Annotation(coordinate: CLLocationCoordinate2D(latitude: 14.90930, longitude: -92.27124), title: "Cartonera Guadalupana", imageName: "Senal Recicladora", type: .recicladora,description: "Descripción de RECICLADORA RECTA"),
        Annotation(coordinate: CLLocationCoordinate2D(latitude: 14.90737, longitude: -92.26474), title: "Secretaria de Desarollo Urbano y Ecología", imageName: "Senal Empresa", type: .empresa,description: "Descripción de RECICLADORA RECTA"),
        Annotation(coordinate: CLLocationCoordinate2D(latitude: 14.91675, longitude: -92.26051), title: "PROFEPA/Medio Ambiente - Coordinación Regional Tapachula", imageName: "Senal Empresa", type: .empresa,description: "Descripción de RECICLADORA RECTA"),
        Annotation(coordinate: CLLocationCoordinate2D(latitude: 14.90971, longitude: -92.25867), title: "Limpisur", imageName: "Senal Empresa", type: .empresa,description: "Descripción de RECICLADORA RECTA"),
        Annotation(coordinate: CLLocationCoordinate2D(latitude: 14.91649, longitude: -92.26350), title: "Comite de agua potable tapachula", imageName: "Senal Empresa", type: .empresa,description: "Descripción de RECICLADORA RECTA"),
        Annotation(coordinate: CLLocationCoordinate2D(latitude: 14.91649, longitude: -92.26350), title: "Conagua", imageName: "Senal Empresa", type: .empresa,description: "Descripción de RECICLADORA RECTA"),
        Annotation(coordinate: CLLocationCoordinate2D(latitude: 14.89801, longitude: -92.26024), title: "levanta basura", imageName: "Senal Mision", type: .mision,description: "Descripción de RECICLADORA RECTA"),
        Annotation(coordinate: CLLocationCoordinate2D(latitude: 14.90361, longitude: -92.26962), title: "levanta basura", imageName: "Senal Mision", type: .mision,description: "Descripción de RECICLADORA RECTA"),
        Annotation(coordinate: CLLocationCoordinate2D(latitude: 14.89858, longitude: -92.262320), title: "levanta basura", imageName: "Senal Reciclador", type: .reciclador,description: "Descripción de RECICLADORA RECTA")
    ]
    
   
    
    // Estado para controlar qué tipos de anotaciones mostrar
       @State private var showRecicladoras = true
       @State private var showEmpresas = true
       @State private var showMisiones = true
       @State private var showRecicladores = true
       
       // Estado para controlar si el filtro está visible
       @State private var isFilterVisible = false
       
       // Estado para controlar la anotación seleccionada
       @State private var selectedAnnotation: Annotation?
       
       // Estado para controlar si el seguimiento de la ubicación está activado
       @State private var isTrackingLocation = false
       
       // Enlace opcional para el modo de seguimiento del usuario
       private var userTrackingMode: Binding<MapUserTrackingMode>? {
           Binding<MapUserTrackingMode>(
               get: {
                   isTrackingLocation ? .follow : .none
               },
               set: { newValue in
                   isTrackingLocation = (newValue == .follow)
               }
           )
       }
       
       var body: some View {
           ZStack(alignment: .topTrailing) {
               // Mapa
               Map(
                   coordinateRegion: $location.userLocation,
                   showsUserLocation: true,
                   userTrackingMode: userTrackingMode, // Usar el enlace opcional
                   annotationItems: filteredAnnotations
               ) { annotation in
                   MapAnnotation(coordinate: annotation.coordinate) {
                       VStack {
                           if let imageName = annotation.imageName {
                               Image(imageName)
                                   .resizable()
                                   .scaledToFit()
                                   .frame(width: 40, height: 40)
                                   .clipShape(Circle())
                                   .onTapGesture {
                                       selectedAnnotation = annotation
                                   }
                           } else {
                               Image(systemName: "mappin")
                                   .resizable()
                                   .frame(width: 40, height: 40)
                                   .foregroundColor(.red)
                                   .onTapGesture {
                                       selectedAnnotation = annotation
                                   }
                           }
                       }
                   }
               }
               .edgesIgnoringSafeArea(.all)
               
               // Botón de seguimiento de ubicación
               VStack(spacing: 10) {
                   Button(action: {
                       isTrackingLocation.toggle() // Activar/desactivar seguimiento
                   }) {
                       Image(systemName: isTrackingLocation ? "location.fill" : "location")
                           .padding(10)
                           .background(Color.white.opacity(0.8))
                           .clipShape(Circle())
                           .shadow(radius: 5)
                   }
                   
                   // Botón de filtro
                   Button(action: {
                       isFilterVisible.toggle()
                   }) {
                       Image(systemName: "line.horizontal.3.decrease.circle.fill")
                           .padding(10)
                           .background(Color.white.opacity(0.8))
                           .clipShape(Circle())
                           .shadow(radius: 5)
                   }
                   
                   // Controles de zoom
                   Button(action: {
                       zoomIn()
                   }) {
                       Image(systemName: "plus")
                           .padding(10)
                           .background(Color.white.opacity(0.8))
                           .clipShape(Circle())
                           .shadow(radius: 5)
                   }
                   
                   Button(action: {
                       zoomOut()
                   }) {
                       Image(systemName: "minus")
                           .padding(10)
                           .background(Color.white.opacity(0.8))
                           .clipShape(Circle())
                           .shadow(radius: 5)
                   }
               }
               .padding(.trailing, 20)
               .padding(.top, 50)
               
               // Fondo semitransparente cuando el filtro está visible
               if isFilterVisible {
                   Color.black.opacity(0.4)
                       .edgesIgnoringSafeArea(.all)
                       .onTapGesture {
                           isFilterVisible = false
                       }
                   
                   // Centrar la ventana de filtro
                   FiltroVista(
                       showRecicladoras: $showRecicladoras,
                       showEmpresas: $showEmpresas,
                       showMisiones: $showMisiones,
                       showRecicladores: $showRecicladores
                   )
                   .frame(width: 300, height: 245)
                   .background(Color.white)
                   .cornerRadius(15)
                   .shadow(radius: 10)
                   .transition(.scale)
                   .zIndex(1)
                   .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
               }
           }
           .sheet(item: $selectedAnnotation) { annotation in
               ZStack {
                   // Fondo semitransparente
                   Color.black.opacity(0.4)
                       .edgesIgnoringSafeArea(.all)
                       .onTapGesture {
                           selectedAnnotation = nil
                       }
                   
                   // Contenedor de la vista de detalle
                   AnnotationDetailView(annotation: annotation)
                       .frame(width: 400, height: 445)
                       .background(Color.white)
                       .cornerRadius(15)
                       .shadow(radius: 10)
                       .transition(.scale)
                       .zIndex(1)
                       .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
               }
               .background(BackgroundCleanerView())
           }
       }
       
       // Anotaciones filtradas según la selección del usuario
       var filteredAnnotations: [Annotation] {
           annotations.filter { annotation in
               switch annotation.type {
               case .recicladora:
                   return showRecicladoras
               case .empresa:
                   return showEmpresas
               case .mision:
                   return showMisiones
               case .reciclador:
                   return showRecicladores
               }
           }
       }
       
       // Función para hacer zoom in (acercar)
       private func zoomIn() {
           withAnimation {
               location.userLocation.span.latitudeDelta /= 2
               location.userLocation.span.longitudeDelta /= 2
           }
       }
       
       // Función para hacer zoom out (alejar)
       private func zoomOut() {
           withAnimation {
               location.userLocation.span.latitudeDelta *= 2
               location.userLocation.span.longitudeDelta *= 2
           }
       }
   }

   // Vista para limpiar el fondo por defecto de la hoja
   struct BackgroundCleanerView: UIViewRepresentable {
       func makeUIView(context: Context) -> UIView {
           let view = UIView()
           DispatchQueue.main.async {
               if let parent = view.superview?.superview {
                   parent.backgroundColor = .clear
               }
           }
           return view
       }
       
       func updateUIView(_ uiView: UIView, context: Context) {}
   }

   // Tipos de anotaciones
   enum AnnotationType {
       case recicladora
       case empresa
       case mision
       case reciclador
   }

   // Estructura de anotación
   struct Annotation: Identifiable {
       let id = UUID()
       let coordinate: CLLocationCoordinate2D
       let title: String
       let imageName: String?
       let type: AnnotationType
       let description: String
   }

   #Preview {
       ContentView()
   }
