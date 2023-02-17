//
//  RecipePageViewModelTests.swift
//  RecipeFinderTests
//
//  Created by Isiah Marie Ramos Malit on 2023-02-17.
//

import XCTest
import Combine

final class RecipePageViewModelTests: XCTestCase {

    func testFetchRecipeInfo() throws {
        let recipeVM = RecipePageViewModelImp(recipe: Recipe())
        let service = MockRecipeService()
        
        recipeVM.fetchInstructions(
            urlString: service.urlString,
            instructionService: service
        )
        
        XCTAssertTrue(recipeVM.totalTime > 0)
        XCTAssertTrue(!recipeVM.steps.isEmpty)
        XCTAssertTrue(!recipeVM.servingDesired.isEmpty)
    }

    func testIngredientsList() throws {
        
        let recipeVM = RecipePageViewModelImp(recipe: Recipe())
        recipeVM.formatIngredients()
        XCTAssertFalse(recipeVM.totalTime > 0)
        XCTAssertFalse(!recipeVM.steps.isEmpty)
        XCTAssertFalse(!recipeVM.servingDesired.isEmpty)
        
        let service = MockRecipeService()
        recipeVM.fetchInstructions(
            urlString: service.urlString,
            instructionService: service
        )
        
        XCTAssertTrue(recipeVM.totalTime > 0)
        XCTAssertTrue(!recipeVM.steps.isEmpty)
        XCTAssertTrue(!recipeVM.servingDesired.isEmpty)
    }

}

class MockRecipeService: RecipeInstructionService {
    
    let urlString =
    """
    {
        "extendedIngredients": [
            {
                "id": 2069,
                "aisle": "Oil, Vinegar, Salad Dressing",
                "image": "balsamic-vinegar.jpg",
                "consistency": "LIQUID",
                "name": "balsamic vinegar",
                "nameClean": "balsamic vinegar",
                "original": "1-2T balsamic vinegar",
                "originalName": "balsamic vinegar",
                "amount": 1,
                "unit": "T",
                "meta": [],
                "measures": {
                    "us": {
                        "amount": 1,
                        "unitShort": "Tbsp",
                        "unitLong": "Tbsp"
                    },
                    "metric": {
                        "amount": 1,
                        "unitShort": "Tbsp",
                        "unitLong": "Tbsp"
                    }
                }
            },
            {
                "id": 1102047,
                "aisle": "Spices and Seasonings",
                "image": "salt-and-pepper.jpg",
                "consistency": "SOLID",
                "name": "salt and pepper",
                "nameClean": "salt and pepper",
                "original": "salt and pepper, to taste",
                "originalName": "salt and pepper, to taste",
                "amount": 1,
                "unit": "serving",
                "meta": [
                    "to taste"
                ],
                "measures": {
                    "us": {
                        "amount": 1,
                        "unitShort": "serving",
                        "unitLong": "serving"
                    },
                    "metric": {
                        "amount": 1,
                        "unitShort": "serving",
                        "unitLong": "serving"
                    }
                }
            }
        ],
        "id": 716416,
        "title": "Tomato, Cucumber & Onion Salad with Feta Cheese: Real Convenience Food",
        "readyInMinutes": 45,
        "servings": 1,
        "image": "https://spoonacular.com/recipeImages/716416-556x370.jpg",
        "imageType": "jpg",
        "cuisines": [],
        "dishTypes": [
            "side dish",
            "antipasti",
            "salad",
            "starter",
            "snack",
            "appetizer",
            "antipasto",
            "hor d'oeuvre"
        ],
        "instructions": "",
        "analyzedInstructions": [
            {
                "name": "",
                "steps": [
                    {
                        "number": 1,
                        "step": "Pre-heat the oven to 200 deg Celsius.",
                        "ingredients": [],
                        "equipment": [
                            {
                                "id": 404784,
                                "name": "oven",
                                "localizedName": "oven",
                                "image": "oven.jpg"
                            }
                        ]
                    },
                    {
                        "number": 2,
                        "step": "Lay a sheet of baking paper on a baking tray and grease it lightly with olive oil.",
                        "ingredients": [
                            {
                                "id": 4053,
                                "name": "olive oil",
                                "localizedName": "olive oil",
                                "image": "olive-oil.jpg"
                            }
                        ],
                        "equipment": [
                            {
                                "id": 404770,
                                "name": "baking paper",
                                "localizedName": "baking paper",
                                "image": "baking-paper.jpg"
                            },
                            {
                                "id": 404646,
                                "name": "baking pan",
                                "localizedName": "baking pan",
                                "image": "roasting-pan.jpg"
                            }
                        ]
                    },
                    {
                        "number": 3,
                        "step": "Lay the whole fish fillet on the baking sheet and rub the fish generously with the rest of the olive oil.Season with salt and pepper. I like to use Masterfoods Garlic Pepper whenever a recipe calls for salt and pepper.",
                        "ingredients": [
                            {
                                "id": 1102047,
                                "name": "salt and pepper",
                                "localizedName": "salt and pepper",
                                "image": "salt-and-pepper.jpg"
                            },
                            {
                                "id": 10115261,
                                "name": "fish fillets",
                                "localizedName": "fish fillets",
                                "image": "fish-fillet.jpg"
                            },
                            {
                                "id": 4053,
                                "name": "olive oil",
                                "localizedName": "olive oil",
                                "image": "olive-oil.jpg"
                            },
                            {
                                "id": 11215,
                                "name": "garlic",
                                "localizedName": "garlic",
                                "image": "garlic.png"
                            },
                            {
                                "id": 1002030,
                                "name": "pepper",
                                "localizedName": "pepper",
                                "image": "pepper.jpg"
                            },
                            {
                                "id": 10115261,
                                "name": "fish",
                                "localizedName": "fish",
                                "image": "fish-fillet.jpg"
                            },
                            {
                                "id": 1012034,
                                "name": "dry seasoning rub",
                                "localizedName": "dry seasoning rub",
                                "image": "seasoning.png"
                            }
                        ],
                        "equipment": [
                            {
                                "id": 404727,
                                "name": "baking sheet",
                                "localizedName": "baking sheet",
                                "image": "baking-sheet.jpg"
                            }
                        ]
                    }
                ]
            }
        ],
    }
    """
    
    func fetchInstructions(urlString: String) -> AnyPublisher<DetailedRecipe, Error> {
        do {
            let jsonData = Data(urlString.utf8)
            let recipes = try JSONDecoder().decode(DetailedRecipe.self, from: jsonData)
            return Just(recipes)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Just(DetailedRecipe(readyInMinutes: 0, servings: 0))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
