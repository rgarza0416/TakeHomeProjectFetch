//
//  RecipeItemView.swift
//  TakeHomeProjectFetch
//
//  Created by Ricardo Garza on 5/29/25.
//

import SwiftUI
import Combine

struct RecipeItemView: View {
    
    let recipe: String
    let nameOfRecipe: String
    let cuisineType: String
    let imageUrl: String?
    let cache = PhotoCacheViewModel()
    
    @State private var loadedImage: UIImage? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            
            if let loadedImage = loadedImage {
                Image(uiImage: loadedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 175, height: 130)
                    .clipped()
            } else {
                ZStack {
                    Rectangle().fill(Color.gray.opacity(0.7))
                    ProgressView()
                }
                .frame(width: 175, height: 130)
                .task {
                    if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                        loadedImage = await loadImage(from: url, cache: cache)
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text(cuisineType)
                    .foregroundColor(.primary)
                    .font(.footnote)
                    .fontWeight(.light)
                
                Text(nameOfRecipe)
                    .foregroundColor(.primary)
                    .font(.body)
                    .bold()
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
            }
            .frame(width: 159, height: 45, alignment: .leading)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Color.primary.opacity(0.15))
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 6, x: 0, y: 1)
    }
}

#Preview {
    RecipeItemView(recipe: "0", nameOfRecipe: "Enchiladas", cuisineType: "Mexican", imageUrl: "")
        .frame(width: 175)
}
