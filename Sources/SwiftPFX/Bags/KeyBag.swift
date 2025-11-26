import SwiftASN1

/// A container for private keys in PKCS#12.
///
/// `KeyBag` represents the ASN.1 `KeyBag` structure, which stores a
/// private key encoded as a PKCS#8 `PrivateKeyInfo`. This is one of
/// the standard bag types used within PKCS#12 key stores.
///
/// ## ASN.1 Structure
/// ```
/// KeyBag ::= PrivateKeyInfo
/// ```
public struct KeyBag: Sendable, DERSerializable {
    /// The encapsulated PKCS#8 private key.
    public let privateKey: PKCS8Exportable

    /// Creates a new key bag containing the provided private key.
    /// - Parameter privateKey: A PKCS#8-exportable private key to store.
    public init(privateKey: PKCS8Exportable) {
        self.privateKey = privateKey
    }

    public func serialize(into coder: inout DER.Serializer) throws {
        coder.serializeRawBytes(privateKey.pkcs8DERRepresentation)
    }
}
