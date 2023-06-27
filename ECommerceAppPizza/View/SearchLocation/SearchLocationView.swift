//
//  SearchLocationView.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 19.06.2023.
//

import SwiftUI
import MapKit

struct SearchLocationView: View {
    
    @StateObject var locationManager: LocationManager = .init()
    // MARK: Navigation Tag to Push View to MapView
    @State var navigationTag: String?
    @Binding var location: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isShowingMapViewSelection: Bool = false
    @Binding var isShowing: Bool


    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Find Location here", text: $locationManager.searchText)
            }
            .padding(.vertical,12)
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(.gray)
            }
            .padding(.vertical,10)
            
            if let places = locationManager.fetchedPlaces, !places.isEmpty {
                
                List {
                    ForEach(places, id: \.self) { place in
                        Button {
                            if let coordinate = place.location?.coordinate {
                                locationManager.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                locationManager.addDraggablePin(coordinate: coordinate)
                                locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                            }
                            
                            // Navigation to MapView
                            navigationTag = "MAPVIEW"
                            isShowingMapViewSelection = true
                        } label: {
                            HStack(spacing: 15) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(place.name ?? "")
                                        .font(.title3.bold())
                                        .foregroundColor(.primary)
                                    Text(place.locality ?? "")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                            }

                        }

                    }
                    
                }
                .listStyle(.plain)
                
            } else {
                //MARK: Live Location Button
                Button {
                    // setting map region
                    if let coordinate = locationManager.userLocation?.coordinate {
                        locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                        locationManager.addDraggablePin(coordinate: coordinate)
                        locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                    }
                    
                    // Navigation to MapView
                    navigationTag = "MAPVIEW"
                    isShowingMapViewSelection = true
                } label: {
                    Label {
                        Text("Use Current Location")
                            .font(.callout)
                    } icon: {
                        Image(systemName: "location.north.circle.fill")
                    }
                    .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

            }
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .fullScreenCover(isPresented: $isShowingMapViewSelection) {
            MapViewSelection(location: $location, isShowing: $isShowing, isShowingMapViewSelection: $isShowingMapViewSelection)
                .environmentObject(locationManager)
        }
        .onChange(of: isShowingMapViewSelection) { newValue in
            isShowing = newValue
        }
    }
}

