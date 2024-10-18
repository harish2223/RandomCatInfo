//
//  CatViewModelTestCase.swift
//  RandomCatImageTests
//
//  Created by Harish Gajabheenkar on 17/10/24.
//

import XCTest
@testable import RandomCatImage
class CatViewModelTestCase: XCTestCase {
    var viewModel: CatViewModel!
    var mockCatFactService: MockCatFactService!
    var mockCatImageService: MockCatImageService!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockCatFactService = MockCatFactService()
        mockCatImageService = MockCatImageService()
        viewModel = CatViewModel(catFactService: mockCatFactService, catImageService: mockCatImageService)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockCatFactService = nil
        mockCatImageService = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchCatDataSuccess() async {
        // Arrange
        mockCatFactService.shouldReturnError = false
        mockCatImageService.shouldReturnError = false
        
        let expectationFact = expectation(description: "Cat fact fetched")
        let expectationImage = expectation(description: "Cat image fetched")
        
        viewModel.catFact = { fact in
            XCTAssertNotNil(fact)
            XCTAssertEqual(fact, "Adult cats only meow to communicate with humans.")
            expectationFact.fulfill()
        }
        
        viewModel.catImage = { url in
            XCTAssertEqual(url, "https://cdn2.thecatapi.com/images/aqm.jpg")
            expectationImage.fulfill()
        }
        
        // Act
        await viewModel.fetchCatData()
        
        // Assert
        await waitForExpectations(timeout: 1.0)
    }
    
    func testFetchCatDataFailure() async {
        mockCatFactService.shouldReturnError = true
        mockCatImageService.shouldReturnError = true
        viewModel.errorHandler = { error in
            XCTAssertEqual(error, "Failed to fetch data.")
        }
        
        await viewModel.fetchCatData()
        
    }
}

//MOCK Service 
struct MockCatFactService:CatFactServiceProtocol {
    var shouldReturnError = false
    func getRandomCatFact() async throws -> CatFact {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        } else {
            return CatFact.dummyCatFactModelData()
        }
    }
    
    
}
struct MockCatImageService:CatImageServiceProtocol {
    var shouldReturnError = false
    func getRandomCatImage() async throws -> catImage {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        } else {
            return CatImage.dummyCatImageModelData()
            
        }
    }
    
}
