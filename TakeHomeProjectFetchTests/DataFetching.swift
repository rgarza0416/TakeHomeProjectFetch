//
//  DataFetching.swift
//  TakeHomeProjectFetchTests
//
//  Created by Ricardo Garza on 5/30/25.
//

import XCTest
@testable import TakeHomeProjectFetch

final class RecipeAPITests: XCTestCase {

    func testFetchRecipe_Success() async throws {
        let viewModel = await RecipesViewModel()
        
        do {
            let recipes = try await viewModel.fetchRecipe()
            XCTAssertFalse(recipes.isEmpty, "Fetched recipes should not be empty")
        } catch {
            XCTFail("Fetching recipes failed with error: \(error)")
        }
    }
    

    func testFetchRecipe_InvalidURL() async {
        let viewModel = await RecipesViewModel()
        await MainActor.run {
            viewModel.endpoint = "invalid-url"
        }
        
        do {
            _ = try await viewModel.fetchRecipe()
            XCTFail("Should have thrown an error for invalid URL")
        } catch let error as NSError {
            XCTAssertEqual(error.domain, NSURLErrorDomain, "Should be a URL error")
            XCTAssertEqual(error.code, NSURLErrorUnsupportedURL, "Should be an unsupported URL error")
        } catch {
            XCTFail("Expected URL error but got: \(error)")
        }
    }
    
    func testFetchRecipe_NetworkError() async {
        let viewModel = await RecipesViewModel()
        await MainActor.run {
            viewModel.endpoint = "https://nonexistent-domain.com/recipes.json"
        }
        
        do {
            _ = try await viewModel.fetchRecipe()
            XCTFail("Should have thrown a network error")
        } catch {
            XCTAssertTrue(true)
        }
    }
}


