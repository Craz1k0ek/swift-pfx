import SwiftASN1

/// A value stored within a PKCS#12 `SafeBag`.
///
/// `BagValue` represents the ASN.1 `BAG-TYPE.&Type` choice used in
/// PKCS#12. A bag may contain either a PKCS#8 private key (`KeyBag`)
/// or a certificate (`CertBag`). Additional bag variants may be added
/// as needed.
///
/// `BagValue` conforms to `DERSerializable` for encoding within
/// PKCS#12 safe contents.
public enum BagValue: Sendable, DERSerializable {
    /// A private key bag.
    case keyBag(KeyBag)
    /// A certificate bag.
    case certBag(CertBag)

    public func serialize(into coder: inout DER.Serializer) throws {
        switch self {
        case let .keyBag(keyBag):
            try coder.serialize(keyBag)
        case let .certBag(certBag):
            try coder.serialize(certBag)
        }
    }
}

/// A PKCS#12 safe bag.
///
/// `SafeBag` represents the ASN.1 `SafeBag` structure used in PKCS#12
/// to hold collections of keys and certificates. Each bag is identified
/// by an object identifier that declares the stored content type, and
/// contains a corresponding `BagValue`.
///
/// The designated initializers create bags for either private keys
/// or certificates using the standard PKCS#12 OIDs.
///
/// ## ASN.1 Structure
/// ```
/// SafeBag ::= SEQUENCE {
///   bagId       BAG-TYPE.&id({BagTypes}),
///   bagValue    [0] EXPLICIT BAG-TYPE.&Type({BagTypes}{@bagId})
/// }
/// ```
public struct SafeBag: Sendable, DERSerializable {
    /// The object identifier describing the contents of the bag.
    public let bagId: ASN1ObjectIdentifier
    /// The encapsulated value stored inside the bag.
    public let bagValue: BagValue

    /// Creates a `SafeBag` containing a private key.
    /// - Parameter keyBag: The key bag to store.
    public init(keyBag: KeyBag) {
        self.bagId = ASN1ObjectIdentifier("1.2.840.113549.1.12.10.1.1")
        self.bagValue = .keyBag(keyBag)
    }

    /// Creates a `SafeBag` containing a certificate.
    /// - Parameter certBag: The certificate bag to store.
    public init(certBag: CertBag) {
        self.bagId = ASN1ObjectIdentifier("1.2.840.113549.1.12.10.1.3")
        self.bagValue = .certBag(certBag)
    }

    public func serialize(into coder: inout DER.Serializer) throws {
        try coder.appendConstructedNode(identifier: .sequence) { sequence in
            try sequence.serialize(bagId)
            try sequence.serialize(explicitlyTaggedWithTagNumber: 0, tagClass: .contextSpecific) { context in
                try context.serialize(bagValue)
            }
        }
    }
}
