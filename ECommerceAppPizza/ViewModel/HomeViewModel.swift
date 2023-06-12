//
//  HomeViewModel.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 06.06.2023.
//

import SwiftUI
// Using Combine to monitor search field and if user leaves for .5 secs then starts searching...
// to avoid memory issue...
import Combine


//
//class HomeViewModel: ObservableObject {
//
//    @Published var productType: ProductType = .Wearable
//
//    @Published var product: [Product] = [
//        Product(type: .Wearable, title: "Apple Watch", subtitle: "Serias 6: Red", price: "$359", productImage: "Wearable"),
//        Product(type: .Wearable, title: "Apple Watch", subtitle: "Serias 6: Red", price: "$359", productImage: "Wearable"),
//        Product(type: .Wearable, title: "Apple Watch", subtitle: "Serias 6: Red", price: "$359", productImage: "Wearable"),
//        Product(type: .Wearable, title: "Apple Watch", subtitle: "Serias 6: Red", price: "$359", productImage: "Wearable"),
//        Product(type: .Phones, title: "Apple Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Phones"),
//        Product(type: .Phones, title: "Apple Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Phones"),
//        Product(type: .Phones, title: "Apple Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Phones"),
//        Product(type: .Phones, title: "Apple Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Phones"),
//        Product(type: .Phones, title: "Apple Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Phones"),
//        Product(type: .Phones, title: "Apple Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Phones"),
//        Product(type: .Tablets, title: "Tablets Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Tablets"),
//        Product(type: .Tablets, title: "Tablets Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Tablets"),
//        Product(type: .Tablets, title: "Tablets Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Tablets"),
//        Product(type: .Tablets, title: "Tablets Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Tablets"),
//        Product(type: .Tablets, title: "Tablets Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Tablets"),
//        Product(type: .Laprops, title: "Laprops Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Laprops"),
//        Product(type: .Laprops, title: "Laprops Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Laprops"),
//        Product(type: .Laprops, title: "Laprops Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Laprops")
//    ]
//
//    //Filtred Products...
//    @Published var filteredProducts: [Product] = []
//
//    // More products on the type..
//    @Published var showMoreProductsOnType: Bool = false
//
//    // Search Data...
//    @Published var searchText: String = ""
//    @Published var searchActivated: Bool = false
//    @Published var searchProducts: [Product]?
//
//    var searchCancellable: AnyCancellable?
//
//
//    init() {
//        filterProductByType()
//
//        searchCancellable = $searchText.removeDuplicates()
//            .debounce(for: 0.5, scheduler: RunLoop.main)
//            .sink(receiveValue: { str in
//                if str != "" {
//                    self.filterProductBySearch()
//                } else {
//                    self.searchProducts = nil
//                }
//            })
//    }
//
//    func filterProductByType() {
//
//        DispatchQueue.global(qos: .userInteractive).async {
//
//            let results = self.product
//            // since it will require more memory so were using lazy to perform more
//
//                .lazy
//                .filter { product in
//                    return product.type == self.productType
//                }
//                .prefix(4)
//
//            DispatchQueue.main.async {
//                self.filteredProducts = results.compactMap({ product in
//                    return product
//                })
//            }
//
//        }
//
//    }
//
//    func filterProductBySearch() {
//
//        DispatchQueue.global(qos: .userInteractive).async {
//
//            let results = self.product
//            // since it will require more memory so were using lazy to perform more
//
//                .lazy
//                .filter { product in
//                    return product.title.lowercased().contains(self.searchText.lowercased())
//                }
//
//            DispatchQueue.main.async {
//                self.searchProducts = results.compactMap({ product in
//                    return product
//                })
//            }
//
//        }
//
//    }
//
//}

///FB

 import SwiftUI
 import Combine

 class HomeViewModel: ObservableObject {
     
     @Published var productType: ProductType = .Pizza
     @Published var product: [Products] = []
     @Published var filteredProducts: [Products] = []
     @Published var showMoreProductsOnType: Bool = false
     @Published var searchText: String = ""
     @Published var searchActivated: Bool = false
     @Published var searchProducts: [Products]?
     
     private var dataService = DataBaseService()
     private var searchCancellable: AnyCancellable?

     init() {
         dataService.getProducts { result in
             switch result {
             case .success(let products):
                 self.product = products.map {
                     Products(id: $0.id,
                              title: $0.title,
                              type: (ProductType(rawValue: $0.type) ?? .Pizza).rawValue,
                              productImage: $0.productImage,
                              priceS: $0.priceS,
                              priceM: $0.priceM,
                              priceXl: $0.priceXl,
                              description: $0.description,
                              size: $0.size,
                              quantity: $0.quantity)
                     
                 }
                 self.filterProductByType()
             case .failure(let error):
                 // Обработка ошибки
                 print(error)
             }
         }

         searchCancellable = $searchText.removeDuplicates()
             .debounce(for: 0.5, scheduler: RunLoop.main)
             .sink(receiveValue: { str in
                 if str != "" {
                     self.filterProductBySearch()
                 } else {
                     self.searchProducts = nil
                 }
             })
     }
     
     func filterProductByType() {
         DispatchQueue.global(qos: .userInteractive).async {
             let results = self.product
                 .lazy
                 .filter { product in
                     return product.type == self.productType.rawValue
                 }
                 .prefix(4)
             
             DispatchQueue.main.async {
                 self.filteredProducts = results.compactMap({ product in
                     return product
                 })
             }
         }
     }
     
     func filterProductBySearch() {
         DispatchQueue.global(qos: .userInteractive).async {
             let results = self.product
                 .lazy
                 .filter { product in
                     return product.title.lowercased().contains(self.searchText.lowercased())
                 }
             
             DispatchQueue.main.async {
                 self.searchProducts = results.compactMap({ product in
                     return product
                 })
             }
         }
     }
 }

 
