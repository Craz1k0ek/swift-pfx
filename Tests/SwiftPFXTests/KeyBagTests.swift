import Crypto
import CryptoExtras
import SwiftASN1
import Testing
@testable import SwiftPFX

@Suite("KeyBag Tests")
struct KeyBagTests {
    @Test("Check serialization", arguments: [
        Curve25519.Signing.PrivateKey() as PKCS8Exportable,
        P256.Signing.PrivateKey() as PKCS8Exportable,
        P384.Signing.PrivateKey() as PKCS8Exportable,
        P521.Signing.PrivateKey() as PKCS8Exportable,
        try! _RSA.Signing.PrivateKey(keySize: .bits2048) as PKCS8Exportable
    ])
    func checkSerialization(privateKey: PKCS8Exportable) throws {
        let bag = KeyBag(privateKey: privateKey)

        var serializer = DER.Serializer()
        try serializer.serialize(bag)

        #expect(serializer.serializedBytes == Array(privateKey.pkcs8DERRepresentation))
    }
}

