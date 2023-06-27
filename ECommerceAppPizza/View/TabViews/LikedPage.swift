//
//  LikedPage.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 08.06.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct LikedPage: View {
    @StateObject private var viewModel = LikedPageViewModel()

    // Delete Option...
    @State var showDeleteOption: Bool = false
    
    var body: some View {
        
        NavigationView {
            if viewModel.isLoading {
                         ProgressView()
                             .scaleEffect(2, anchor: .center)
                             .progressViewStyle(CircularProgressViewStyle(tint: Color.orange))
                             .frame(maxWidth: .infinity, maxHeight: .infinity)
                             .navigationBarHidden(true)
                             .frame(maxWidth: .infinity, maxHeight: .infinity)
                             .background(
                             
                                 Color("HomeBG")
                                     .ignoresSafeArea()
                             
                             )
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack {
                        
                        HStack {
                            Text("Улюблене")
                                .font(.custom(customFont, size: 28).bold())
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    showDeleteOption.toggle()
                                }
                            } label: {
                                Image(systemName: "trash.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.orange)
                                    .frame(width: 22, height: 22)
                                
                            }
                            .opacity(viewModel.favoriteProducts.isEmpty ? 0 : 1)
                            
                        }
                        
                        // Cheking if liked products are empty
                        if viewModel.favoriteProducts.isEmpty {
                            EmptyFavoritesView()
                        } else {
                            // Displaying Products...
                            VStack(spacing: 15) {
                                
                                
                                ForEach(viewModel.favoriteProducts) { product in
                                    
                                    HStack(spacing: 0) {
                                        
                                        if showDeleteOption {
                                            Button {
                                                viewModel.deleteProduct(product: product)
                                            } label: {
                                                Image(systemName: "minus.circle.fill")
                                                    .font(.title2)
                                                    .foregroundColor(.red)
                                            }
                                            .padding(.trailing)
                                            
                                        }
                                        
                                        CardView(product: product)
                                    }
                                }
                            }
                            .padding(.top,25)
                            .padding(.horizontal)
                        }
                        
                        if AuthService.shared.currentUser == nil  {
                            
                            Group {
                                Button {
                                    AppRouter.switchRootView(to: AuthView().preferredColorScheme(.light))
                                } label: {
                                    Text("Залогінитися")
                                        .font(.custom(customFont, size: 18).bold())
                                        .foregroundColor(.white)
                                        .padding(.vertical,18)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.orange)
                                        .cornerRadius(15)
                                        .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)
                                }
                            }
                            .padding(.horizontal,25)
                            
                        }
                        
                        
                    }
                    .padding()
                }
                .navigationBarHidden(true)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                
                    Color("HomeBG")
                        .ignoresSafeArea()
                
                )
            }

        }
        .onAppear {
            viewModel.fetchFavoriteProducts()
            showDeleteOption = false
        }
    }
    
    @ViewBuilder
    func CardView(product: Products) -> some View {
        HStack(spacing: 15) {
            if let url = URL(string: product.productImage) {
                WebImage(url: url)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(product.title)
                    .font(.custom(customFont, size: 18).bold())
                    .lineLimit(1)
                
                Text(product.description)
                    .font(.custom(customFont, size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
                
            }
        }
        .padding(.horizontal,10)
        .padding(.vertical,10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
        
            Color.white
                .cornerRadius(10)
            
        
        )
    }
}

struct LikedPage_Previews: PreviewProvider {
    static var previews: some View {
        LikedPage()
    }
}


//    func deleteProduct(product: Products) {
//        if let index = sharedData.likedProducts.firstIndex(where: { currentProduct in
//            return product.id ==  currentProduct.id
//        }) {
//            let _ = withAnimation {
//                // removing...
//                sharedData.likedProducts.remove(at: index)
//            }
//        }
//    }
