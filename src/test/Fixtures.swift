import XCTest
import SourceKittenFramework
import luxKit
import Result

// An abstract class that runs lux on a given file and checks for equality with an expected output
class InstrumentationFunctionalityTest: XCTestCase {
    var fixtureDirectoryPath: String {
        return NSBundle(forClass: self.dynamicType).resourcePath! + "/fixtures"
    }

    // This should return the absolute path to a folder containing "pre.swift" and "post.swift"
    var folderPath: String {
        get {
            assertionFailure("Should override")
            return ""
        }
    }
    var preString: String {
        get {
            return File(path: self.folderPath + "/pre.swift")!.contents
        }
    }
    var postString: String {
        get {
            return File(path: self.folderPath + "/post.swift")!.contents
        }
    }
    var testScriptPath: String? {
        get {
            let desiredPath = self.folderPath + "/test"
            if NSFileManager.defaultManager().fileExistsAtPath(desiredPath) {
                return desiredPath
            } else {
                return .None
            }
        }
    }
    var coverallsOutputString: String? {
        get {
            let desiredPath = self.folderPath + "/coveralls_output.json"
            if NSFileManager.defaultManager().fileExistsAtPath(desiredPath) {
                return File(path: desiredPath)!.contents
            } else {
                return .None
            }
        }
    }

    final func testLuxInstrumentsCorrectly() {
        XCTAssertEqual(luxKit.instrumentString(preString).0, postString, "Lux instrumented the file differently than expected. Maybe you enhanced the instrumentation, in which case you should update the post.swift file. Or maybe you broke something.")
    }
    
    final func testLuxInstrumentationPerformance() {
        self.measureBlock() {
            luxKit.instrumentString(preString)
        }
    }
}

final class SimpleInstrumentationTest: InstrumentationFunctionalityTest {
    override var folderPath: String {
        get {
            return fixtureDirectoryPath + "/simpleTest"
        }
    }
}

final class minimalViableTest: InstrumentationFunctionalityTest {
    override var folderPath: String {
        get {
            return fixtureDirectoryPath + "/minimalViableTest"
        }
    }
}

