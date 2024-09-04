import XCTest

@testable import PokeDex_Paulo

final class DetailUnitTest: XCTestCase {
    var sut: DetailViewState!

    override func setUpWithError() throws {
        sut = DetailViewState("bulbasaur")

        //Only to wait for server side response
        let expectation1 = XCTestExpectation(description: "Waiting for network request")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 3)
    }

    func testCodeGivenDataReturnCode() throws {
        _ = sut.$code.sink { value in
            XCTAssertTrue( value == "1")
        }
    }

    func testNameGivenDataReturnName() throws {
        _ = sut.$name.sink { value in
            XCTAssertTrue( value == "bulbasaur")
        }
    }

    func testStatsCountGivenDataReturn() throws {
        _ = sut.$stats.sink { value in
            XCTAssertTrue( value.count > 0)
        }
    }

    func testSpritGivenDataReturn() throws {
        _ = sut.$sprit.sink { value in
            XCTAssertTrue( value == "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
        }
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}




