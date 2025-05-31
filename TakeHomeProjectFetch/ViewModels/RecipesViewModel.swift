//
//  RecipesViewModel.swift
//  TakeHomeProjectFetch
//
//  Created by Ricardo Garza on 5/29/25.
//

import SwiftUI

@MainActor
class RecipesViewModel: ObservableObject {
    @Published var recipes: [RecipeModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isEmptyState = false
    @Published var selectedCuisine: String?
    @Published var searchText = ""
    
    let imageCache = PhotoCacheViewModel()
    var endpoint: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    var availableCuisines: [String] {
        Array(Set(recipes.map { $0.cuisine })).sorted()
    }
    
    var filteredRecipes: [RecipeModel] {
        recipes.filter { recipe in
            let matchesSearch = searchText.isEmpty ||
                recipe.name.localizedCaseInsensitiveContains(searchText) ||
                recipe.cuisine.localizedCaseInsensitiveContains(searchText)
            
            let matchesCuisine = selectedCuisine == nil || recipe.cuisine == selectedCuisine
            
            return matchesSearch && matchesCuisine
        }
    }
    
    init() {
        Task {
            await loadInitialRecipes()
        }
    }
    
    private func loadInitialRecipes() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetchedRecipes = try await fetchRecipe()
            recipes = fetchedRecipes
            errorMessage = nil
            isEmptyState = recipes.isEmpty
        } catch let error as APIError {
            handleAPIError(error)
        } catch {
            errorMessage = "An Unknown Error Occurred"
            print("Failed to load initial recipes: \(error)")
            recipes.removeAll()
            isEmptyState = false
        }
    }
    
  //     let endpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
       // let endpointMalformed = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
       // let endpointEmpty = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    

    func fetchRecipe() async throws -> [RecipeModel] {
        guard let url = URL(string: endpoint) else { throw APIError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw APIError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let recipeResponse = try decoder.decode(RecipeResponse.self, from: data)
            
            if recipeResponse.recipes.isEmpty {
                isEmptyState = true
                return []
            } else {
                isEmptyState = false
                return recipeResponse.recipes.shuffled()
            }
            
        } catch {
            throw APIError.invalidData
        }
    }
    
    func refreshRecipes() async {
        await loadInitialRecipes()
    }
    
    func handleAPIError(_ error: APIError) {
        switch error {
        case .invalidURL:
            errorMessage = "Failed to load recipes: Invalid URL."
        case .invalidResponse:
            errorMessage = "Failed to load recipes: Invalid response from server."
        case .invalidData:
            errorMessage = "Failed to load recipes: Data is corrupted."
            recipes.removeAll()
        case .noData:
            errorMessage = "No recipes available at the moment."
            recipes.removeAll()
        }
        print("Error: \(error.errorDescription ?? "Unknown error")")
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid HTTP response"
        case .invalidData:
            return "Invalid data received"
        case .noData:
            return "No data returned"
        }
    }
}

