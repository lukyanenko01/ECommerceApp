//
//  IntroView.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 20.06.2023.
//

import SwiftUI

struct IntroView<ActionView: View>: View {
    @Binding var intro: PageIntro
    var size: CGSize
    var actionView: ActionView

    init(intro: Binding<PageIntro>, size: CGSize, @ViewBuilder actionView: @escaping () -> ActionView) {
        self._intro = intro
        self.size = size
        self.actionView = actionView()
    }
    
    /// Animation Properties
    @State private var showView: Bool = false
    @State private var hideWholeView: Bool = false

    var body: some View {
        VStack {
            GeometryReader {
                let size = $0.size
                
                Image(intro.introAssetImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: size.width, height: size.height)
            }
            //Moving UP
            .offset(y: showView ? 0 : -size.height / 2)
            .opacity(showView ? 1 : 0)
            
            VStack(alignment: .leading, spacing: 10) {
                Spacer(minLength: 0)
                Text(intro.title)
                    .font(.system(size: 40))
                    .fontWeight(.black)
                
                Text(intro.subTitle)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 15)
                
                if !intro.displaysAction {
                    Group {
                        Spacer(minLength: 25)
                        
                        CustomIndicatorView(totalProgress: filteredPages.count, currentPage: filteredPages.firstIndex(of: intro) ?? 0)
                            .frame(maxWidth: .infinity)
                        
                        Spacer(minLength: 10)
                        
                        Button {
                            changeIntro()
                        } label: {
                            Text("Next")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: size.width * 0.4)
                                .padding(.vertical, 15)
                                .background(
                                    Capsule()
                                        .fill(.orange)
                                )
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                } else {
                    actionView
                        .offset(y: showView ? 0 : size.height / 2)
                        .opacity(showView ? 1 : 0)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            ///Moving Down
            .offset(y: showView ? 0 : size.height / 2)
            .opacity(showView ? 1 : 0)
            
        }
        .offset(y: hideWholeView ? size.height / 2 : 0)
        .opacity(hideWholeView ? 0 : 1)
        ///Back Button
        .overlay(alignment: .topLeading) {
            if intro != pageIntros.first {
                Button {
                    changeIntro(true)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2.bold())
                        ///.fontWeight(.semibold)
                        .foregroundColor(.black)
                        .contentShape(Rectangle())
                }
                .padding(10)
                .offset(y: showView ? 0 : -200)
                .offset(y: hideWholeView ? -200 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0).delay(0.1)) {
                showView = true
            }
        }
    }
    
    func changeIntro(_ isPrevious: Bool = false) {
        
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0)) {
            hideWholeView = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ///Updating Page
            if let index = pageIntros.firstIndex(of: intro), (isPrevious ? index != 0 : index != pageIntros.count - 1) {
                intro = isPrevious ? pageIntros[index - 1] : pageIntros[index + 1]
            } else {
                intro = isPrevious ? pageIntros[0] : pageIntros[pageIntros.count - 1]
            }
            /// Re-Animation as Split Page
            hideWholeView = false
            showView = false
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0)) {
                showView = true
            }
        }
        

    }
    
    var filteredPages: [PageIntro] {
        return pageIntros.filter { !$0.displaysAction }
    }
    
}

struct PageIntro: Identifiable, Hashable {
    
    var id: UUID = .init()
    var introAssetImage: String
    var title: String
    var subTitle: String
    var displaysAction: Bool = false
    
}

var pageIntros: [PageIntro] = [
    .init(introAssetImage: "unboarding1", title: "ПіцаАЄПіцаАЄПіцаАЄПіцаАЄ", subTitle: "ПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄ"),
    .init(introAssetImage: "unboarding2", title: "ПіцаАЄПіцаАЄПіцаАЄПіцаАЄ", subTitle: "ПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄ"),
    .init(introAssetImage: "unboarding3", title: "ПіцаАЄПіцаАЄПіцаАЄПіцаАЄ", subTitle: "ПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄПіцаАЄ", displaysAction: true)
]


struct CustomIndicatorView: View {
    
    var totalProgress: Int
    var currentPage: Int
    var activeTint: Color = .black
    var inActiveTint: Color = .gray.opacity(0.5)
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalProgress, id: \.self) {
                Circle()
                    .fill(currentPage == $0 ? activeTint : inActiveTint)
                    .frame(width: 4, height: 4)
            }
        }
    }
}
