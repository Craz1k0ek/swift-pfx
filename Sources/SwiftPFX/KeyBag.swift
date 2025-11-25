import Crypto
import CryptoExtras
import Foundation
import SwiftASN1

protocol PKCS8Exportable: Sendable {
    var pkcs8DERRepresentation: Data { get }
}

extension Curve25519.Signing.PrivateKey: PKCS8Exportable {}
extension P256.Signing.PrivateKey: PKCS8Exportable {}
extension P384.Signing.PrivateKey: PKCS8Exportable {}
extension P521.Signing.PrivateKey: PKCS8Exportable {}
extension _RSA.Signing.PrivateKey: PKCS8Exportable {}

struct KeyBag: Sendable {
    let privateKey: PKCS8Exportable

    init(privateKey: PKCS8Exportable) {
        self.privateKey = privateKey
    }
}

extension KeyBag: DERSerializable {
    func serialize(into coder: inout DER.Serializer) throws {
        coder.serializeRawBytes(privateKey.pkcs8DERRepresentation)
    }
}
