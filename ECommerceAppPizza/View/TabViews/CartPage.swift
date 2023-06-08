//
//  CartPage.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 08.06.2023.
//

import SwiftUI

struct CartPage: View {
    @EnvironmentObject var sharedData: SharedDataModel
    
    // Delete Option...
    @State var showDeleteOption: Bool = false
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 10) {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack {
                        
                        HStack {
                            Text("Basket")
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
                            .opacity(sharedData.cartProducts.isEmpty ? 0 : 1)
                            
                        }
                        // Cheking if liked products are empty
                        if sharedData.cartProducts.isEmpty {
                            Group {
                                Image("noLike")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                                    .padding(.top,35)
                                
                                Text("No items added")
                                    .font(.custom(customFont, size: 25))
                                    .fontWeight(.semibold)
                                
                                Text("Hit the plus button to save itno basket.")
                                    .font(.custom(customFont, size: 18))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                    .padding(.top,10)
                                    .multilineTextAlignment(.center)
                                
                            }
                            
                        } else {
                            // Displaying Products...
                            VStack(spacing: 15) {
                                
                                
                                ForEach($sharedData.cartProducts) { $product in
                                    
                                    HStack(spacing: 0) {
                                        
                                        if showDeleteOption {
                                            Button {
                                                deleteProduct(product: product)
                                            } label: {
                                                Image(systemName: "minus.circle.fill")
                                                    .font(.title2)
                                                    .foregroundColor(.red)
                                            }
                                            .padding(.trailing)
                                            
                                        }
                                        
                                        CardView(product: $product)
                                    }
                                }
                            }
                            .padding(.top,25)
                            .padding(.horizontal)
                        }
                        
                    }
                    .padding()
                }
                
                // Showing Total and chek out Button...
                if !sharedData.cartProducts.isEmpty {
                    
                    Group {
                        HStack {
                            Text("Total")
                                .font(.custom(customFont, size: 14))
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(sharedData.getTotalPrice())
                                .font(.custom(customFont, size: 18).bold())
                                .foregroundColor(.orange)
                        }
                        
                        Button {
                            
                        } label: {
                            Text("Checkout")
                                .font(.custom(customFont, size: 18).bold())
                                .foregroundColor(.white)
                                .padding(.vertical,18)
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)
                        }
                        .padding(.vertical)
                        
                    }
                    .padding(.horizontal,25)
                    
                }
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                
                Color("HomeBG")
                    .ignoresSafeArea()
                
            )
        }
        
    }
    
    func deleteProduct(product: Product) {
        if let index = sharedData.cartProducts.firstIndex(where: { currentProduct in
            return product.id ==  currentProduct.id
        }) {
            let _ = withAnimation {
                // removing...
                sharedData.cartProducts.remove(at: index)
            }
        }
    }
    
}


struct CartPage_Previews: PreviewProvider {
    static var previews: some View {
        CartPage()
    }
}


struct CardView: View {
    
    // Making Product as Binding so as update in Real time...
    @Binding var product: Product
    
    var body: some View {
        HStack(spacing: 15) {
            Image(product.productImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.title)
                    .font(.custom(customFont, size: 18).bold())
                    .lineLimit(1)
                
                Text(product.subtitle)
                    .font(.custom(customFont, size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
                
                // Quantity Buttons...
                HStack(spacing: 10) {
                    Text("Quantity")
                        .font(.custom(customFont, size: 14))
                        .foregroundColor(.gray)
                    
                    Button {
                        product.quantity = (product.quantity > 0 ? (product.quantity - 1) : 0)
                    } label: {
                        Image(systemName: "minus")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .frame(width: 20, height: 20)
                            .background(Color("Quantity"))
                            .cornerRadius(4)
                    }
                    
                    Text("\(product.quantity)")
                        .font(.custom(customFont, size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Button {
                        product.quantity += 1
                    } label: {
                        Image(systemName: "plus")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .frame(width: 20, height: 20)
                            .background(Color("Quantity"))
                            .cornerRadius(4)
                    }

                }
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
