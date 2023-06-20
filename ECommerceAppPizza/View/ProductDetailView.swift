//
//  ProductDetailView.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 07.06.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductDetailView: View {
    var product: Products
    
    @State var cheeseBord: Bool = false

    
    @State var size = 0
    
    var selectedPrice: Int {
        switch size {
        case 0:
            return product.priceS
        case 1:
            return product.priceM + cheesePrice
        case 2:
            return product.priceXl + cheesePrice
        default:
            return product.priceS
        }
    }
    
    var cheesePrice: Int {
        switch size {
        case 1:
            return cheeseBord ? product.cheeseM : 0
        case 2:
            return cheeseBord ? product.cheeseXl : 0
        default:
            return 0
        }
    }


    
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
                
                if let url = URL(string: product.productImage) {
                    WebImage(url: url)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .matchedGeometryEffect(id: "\(product.id)\(shareData.fromSearchPage ? "SEARCH" : "IMAGE")", in: animation)
                        .padding(.horizontal)
                        .offset(y: -12)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(height: getRect().height / 2.7)
            .zIndex(1)
            
            // Product Details...
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    Text(product.title)
                        .font(.custom(customFont, size: 20).bold())
                    
                    Text(product.description)
                        .font(.custom(customFont, size: 18))
                        .foregroundColor(.gray)
                        .padding(.top)
                    
                    if product.type == "Піца" {
                        CustomSegmentedControl(selectedSegment: $size, segments: ["S", "M", "Xl"])
                    }
                    
                    if product.type == "Піца" && size != 0 {
                        HStack {
                            Spacer()
                            Toggle(isOn: $cheeseBord) {
                                
                                Text("Сирний борт")
                                    .font(.custom(customFont, size: 17))
                                
                            }
                            .fixedSize()
                            .toggleStyle(OrangeToggleStyle())
                            
                        }
                        .padding()
                    }
                    
                    HStack {
                        Text("Ціна")
                            .font(.custom(customFont, size: 17))
                        
                        Spacer()
                        Text("\(selectedPrice) грн")
                            .font(.custom(customFont, size: 20).bold())
                            .foregroundColor(.orange)
                    }
                    .padding(.vertical,20)
                    
                    Button {
                        addToCart()
                    } label: {
                        Text("\(isAddedToCart() ? "Прибрати з корзини" : "Добавити в корзину")")
                            .font(.custom(customFont, size: 20).bold())
                            .foregroundColor(.white)
                            .padding(.vertical,20)
                            .frame(maxWidth: .infinity)
                        
                            .background(
                                isAddedToCart() ? Color.red : Color.orange
                                )
                                    .cornerRadius(15)
                                    .shadow(color: .black.opacity(0.06), radius: 5, x: 5, y: 5)
                            
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
    
//    func addToCart() {
//        var productToAdd = product
//        productToAdd.size = ["S", "M", "Xl"][size]
//        productToAdd.cheeseCrust = cheeseBord  // обновить значение cheeseCrust
//        shareData.cartProducts.append(productToAdd)
//    }

    
    func addToCart() {
        if let index = shareData.cartProducts.firstIndex(where: { cartProduct in
            return self.product.id == cartProduct.id
        }) {
            // Remove from cart...
            shareData.cartProducts.remove(at: index)
        } else {
            var productToAdd = product
            productToAdd.size = ["S", "M", "Xl"][size]
            productToAdd.cheeseCrust = cheeseBord  // обновить значение cheeseCrust
            shareData.cartProducts.append(productToAdd)
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

struct OrangeToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Spacer()

            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(configuration.isOn ? Color.orange : Color.gray)
                .frame(width: 50, height: 29)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .padding(3)
                        .offset(x: configuration.isOn ? 10 : -10)
                )
                .animation(.spring(), value: configuration.isOn)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
