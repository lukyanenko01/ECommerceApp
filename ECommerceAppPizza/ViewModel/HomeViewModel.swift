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



class HomeViewModel: ObservableObject {
    
    @Published var productType: ProductType = .Wearable
    
    @Published var product: [Product] = [
        Product(type: .Wearable, title: "Apple Watch", subtitle: "Serias 6: Red", price: "$359", productImage: "Wearable"),
        Product(type: .Wearable, title: "Apple Watch", subtitle: "Serias 6: Red", price: "$359", productImage: "Wearable"),
        Product(type: .Wearable, title: "Apple Watch", subtitle: "Serias 6: Red", price: "$359", productImage: "Wearable"),
        Product(type: .Wearable, title: "Apple Watch", subtitle: "Serias 6: Red", price: "$359", productImage: "Wearable"),
        Product(type: .Phones, title: "Apple Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Phones"),
        Product(type: .Phones, title: "Apple Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Phones"),
        Product(type: .Phones, title: "Apple Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Phones"),
        Product(type: .Phones, title: "Apple Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Phones"),
        Product(type: .Phones, title: "Apple Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Phones"),
        Product(type: .Phones, title: "Apple Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Phones"),
        Product(type: .Tablets, title: "Tablets Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Tablets"),
        Product(type: .Tablets, title: "Tablets Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Tablets"),
        Product(type: .Tablets, title: "Tablets Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Tablets"),
        Product(type: .Tablets, title: "Tablets Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Tablets"),
        Product(type: .Tablets, title: "Tablets Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Tablets"),
        Product(type: .Laprops, title: "Laprops Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Laprops"),
        Product(type: .Laprops, title: "Laprops Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Laprops"),
        Product(type: .Laprops, title: "Laprops Phones", subtitle: "Serias 6: Red", price: "$359", productImage: "Laprops")
    ]
    
    //Filtred Products...
    @Published var filteredProducts: [Product] = []
    
    // More products on the type..
    @Published var showMoreProductsOnType: Bool = false
    
    // Search Data...
    @Published var searchText: String = ""
    @Published var searchActivated: Bool = false
    @Published var searchProducts: [Product]?
    
    var searchCancellable: AnyCancellable?

    
    init() {
        filterProductByType()
        
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
            // since it will require more memory so were using lazy to perform more
            
                .lazy
                .filter { product in
                    return product.type == self.productType
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
            // since it will require more memory so were using lazy to perform more
            
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
