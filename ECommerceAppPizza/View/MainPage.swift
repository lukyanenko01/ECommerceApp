//
//  MainPage.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 05.06.2023.
//

import SwiftUI

struct MainPage: View {
    
    // Current Tab...
    @State var currenTab: Tab = .Home
    
    // Hiding Tab Bar...
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        // Tab View...
        VStack(spacing: 0) {
            
            TabView(selection: $currenTab) {
                
                Home()
                    .tag(Tab.Home)
                
                Text("Liked")
                    .tag(Tab.Liked)
                
                ProfilePage()
                    .tag(Tab.Profile)
                
                Text("Cart")
                    .tag(Tab.Cart)
            }
            
            // Custom Tab Bar...
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    
                    Button {
                        currenTab = tab
                    } label: {
                        Image(systemName: tab.rawValue)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                        // Applying little shadow at bg...
                            .background(
                                Color.orange
                                    .opacity(0.1)
                                    .cornerRadius(5)
                                // blurring
                                    .blur(radius: 5)
                                    .padding(-7)
                                    .opacity(currenTab == tab ? 1 : 0)
                            )
                            .frame(maxWidth: .infinity)
                            .foregroundColor(currenTab == tab ? .orange : .black.opacity(0.3))
                    }
                }
            }
            .padding([.horizontal, .top])
            .padding(.bottom,10)
        }
        .background(Color("HomeBG").ignoresSafeArea())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}


// Tab Cases...
enum Tab: String, CaseIterable {
    
    // Raw Value must be image Name in asset or systemnaym
    case Home = "house.fill"
    case Liked = "heart.fill"
    case Profile = "person.fill"
    case Cart = "cart.fill"
}
