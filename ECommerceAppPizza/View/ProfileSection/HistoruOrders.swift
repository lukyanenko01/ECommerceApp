//
//  HistoruOrders.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 27.06.2023.
//

import SwiftUI

struct HistoruOrders: View {
    
    @StateObject private var orderViewModel = OrdersViewModel()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "uk_UA")
        df.dateFormat = "d MMMM, yyyy 'р.' HH:mm"
        return df
    }()

    var body: some View {
        
            List(orderViewModel.orders) { order in
                NavigationLink(destination: OrderDetailView(order: order)) {
                    Text("\(dateFormatter.string(from: order.date))")
                }
            }
            .onAppear {
                orderViewModel.fetchOrders()
            }
        }
    
}

struct HistoruOrders_Previews: PreviewProvider {
    static var previews: some View {
        HistoruOrders()
    }
}

struct OrderDetailView: View {
    let order: Order
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "uk_UA")
        df.dateFormat = "d MMMM, yyyy 'р.' HH:mm"
        return df
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Адреса доставки: \(order.location)")
                .padding()
            
            Text("Дата: \(dateFormatter.string(from: order.date))")
                .padding()
            
            Text("Сума: \(order.cost)")
                .padding()

            List(order.positions) { position in
                VStack {
                    Text(position.title)
                        .padding()
                    Text("Кількість: \(position.count)")
                        .padding()
                    Text("Розмір: \(position.size)")
                        .padding()


                    
                }
            }
        }
    }
}



class OrdersViewModel: ObservableObject {
    @Published var orders = [Order]()
    private var dataBaseService = DataBaseService()
    
    func fetchOrders() {
        guard let user = AuthService.shared.currentUser else {
            print("No user is signed in.")
            return
        }
        
        dataBaseService.getOrdersForUser(userId: user.uid) { result in
            switch result {
            case .success(let orders):
                DispatchQueue.main.async {
                    self.orders = orders
                }
            case .failure(let error):
                print("Failed to get orders: \(error.localizedDescription)")
            }
        }
    }
}
