//
//  ProductDetailView.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 07.06.2023.
//

import SwiftUI

struct ProductDetailView: View {
    var product: Product
    
    // For Matched Geometry Effect...
    var animation: Namespace.ID
    
    
    // Shared Data Model...
    @EnvironmentObject var shareData: SharedDataModel
    
//    @EnvironmentObject var homeData: HomeViewModel
    
    var body: some View {
        VStack {
            
            // TitleBar and Product Image...
            VStack {
                // Title Bar...
                HStack {
                    
                    Button {
                        withAnimation(.easeInOut) {
                            shareData.showDetailProduct = false
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(Color.black.opacity(0.7))
                    }
                    Spacer()
                    
                    
                    Button {
                        addToLiked()
                    } label: {
                        Image(systemName: "heart.fill")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                            .foregroundColor(isLiked() ? .red : Color.black.opacity(0.7))
                        

                    }

                    
                }
                .padding()
                
                
                Image(product.productImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .matchedGeometryEffect(id: "\(product.id)\(shareData.fromSearchPage ? "SEARCH" : "IMAGE")", in: animation)
                    .padding(.horizontal)
                    .offset(y: -12)
                    .frame(maxHeight: .infinity)
            }
            .frame(height: getRect().height / 2.7)
            .zIndex(1)
            
            // Product Details...
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    Text(product.title)
                        .font(.custom(customFont, size: 20).bold())
                    
                    Text(product.subtitle)
                        .font(.custom(customFont, size: 18))
                        .foregroundColor(.gray)
                        .padding(.top)
                    
                    Text("Соус з томатів пелаті, моцарела, дорблю, маскарпоне, грана падана, оливкова олія, орегано")
                        .font(.custom(customFont, size: 15))
                        .foregroundColor(.gray)
                    
                    Button {
                        addToCart()
                    } label: {
                        
                        Label {
                            Image(systemName: "arrow.right")
                        } icon: {
                            Text("Fuul description")
                        }
                        .font(.custom(customFont, size: 15).bold())
                        .foregroundColor(.orange)
                        
                    }
                    
                    HStack {
                        Text("Total")
                            .font(.custom(customFont, size: 17))
                        
                        Spacer()
                        Text("\(product.price)")
                            .font(.custom(customFont, size: 20).bold())
                            .foregroundColor(.orange)
                    }
                    .padding(.vertical,20)
                    
                    Button {
                        addToCart()
                    } label: {
                        Text("\(isAddedToCart() ? "added" : "add") to basket")
                            .font(.custom(customFont, size: 20).bold())
                            .foregroundColor(.white)
                            .padding(.vertical,20)
                            .frame(maxWidth: .infinity)
                            .background(
                                Color.orange
                                    .cornerRadius(15)
                                    .shadow(color: .black.opacity(0.06), radius: 5, x: 5, y: 5)
                            )
                    }

                    
                }
                .padding([.horizontal, .bottom], 20)
                .padding(.top,25)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                
                Color.white
                    .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 25))
                    .ignoresSafeArea()
            
            )
            .zIndex(0)
        }
        .animation(.easeInOut, value: shareData.likedProducts)
        .animation(.easeInOut, value: shareData.cartProducts)
        .background(Color("HomeBG").ignoresSafeArea())
    }
    
    func isLiked() -> Bool {
        return shareData.likedProducts.contains { product in
            return self.product.id == product.id
        }
    }
    
    func isAddedToCart() -> Bool {
        return shareData.cartProducts.contains { product in
            return self.product.id == product.id
        }
    }
    
    func addToLiked() {
        
        if let index = shareData.likedProducts.firstIndex(where: { product in
            return self.product.id == product.id
        }) {
            // Remove from liked...
            shareData.likedProducts.remove(at: index)
        } else {
            shareData.likedProducts.append(product)
        }
        
    }
    
    func addToCart() {
        if let index = shareData.cartProducts.firstIndex(where: { product in
            return self.product.id == product.id
        }) {
            // Remove from liked...
            shareData.cartProducts.remove(at: index)
        } else {
            shareData.cartProducts.append(product)
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
//        ProductDetailView(product: HomeViewModel().product[0])
//            .environmentObject(SharedDataModel())
        MainPage()
    }
}
