import SnapshotTesting
import XCTest

@testable import PokeDex_Paulo

final class DetailViewSnapshotTest: XCTestCase {
    var sut: DetailView!

    override func setUpWithError() throws {
        sut = DetailView("pikachu", closeWindow: .constant(false), .constant(.normal))
    }

    func testMainScreenWhenStart() throws {
        assertSnapshot(of: sut, as: .image)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}

