import SnapshotTesting
import XCTest

@testable import PokeDex_Paulo


final class MainViewSnapshotTest: XCTestCase {
    var sut: MainView!

    override func setUpWithError() throws {
        sut = MainView()
//        assertSnapshot(of: sut, as: .image, record: true)
    }

    func testMainScreenWhenStart() throws {
        assertSnapshot(of: sut, as: .image)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}
