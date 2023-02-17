//
//  RecipeFinderTests.swift
//  RecipeFinderTests
//
//  Created by Isiah Marie Ramos Malit on 2023-01-31.
//

import XCTest
import Combine
@testable import RecipeFinder

final class SearchViewModelTests: XCTestCase {
    
    var searchVM = SearchViewModelImp()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        searchVM.recipesAll = []
        searchVM.recipesHome = []
        searchVM.time = 0.0
        searchVM.type = ""
        searchVM.cuisines = ""
        searchVM.includedIngredients = ""
    }

    func testGetHStackVM() throws {
        let hstackVM = searchVM.getHStackVM(isCuisine: false, list: ["a", "b", "c"])
        XCTAssertTrue(hstackVM is (any HStackWrapViewModel))
        XCTAssertFalse(hstackVM is (any SearchViewModel))
    }

    func testFormatSearchUrlTimeAndIngredients() throws {
        searchVM.time = 15.0
        searchVM.includedIngredients = "Chicken, rice"
        
        let searchURL = searchVM.formatSearchURL()
        let baseURL = Constants.RecipeService.complex
        let APIKey = Constants.RecipeService.apiKey
        
        XCTAssertTrue(searchURL == "\(baseURL)?includeIngredients=Chicken,rice&maxReadyTime=15&\(APIKey)")

    }
    
    func testFormatSearchUrlTypeAndCuisine() throws {
        searchVM.type = "breakfast"
        searchVM.cuisines = "asian,western"
        
        let searchURL = searchVM.formatSearchURL()
        let baseURL = Constants.RecipeService.complex
        let APIKey = Constants.RecipeService.apiKey
        
        XCTAssertTrue(searchURL == "\(baseURL)?cuisine=asian,western&type=breakfast&\(APIKey)")
        
    }
    
    func testFormatSearchUrlAll() throws {
        searchVM.time = 15.0
        searchVM.includedIngredients = "Chicken,"
        searchVM.type = "breakfast"
        searchVM.cuisines = "asian"
        
        let searchURL = searchVM.formatSearchURL()
        let baseURL = Constants.RecipeService.complex
        let APIKey = Constants.RecipeService.apiKey
        
        XCTAssertTrue(
            searchURL ==
            "\(baseURL)?includeIngredients=Chicken&cuisine=asian&type=breakfast&maxReadyTime=15&\(APIKey)"
        )
    }
    
    func testRandomUrl() throws {
        let baseURL = Constants.RecipeService.random
        let APIKey = Constants.RecipeService.apiKey
        let searchURL = searchVM.formatSearchURL()
        
        XCTAssertTrue(
            searchURL == "\(baseURL)?number=50&\(APIKey)"
        )
    }
    
    func testGetHomeRecipes() throws {
        
        let service = MockService()
        let urlString = service.jsonRandomString
        
        searchVM.fetchRecipes(urlString: urlString, recipesService: service as RecipesService)
        
        XCTAssertTrue(!searchVM.recipesHome.isEmpty)
        XCTAssertTrue(!searchVM.recipesAll.isEmpty)
        
    }
    
    func testGetAllRecipes() throws {
        let service = MockService()
        let urlString = service.jsonSearchString
        
        searchVM.fetchRecipes(urlString: urlString, recipesService: service as RecipesService)
        
        XCTAssertTrue(!searchVM.recipesHome.isEmpty)
        XCTAssertTrue(!searchVM.recipesAll.isEmpty)
        
    }
}

class MockService: RecipesService {
    let jsonSearchString =
    """
    {
        "results": [
            {
                "id": 1001,
                "title": "Pasta With Tuna",
                "image": "https://spoonacular.com/654959-312x231.jpg",
                "imageType": "jpg"
            },
            {
                "id": 2002,
                "title": "Pasta Margherita",
                "image": "https://spoonacular.com/511728-312x231.jpg",
                "imageType": "jpg"
            }
        ],
        "offset": 0,
        "number": 2,
        "totalResults": 261
    }
    """
    
    let jsonRandomString =
    """
    {
        "recipes": [
            {
                "id": 645714,
                "title": "Grilled Fish With Sun Dried Tomato Relish",
                "image": "https://spoonacular.com/recipeImages/645714-556x370.jpg",
                "imageType": "jpg"
            },
            {
                "id": 632790,
                "title": "Arugula Walnut Pesto",
                "image": "https://spoonacular.com/recipeImages/632790-556x370.jpg",
                "imageType": "jpg"
            }
        ]
    }
    """
    
    func fetchRecipes(urlString: String) -> AnyPublisher<Recipes, Error> {
        do {
            let jsonData = Data(urlString.utf8)
            let recipes = try JSONDecoder().decode(Recipes.self, from: jsonData)
            return Just(recipes)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Just(Recipes())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
