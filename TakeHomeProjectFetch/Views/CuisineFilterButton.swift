//
//  CuisineFilterButton.swift
//  TakeHomeProjectFetch
//
//  Created by Ricardo Garza on 5/29/25.
//

import SwiftUI

struct CuisineFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected
                        ? Color.blue
                        : (colorScheme == .dark ? Color(.systemGray5) : Color.gray.opacity(0.1))
                )
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Preview unselected state
        CuisineFilterButton(
            title: "American",
            isSelected: false,
            action: {}
        )
        
        // Preview selected state
        CuisineFilterButton(
            title: "Italian",
            isSelected: true,
            action: {}
        )
    }
    .padding()
}

