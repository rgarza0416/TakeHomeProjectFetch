//
//  RecipesView.swift
//  TakeHomeProjectFetch
//
//  Created by Ricardo Garza on 5/29/25.
//

import SwiftUI


struct RecipesView: View {
    @StateObject var viewModel = RecipesViewModel()
    @State private var selectedRecipe: RecipeModel?
    @Environment(\.colorScheme) private var colorScheme

    private let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.05).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if !viewModel.isEmptyState && viewModel.errorMessage == nil {
                        VStack(spacing: 12) {
                            SearchBar(text: $viewModel.searchText)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.availableCuisines, id: \.self) { cuisine in
                                        CuisineFilterButton(
                                            title: cuisine,
                                            isSelected: viewModel.selectedCuisine == cuisine
                                        ) {
                                            if viewModel.selectedCuisine == cuisine {
                                                viewModel.selectedCuisine = nil
                                            } else {
                                                viewModel.selectedCuisine = cuisine
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                        .background(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                    }
                    
                    if viewModel.isLoading {
                        ProgressView("Loading Recipes...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.isEmptyState {
                        VStack {
                            Image(systemName: "tray.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .foregroundColor(.gray)
                            Text("No recipes available.")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    } else if let error = viewModel.errorMessage {
                        VStack {
                            Text(error)
                                .foregroundColor(.red)
                                .padding()
                            Button("Retry") {
                                Task {
                                    await viewModel.refreshRecipes()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.filteredRecipes, id: \.self) { item in
                                    NavigationLink {
                                        DetailView(nameOfDish: item.name, cuisineType: item.cuisine, imageUrl: item.photoUrlLarge, recipeLink: item.sourceUrl, youtubeLink: item.youtubeUrl)
                                    } label: {
                                        RecipeItemView(recipe: item.uuid, nameOfRecipe: item.name, cuisineType: item.cuisine, imageUrl: item.photoUrlSmall)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.refreshRecipes()
            }
            .navigationTitle(Text("Recipes"))
        }
    }
}

#Preview {
    RecipesView()
}

