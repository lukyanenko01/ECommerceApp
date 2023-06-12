//
//  CustomSegmentedControl.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 12.06.2023.
//

import SwiftUI


struct CustomSegmentedControl: View {
    @Binding var selectedSegment: Int
    var segments: [String]
    var details: [String]? = nil
    var hasDetails: Bool = false
    
    var body: some View {
        HStack {
            ForEach(0..<segments.count) { index in
                Button(action: {
                    withAnimation {
                        selectedSegment = index
                    }
                }) {
                    VStack(spacing: hasDetails ? 8 : nil) {
                        Text(segments[index])
                            .font(.system(size: 12).bold())
                        if hasDetails {
                            Text(details?[index] ?? "")
                                .font(.system(size: 12))
                                .padding(4)
                        }
                    }
                    .padding(.vertical, hasDetails ? 3 : 15)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(7)
                    .background(Color(selectedSegment == index ? UIColor.orange : .clear))
                    .foregroundColor(Color(selectedSegment == index ? .white : .black))
                    .cornerRadius(5)
                }
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(7)
        .padding(.horizontal, 20)
    }
}



