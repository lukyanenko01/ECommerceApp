//
//  ContactsView.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 27.06.2023.
//

import SwiftUI
import MapKit

struct ContactsView: View {
    
    @State var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.7, longitude: -74.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State var annotations = [IdentifiablePointAnnotation]()
    
    let phoneNumber = "+380982861789"
    let address = "вулиця Фортечна, 4 а, Запоріжжя, Запорізька область, 69061"
    let telegramURL = "https://t.me/lukyanenko7"
    let instagramURL = "https://instagram.com/pizza.est?igshid=MzRlODBiNWFlZA=="
    
    
    var body: some View {
        VStack(spacing: 20) {
            Map(coordinateRegion: $coordinateRegion, annotationItems: annotations) { annotation in
                MapMarker(coordinate: annotation.coordinate, tint: .blue)
            }
            .frame(height: UIScreen.main.bounds.height / 4)
            .cornerRadius(8)
            .onAppear {
                geocodeAddressString(address: address)
            }
            .onTapGesture {
                openMapWithAddress(address: address)
            }
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("ПіцАЄ")
                        .font(.custom(customFont, size: 24).bold())
                    
                    Text(address)
                        .font(.custom(customFont, size: 17))
                    
                    Text("Графік: 11:00 - 22:00, 24/7")
                        .font(.custom(customFont, size: 17))
                    
                    HStack(spacing: 20) {
                        Link(destination: URL(string: telegramURL)!, label: {
                            Image("telegram-icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        })
                        Link(destination: URL(string: instagramURL)!, label: {
                            Image("instagram-icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        })
                        Button(action: {
                               let telephone = "tel://"
                               let formattedString = telephone + phoneNumber
                               guard let url = URL(string: formattedString) else { return }
                               UIApplication.shared.open(url)
                           }) {
                               Image("phone-icon")
                                   .resizable()
                                   .aspectRatio(contentMode: .fit)
                                   .frame(width: 40, height: 40)
                                   .clipShape(Circle())
                           }
                    }
                    .padding()
                    
                    Text("Піцає - це піцерія в Запоріжжі з дійсно смачною піцою! В меню є піца та не тільки! Також салати, пельмені та вареники власної роботи, нагетси, картопля фрі. Якщо ви бажаєте скуштувати піцу з справжніх якісних, італійських продуктів, то ласкаво просимо в Піцає! Більше 20 видів піц, які хочеться з'їсти від скоринки до скоринки. Така смачна і така різна🤤")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .lineSpacing(8)
                }
            }
        }
        .padding()
    }
    
    private func openMapWithAddress(address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { placemarks, error in
            guard let placemarks = placemarks, let placemark = placemarks.first else {
                return
            }
            
            guard let location = placemark.location else {
                return
            }
            
            let latitude: CLLocationDegrees = location.coordinate.latitude
            let longitude: CLLocationDegrees = location.coordinate.longitude
            
            let regionDistance: CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary: nil))
            mapItem.name = "Target location"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)])
        }
    }
    
    private func geocodeAddressString(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let placemark = placemarks?.first, let location = placemark.location else { return }
            let annotation = IdentifiablePointAnnotation()
            annotation.coordinate = location.coordinate
            coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            annotations.append(annotation)
        }
    }
    
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}

class IdentifiablePointAnnotation: NSObject, MKAnnotation, Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = ""
        self.subtitle = ""
    }
}


