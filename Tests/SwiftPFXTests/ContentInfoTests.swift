import SwiftASN1
import Testing
@testable import SwiftPFX

@Suite("ContentInfo")
struct ContentInfoTests {
    @Test("Check content type")
    func checkContentType() throws {
        let info = ContentInfo(data: 0)
        
        #expect(info.contentType == "1.2.840.113549.1.7.1")
    }

    @Test("Check serialization")
    func checkSerialization() throws {
        let utf8 = ASN1UTF8String("Hello, world")
        let info = ContentInfo(data: utf8)

        var serializer = DER.Serializer()
        try serializer.serialize(info)

        let expected: [UInt8] = [
            0x30, 0x1d,
                0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x07, 0x01, 
                0xa0, 0x10, 
                    0x04, 0x0e, 
                        0x0c, 0x0c, 0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x77, 0x6f, 0x72, 0x6c, 0x64
        ]
        #expect(serializer.serializedBytes == expected)
    }
}
