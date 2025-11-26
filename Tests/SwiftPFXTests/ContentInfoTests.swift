import Foundation
import SwiftASN1
import Testing
@testable import SwiftPFX

@Suite("ContentInfo Tests")
struct ContentInfoTests {
    @Test("Check content type")
    func checkContentType() throws {
        let info = ContentInfo(data: Data())

        #expect(info.contentType == "1.2.840.113549.1.7.1")
    }

    @Test("Check serialization")
    func checkSerialization() throws {
        let info = ContentInfo(data: Data([0x00, 0x01, 0x02, 0x03]))

        var serializer = DER.Serializer()
        try serializer.serialize(info)

        let expected: [UInt8] = [
            0x30, 0x13,
                0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x07, 0x01,
                0xa0, 0x06,
                    0x04, 0x04,
                        0x00, 0x01, 0x02, 0x03
        ]
        #expect(serializer.serializedBytes == expected)
    }
}
