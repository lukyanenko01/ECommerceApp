//
//  MapViewSelection.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 23.06.2023.
//

import SwiftUI

struct MapViewSelection: View {
    
    @EnvironmentObject var locationManager: LocationManager
    @Binding var location: String  // добавляем привязку к location
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var isShowing: Bool
    @Binding var isShowingMapViewSelection: Bool


    
    var body: some View {
        ZStack {
            MapViewHelper()
                .environmentObject(locationManager)
                .ignoresSafeArea()
            
            // Displaying Data
            if let place = locationManager.pickedPlaceMark {
                VStack(spacing: 15) {
                    Text("Confirm Location")
                        .font(.title2.bold())
                    
                    HStack(spacing: 15) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(place.name ?? "")
                                .font(.title3.bold())
                            
                            Text(place.locality ?? "")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical,10)
                    
                    Button {
                        if let place = locationManager.pickedPlaceMark {
                            location = place.name ?? ""  // обновляем location
                        }
                        isShowing = false
                        isShowingMapViewSelection = false
                    } label: {
                        Text("Confirm Location")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,12)
                            .background {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.green)
                            }
                            .overlay(alignment: .trailing) {
                                Image(systemName: "arrow.right")
                                    .font(.title3.bold())
                                    .padding(.trailing)
                            }
                            .foregroundColor(.white)
                    }

                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .ignoresSafeArea()
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .onDisappear {
            locationManager.pickedLocation = nil
            locationManager.pickedPlaceMark = nil
            
            locationManager.mapView.removeAnnotations(locationManager.mapView.annotations)
        }
    }
    
}

