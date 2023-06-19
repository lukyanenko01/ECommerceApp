//
//  Home.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 06.06.2023.
//

import SwiftUI
import SDWebImageSwiftUI

let customFont = "Raleway-Regular"

struct Home: View {
    
    var animation: Namespace.ID
    
    @EnvironmentObject var sharedData:  SharedDataModel
    
    @StateObject var homeData: HomeViewModel = HomeViewModel()
    
    @State private var isMoreProductsViewPresented = false
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 15) {
                
                // Search Bar...
                
                ZStack {
                    if homeData.searchActivated {
                        SearchBar()
                        
                    } else {
                        SearchBar()
                            .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                    }
                }
                
                .frame(width: getRect().width / 1.6)
                .padding(.vertical)
                .padding(.horizontal, 25)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        homeData.searchActivated = true
                    }
                }
                
                Text("Замовляйте онлайн")
                    .font(.custom(customFont, size: 28).bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                // Products Tab...
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 18) {
                        ForEach(ProductType.allCases, id: \.self) { type in
                            
                            // Product Type View...
                            ProductTypeView(type: type)
                            
                        }
                    }
                    .padding(.horizontal,25)
                }
                .padding(.top,28)
                
                // Products Page...
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 25) {
                        
                        ForEach(homeData.filteredProducts) { product in
                            
                            // ProductCartView...
                            ProductCardView(product: product)
                        }
                        
                    }
                    .padding(.horizontal,25)
                    .padding(.bottom)
                    .padding(.top,80)
                }
                .padding(.top,30)
                
                // See More Button...
                
                Button {
                    homeData.showMoreProductsOnType.toggle()
                    homeData.filterProductByType()
                } label: {
                    
                    // Since we need image ar right...
                    Label {
                        Image(systemName: "arrow.right")
                    } icon: {
                        Text("Подивитись більше")
                    }
                    .font(.custom(customFont, size: 15).bold())
                    .foregroundColor(.orange)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)
                .padding(.top,10)
                
                
            }
            .padding(.vertical)
        }
        .disabled(homeData.isLoading) // блокируем интерфейс во время загрузки
        .blur(radius: homeData.isLoading ? 3 : 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("HomeBG"))
        
        
        
        // Updating data whenever tab changes...
        .onChange(of: homeData.productType) { newValue in
            homeData.filterProductByType()
        }
        
//        .fullScreenCover(isPresented: $homeData.showMoreProductsOnType) {
//            MoreProductsView(animation: animation)
//                .environmentObject(homeData)
//
//        }
        
        // More Products View
        .overlay(
            ZStack {
                if homeData.showMoreProductsOnType {
                    MoreProductsView(animation: animation)
                        .environmentObject(homeData)
                }
            }
        )

        // Displaying Search View...
        .overlay(
            
            ZStack {
                if homeData.searchActivated {
                    // MARK: - animation
                    SearchView(animation: animation)
                        .environmentObject(homeData)
                }
            }
            
        )
        
        // Индикатор загрузки
        if homeData.isLoading {
            ProgressView()
                .scaleEffect(2)
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
        }
        
        
    }
    
    
    
    // Since we're adding matched geometry effect...
    // avoiding code replication...
    @ViewBuilder
    func SearchBar() -> some View {
        HStack(spacing: 15) {
            Image(systemName: "magnifyingglass")
                .font(.title2)
                .foregroundColor(.gray)
            
            // Since we need a separate view for search bar...
            TextField("Пошук", text: .constant(""))
                .disabled(true)
            
        }
        .padding(.vertical,12)
        .padding(.horizontal)
        .background(
            Capsule()
                .strokeBorder(Color.gray, lineWidth: 0.8)
        )
    }
    
    @ViewBuilder
    func ProductCardView(product: Products) -> some View {
        VStack(spacing: 10) {
            
            ZStack {
                if let url = URL(string: product.productImage) {
                    if sharedData.showDetailProduct {
                        WebImage(url: url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        // This adds an activity indicator
                        
                    } else {
                        WebImage(url: url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .matchedGeometryEffect(id: "\(product.id)IMAGE", in: animation)
                        //.indicator(.activity) // This adds an activity indicator
                    }
                }
            }
            
            .frame(width: getRect().width / 2.5, height: getRect().width / 2.5)
            // Moving image
            .offset(y: -80)
            .padding(.bottom, -80)
            
            Text(product.title)
                .font(.custom(customFont, size: 18))
                .fontWeight(.semibold)
                .padding(.top)
            
            Text(product.description)
                .font(.custom(customFont, size: 14))
                .foregroundColor(.gray)
                .frame(width: 180, height: 80)
            
            Text("\(product.priceS) грн")
                .font(.custom(customFont, size: 16))
                .fontWeight(.bold)
                .foregroundColor(.orange)
                .padding(.top,5)
        }
        .padding(.horizontal,20)
        .padding(.bottom,22)
        .background(
            Color.white
                .cornerRadius(25)
        )
        .onTapGesture {
            withAnimation(.easeInOut) {
                sharedData.detailProduct = product
                sharedData.showDetailProduct = true
                
            }
        }
        
    }
    
    @ViewBuilder
    func ProductTypeView(type: ProductType) -> some View {
        
        Button {
            // Updating Current Type...
            withAnimation {
                homeData.productType = type
            }
        } label: {
            
            Text(type.rawValue)
                .font(.custom(customFont, size: 15))
                .fontWeight(.semibold)
            // Changing Color based on Current product Type...
                .foregroundColor(homeData.productType == type ? Color.orange : Color.gray)
                .padding(.bottom,10)
                .overlay (
                    
                    // Adding Matched Geometry Effect...
                    ZStack {
                        if homeData.productType == type {
                            Capsule()
                                .fill(Color.orange)
                                .matchedGeometryEffect(id: "PRODUCTTAB", in: animation)
                                .frame(height: 2)
                        } else {
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 2)
                        }
                    }
                        .padding(.horizontal, -5)
                    ,alignment: .bottom
                )
        }
        
        
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}


class ImageLoader: ObservableObject {
    @Published var imageData = Data()
    
    func load(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    self.imageData = data
                }
            }
        }.resume()
    }
}

struct AsyncImage: View {
    @ObservedObject private var loader = ImageLoader()
    
    var url: URL
    
    init(url: URL) {
        self.url = url
        loader.load(url: url)
    }
    
    var body: some View {
        if let uiImage = UIImage(data: loader.imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            ProgressView() // Or another placeholder
        }
    }
}
