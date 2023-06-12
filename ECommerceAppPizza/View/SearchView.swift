//
//  SearchView.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 06.06.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    
    var animation: Namespace.ID
    
    // Shared Data
    @EnvironmentObject var sharedData: SharedDataModel
    
    @EnvironmentObject var homeData: HomeViewModel
    
    // Activating Text Field with the help of FocusState
    
    @FocusState var startTF: Bool
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // Search Bar..
            HStack(spacing: 20) {
                Button {
                    withAnimation {
                        homeData.searchActivated = false
                    }
                    homeData.searchText = ""
                    // Resetting...
                    sharedData.fromSearchPage = false
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(Color.black.opacity(0.7))
                }

                //Search Bar...
                HStack(spacing: 15) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    // Since we need a separate view for search bar...
                    TextField("Пошук", text: $homeData.searchText)
                        .focused($startTF)
                        .textCase(.lowercase)
                        .disableAutocorrection(true)
                    
                }
                .padding(.vertical,12)
                .padding(.horizontal)
                .background(
                    Capsule()
                        .strokeBorder(Color.orange, lineWidth: 1.5)
                )
                .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                .padding(.trailing,20)
            }
            .padding([.horizontal])
            .padding(.top)
            .padding(.bottom,10)
            
            // Showing Progress if searching...
            // else showing no results found if empty...
            if let products = homeData.searchProducts {
                
                if products.isEmpty{
                    
                    // No Results Found...
                    VStack(spacing: 10) {
                        //TODO: - вставить Lottie
//                        Image("NotFound")
//                            .resizable()
                        //  .aspectRatio(contentMode: .Fit)
//                            .padding(.top,60)
                        
                        Text("Нічого не знайденно")
                            .font(.custom(customFont, size: 22).bold())
                        
                        Text("Спробуй ще раз")
                            .font(.custom(customFont, size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,30)
                    }
                    .padding()
                    
                } else {
                    // Filter Results...
                    ScrollView(.vertical, showsIndicators: false) {
                            
                        VStack(spacing: 0) {
                            
                            Text("Знайденно \(products.count) результатів")
                                .font(.custom(customFont, size: 24).bold())
                                .padding(.vertical)
                            
                            StraggeredGrid(columns: 2, spacing: 20, list: products) { product in
                                // Card View...
                                ProductCardView(product: product)
                            }
                        }
                        .padding()
                        
                    }
                }
                
            } else {
                ProgressView()
                    .padding(.top, 30)
                    .opacity(homeData.searchText == "" ? 0 : 1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Color("HomeBG")
                .ignoresSafeArea()
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startTF = true
            }
        }
        
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
            
            Text("\(product.priceS)")
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
