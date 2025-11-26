import Crypto
import CryptoExtras
import Foundation

public protocol PKCS8Exportable: Sendable {
    /// A Distinguished Encoding Rules (DER) encoded representation of the private key in PKCS#8 format.
    var pkcs8DERRepresentation: Data { get }
}

extension Curve25519.Signing.PrivateKey: PKCS8Exportable {}

extension P256.Signing.PrivateKey: PKCS8Exportable {}

extension P384.Signing.PrivateKey: PKCS8Exportable {}

extension P521.Signing.PrivateKey: PKCS8Exportable {}

extension _RSA.Signing.PrivateKey: PKCS8Exportable {}
