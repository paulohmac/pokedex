import XCTest

@testable import PokeDex_Paulo

final class MainViewStateUnitTest: XCTestCase {
    var sut: MainViewState!

    override func setUpWithError() throws {
        sut = MainViewState()
        sut.searchTerm = "bulbasaur"
        print("*bumba")
        sut.enterpressed.toggle()
    }

    func testSearchResultGivenDataReturn() throws {
        let expectation1 = XCTestExpectation(description: "Waiting for server data")
        _ = sut.$pokemonList.sink { list in
            print(list.count)
            XCTAssertTrue( list.count == 1)
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 4)
    }

    func testSearchNextPageResultGivenDataReturn() throws {
       sut.nextPage()
        let expectation1 = XCTestExpectation(description: "Waiting for server data")
        _ = sut.$pokemonList.sink { list in
            print(list.count)
            XCTAssertTrue( list.count == 40)
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 4)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}
