import CoreLocation
import MapKit
import Foundation

final class LocationView: NSObject, ObservableObject {
    private struct Mexico {
        static let delta = 0.05
    }
    
    @Published var userLocation: MKCoordinateRegion = .init()
    private let locationManager: CLLocationManager = .init()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        // Solo solicitamos la ubicación una vez
        locationManager.requestLocation()
    }
}

// Extension for CLLocationManagerDelegate
extension LocationView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Location: \(location)")
        
        // Actualiza en el hilo principal
        DispatchQueue.main.async {
            self.userLocation = .init(
                center: location.coordinate,
                span: .init(latitudeDelta: Mexico.delta, longitudeDelta: Mexico.delta)
            )
        }
        
        // Detenemos las actualizaciones después de obtener la ubicación
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
