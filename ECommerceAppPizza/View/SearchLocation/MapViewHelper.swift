//
//  MapViewHelper.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 23.06.2023.
//

import SwiftUI
import MapKit

struct MapViewHelper: UIViewRepresentable {
    
    @EnvironmentObject var locationManager: LocationManager
    
    func makeUIView(context: Context) -> MKMapView {
        return locationManager.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
    
}
