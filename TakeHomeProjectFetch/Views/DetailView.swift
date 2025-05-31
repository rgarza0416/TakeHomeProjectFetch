//
//  DetailView.swift
//  TakeHomeProjectFetch
//
//  Created by Ricardo Garza on 5/29/25.
//

import SwiftUI

struct DetailView: View {
    
    let nameOfDish: String
    let cuisineType: String
    let imageUrl: String?
    let recipeLink: String?
    let youtubeLink: String?
    
    
    var body: some View {
        ZStack {
            ScrollView {
                
                photo
                
                VStack(alignment: .leading, spacing: 18) {
                    
                    Group {
                        generalInfo
                        link
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 11)
                    .background(Color.primary.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding()
            }
        }
        .navigationTitle("Details")
    }
}

#Preview {
    NavigationStack {
        DetailView(nameOfDish: "Enchilada", cuisineType: "Mexican", imageUrl: "", recipeLink: "www.google.com", youtubeLink: "www.youtube.com")
    }
}

private extension DetailView {
    
    var photo: some View {
        
        AsyncImage(url: URL(string: imageUrl ?? "")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
        } placeholder: {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.7))
                ProgressView()
            }
        }
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .padding(.horizontal)
    }
    
    
    
    @ViewBuilder
    var link: some View {
        
        if let recipeUrlString = recipeLink,
           let url = URL(string: recipeUrlString) {
            
            Link(destination: url) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recipe Link")
                        .foregroundColor(.primary)
                        .font(.body)
                        .fontWeight(.semibold)
                    
                    Text(recipeLink ?? "")
                        .multilineTextAlignment(.leading)
                    
                }
                
                Spacer()
                
                Label("", systemImage: "link")
                    .font(.title3)
                    .bold()
            }
        }
        
        if let youtubeUrlString = youtubeLink,
           let url = URL(string: youtubeUrlString) {
            
            Link(destination: url) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Youtube Link")
                        .foregroundColor(.primary)
                        .font(.body)
                        .fontWeight(.semibold)
                    
                    Text(youtubeLink ?? "")
                        .multilineTextAlignment(.leading)
                    
                }
                
                Spacer()
                
                Label("", systemImage: "link")
                    .font(.title3)
                    .bold()
            }
        }
    }
    
    
    var generalInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            dishName
            cuisineName
        }
    }
    
    @ViewBuilder
    var dishName: some View {
        Text("Name of Dish")
            .font(.headline)
            .fontWeight(.semibold)
        
        Text(nameOfDish)
            .font(.subheadline)
        
        Divider()
    }
    
    @ViewBuilder
    var cuisineName: some View {
        Text("Cuisine Type")
            .font(.headline)
            .fontWeight(.semibold)
        
        Text(cuisineType)
            .font(.subheadline)
        
    }
    
    @ViewBuilder
    var recipeLinkView: some View {
        Text("Recipe Link")
            .font(.headline)
            .fontWeight(.semibold)
        
        Text(recipeLink ?? "")
            .font(.subheadline)
        
        Divider()
    }
    
    @ViewBuilder
    var youtubeLinkView: some View {
        
        Text("Youtube Link")
            .font(.headline)
            .fontWeight(.semibold)
        
        Text(youtubeLink ?? "")
            .font(.subheadline)
    }
}

