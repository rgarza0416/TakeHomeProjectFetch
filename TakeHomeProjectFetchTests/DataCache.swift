//
//  DataCache.swift
//  TakeHomeProjectFetchTests
//
//  Created by Ricardo Garza on 5/30/25.
//

import XCTest
@testable import TakeHomeProjectFetch

class PhotoCacheViewModelTests: XCTestCase {
    var photoCache: PhotoCacheViewModel!
    override func setUp() async throws {
        photoCache = PhotoCacheViewModel()
    }
    override func tearDown() async throws {
        photoCache = nil
    }

    func testCachingImage() async {
        let testKey = "testKey"
        let testImage = UIImage(systemName: "person.fill")
        
        await photoCache.setImage(testImage!, forKey: testKey)
        let cachedImage = await photoCache.image(forKey: testKey)
        
        XCTAssertNotNil(cachedImage, "Image should be cached")
        XCTAssertEqual(cachedImage?.pngData(), testImage?.pngData(), "Cached image should match the original image")
    }
}

class RecipeDataTests: XCTestCase {
    func testFetchRecipe_InvalidData() async {
        let viewModel = await RecipesViewModel()
        await MainActor.run {
            viewModel.endpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        }
        
        do {
            _ = try await viewModel.fetchRecipe()
            XCTFail("Should have thrown an invalid data error")
        } catch APIError.invalidData {
            
        } catch {
            XCTFail("Expected invalidData error but got: \(error)")
        }
    }
}

