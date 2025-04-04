import SwiftUI

struct Notificaciones: View {
    @State private var notifications = [
        NotificationItem(
            id: "1",
            title: "Nueva actualización disponible",
            message: "Versión 2.1 de EcoTapachula incluye mejoras en el mapa interactivo",
            time: "Hace 5 minutos",
            isRead: false,
            icon: "arrow.triangle.2.circlepath",
            type: .system
        ),
        NotificationItem(
            id: "2",
            title: "Recordatorio de recolección",
            message: "Mañana es tu día de recolección de residuos reciclables",
            time: "Hace 2 horas",
            isRead: true,
            icon: "trash",
            type: .reminder
        ),
        NotificationItem(
            id: "3",
            title: "Taller de compostaje",
            message: "Tu taller de compostaje doméstico está programado para el próximo viernes",
            time: "Ayer",
            isRead: true,
            icon: "leaf",
            type: .event
        ),
        NotificationItem(
            id: "4",
            title: "Puntos ganados",
            message: "Has ganado 150 puntos por tu último reporte de reciclaje",
            time: "Ayer",
            isRead: false,
            icon: "star",
            type: .reward
        ),
        NotificationItem(
            id: "5",
            title: "Nuevo centro de acopio",
            message: "Se ha abierto un nuevo centro de acopio en tu colonia",
            time: "15/06/2023",
            isRead: false,
            icon: "map",
            type: .announcement
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Header con título y acciones
                    HStack {
                        Text("Notificaciones")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("VerdeTierno"))
                        
                        Spacer()
                        
                        Button(action: markAllAsRead) {
                            Text("Marcar todas")
                                .font(.subheadline)
                                .foregroundColor(Color("VerdeTierno"))
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 20)
                    .padding(.bottom, 12)
                    
                    // Lista de notificaciones
                    LazyVStack(spacing: 10) {
                        ForEach(notifications) { notification in
                            NotificationRow(notification: notification)
                                .onTapGesture {
                                    markAsRead(id: notification.id)
                                }
                            
                            Divider()
                                .padding(.leading, 80)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                .padding(.bottom, 20)
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
        }
    }
    
    private func markAsRead(id: String) {
        if let index = notifications.firstIndex(where: { $0.id == id }) {
            notifications[index].isRead = true
        }
    }
    
    private func markAllAsRead() {
        for index in notifications.indices {
            notifications[index].isRead = true
        }
    }
}

struct NotificationItem: Identifiable {
    let id: String
    let title: String
    let message: String
    let time: String
    var isRead: Bool
    let icon: String
    let type: NotificationType
    
    enum NotificationType {
        case system
        case reminder
        case event
        case reward
        case announcement
        
        var color: Color {
            switch self {
            case .system: return Color.blue
            case .reminder: return Color.green
            case .event: return Color.orange
            case .reward: return Color.yellow
            case .announcement: return Color.purple
            }
        }
    }
}

struct NotificationRow: View {
    let notification: NotificationItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            // Icono con fondo circular
            ZStack {
                Circle()
                    .fill(notification.type.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: notification.icon)
                    .foregroundColor(notification.type.color)
                    .font(.system(size: 20))
            }
            .padding(.leading, 15)
            
            // Contenido de la notificación
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(notification.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(notification.isRead ? .gray : .primary)
                    
                    Spacer()
                    
                    Text(notification.time)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.trailing, 15)
                }
                
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundColor(notification.isRead ? .gray : .secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.trailing, 15)
            }
            .padding(.vertical, 12)
        }
        .frame(width: 370, height:100) // Añade un alto mínimo aquí
        .background(notification.isRead ? Color.white : Color("VerdeTierno").opacity(0.05))
    }
}

#Preview {
    Notificaciones()
}
