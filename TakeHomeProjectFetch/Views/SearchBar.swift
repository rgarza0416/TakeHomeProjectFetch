//
//  SearchBar.swift
//  TakeHomeProjectFetch
//
//  Created by Ricardo Garza on 5/29/25.
//

import SwiftUI


struct SearchBar: View {
    @Binding var text: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search recipes...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(colorScheme == .dark ? Color(.systemGray5) : Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    SearchBar(text: .constant("Search something"))
}

