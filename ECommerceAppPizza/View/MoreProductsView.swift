//
//  MoreProductsView.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 06.06.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct MoreProductsView: View {
    
    @Environment(\.presentationMode) var presentationMode

    var animation: Namespace.ID
    
    // Shared Data
    @EnvironmentObject var sharedData: SharedDataModel
    
    @EnvironmentObject var homeData: HomeViewModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // Search Bar..
            HStack {
                Button {
                    withAnimation {
                        self.homeData.showMoreProductsOnType = false
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(Color.black.opacity(0.7))
                }

                Spacer()

                Text(homeData.productType.rawValue)
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(Color.clear)
                }
            }
            .padding([.horizontal])
            .padding(.top)
            .padding(.bottom,10)





            // Products...
            ScrollView(.vertical, showsIndicators: false) {
                StraggeredGrid(columns: 2, showsIndicators: false, spacing: 20, list: homeData.filteredProducts) { product in
                    ProductCardView(product: product)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color("HomeBG").ignoresSafeArea())
    }
    
    @ViewBuilder
    func ProductCardView(product: Products) -> some View {
        VStack(spacing: 10) {
            ZStack {
                if let url = URL(string: product.productImage) {
                    if sharedData.showDetailProduct{
                        WebImage(url: url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .opacity(0)
                    } else {
                        WebImage(url: url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .matchedGeometryEffect(id: "\(product.id)SEARCH", in: animation)
                    }
                }
            }
            // Moving image
                .offset(y: -50)
                .padding(.bottom, -50)
            
            Text(product.title)
                .font(.custom(customFont, size: 18))
                .fontWeight(.semibold)
                .padding(.top)
            
            Text(product.description)
                .font(.custom(customFont, size: 14))
                .foregroundColor(.gray)
            
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
        .padding(.top,50)
        .onTapGesture {
            withAnimation(.easeInOut) {
                sharedData.fromSearchPage = true
                sharedData.detailProduct = product
                sharedData.showDetailProduct = true
                
            }
        }
        
    }
}

struct MoreProductsView_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
