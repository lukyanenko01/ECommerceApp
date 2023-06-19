////
////  MapView.swift
////  ECommerceAppPizza
////
////  Created by Vladimir Lukyanenko on 19.06.2023.
////
//
//import MapKit
//import SwiftUI
//
//struct MapView: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @State var locationManager = CLLocationManager()
//    @State var alert: Bool = false
//    @State var result: String = ""
//
//    var onSelect: (String) -> ()
//
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            MapViewRepresentable(locationManager: $locationManager)
//            Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
//                Image(systemName: "xmark")
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.gray.opacity(0.6))
//                    .clipShape(Circle())
//            }
//        }
//        .onAppear() {
//            self.locationManager.requestWhenInUseAuthorization()
//        }
//        .alert(isPresented: $alert) {
//            Alert(title: Text("Please Enable Location Access In Settings"))
//        }
//        .onChange(of: locationManager.authorizationStatus) { (status) in
//            switch status {
//            case .denied:
//                self.alert.toggle()
//            case .authorizedWhenInUse:
//                self.locationManager.startUpdatingLocation()
//            default:
//                break
//            }
//        }
//        .onChange(of: locationManager.location) { (location) in
//            guard let location = location else { return }
//            let geoCoder = CLGeocoder()
//            let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//                if let mPlacemark = placemarks {
//                    if let dict = mPlacemark[0].addressDictionary as? [String: Any],
//                       let Name = dict["Name"] as? String,
//                       let City = dict["City"] as? String,
//                       let ZIP = dict["ZIP"] as? String {
//                        self.result = "\(Name), \(City), \(ZIP)"
//                        onSelect(result)
//                    }
//                }
//            })
//        }
//    }
//}
//
//struct MapViewRepresentable: UIViewControllerRepresentable {
//    typealias UIViewControllerType = MapKitViewController
//    @Binding var locationManager: CLLocationManager
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<MapViewRepresentable>) -> MapViewRepresentable.UIViewControllerType {
//        return MapKitViewController()
//    }
//
//    func updateUIViewController(_ uiViewController: MapViewRepresentable.UIViewControllerType, context: UIViewControllerRepresentableContext<MapViewRepresentable>) {
//        uiViewController.update(locationManager: locationManager)
//    }
//}
//
//class MapKitViewController: UIViewController, CLLocationManagerDelegate {
//    var locationManager: CLLocationManager?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let map = MKMapView(frame: self.view.frame)
//        self.view.addSubview(map)
//        locationManager?.delegate = self
//        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//    }
//
//    func update(locationManager: CLLocationManager) {
//        self.locationManager = locationManager
//    }
//}
