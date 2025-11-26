import SwiftASN1
import X509

/// A value representing a certificate stored in a `CertBag`.
///
/// This type models the ASN.1 `CertValue` choice used within PKCS#12.
/// Currently only X.509 certificates are supported.
///
/// `CertValue` conforms to `DERSerializable` for encoding into
/// Distinguished Encoding Rules (DER) format as used throughout PKCS standards.
public enum CertValue: Hashable, Sendable, DERSerializable {
    /// An X.509 certificate.
    case x509Certificate(Certificate)

    public func serialize(into coder: inout DER.Serializer) throws {
        switch self {
        case let .x509Certificate(x509Certificate):
            try coder.serialize(x509Certificate)
        }
    }
}

/// A container for certificates used within PKCS#12.
///
/// `CertBag` represents the ASN.1 `CertBag` structure, associating an
/// object identifier with a certificate value. This is the fundamental
/// storage format for certificates within PKCS#12 bags.
///
/// ## ASN.1 Structure
/// ```
/// CertBag ::= SEQUENCE {
///   certId      BAG-TYPE.&id   ({CertTypes}),
///   certValue   [0] EXPLICIT BAG-TYPE.&Type ({CertTypes}{@certId})
/// }
/// ```
public struct CertBag: Hashable, Sendable, DERSerializable {
    /// The certificate type identifier.
    public let certId: ASN1ObjectIdentifier
    /// The stored certificate.
    public let certValue: CertValue

    /// Creates a new `CertBag` containing an X.509 certificate.
    /// - Parameter x509Certificate: The certificate to store.
    public init(x509Certificate: Certificate) {
        self.certId = "1.2.840.113549.1.9.22.1"
        self.certValue = .x509Certificate(x509Certificate)
    }

    public func serialize(into coder: inout DER.Serializer) throws {
        try coder.appendConstructedNode(identifier: .sequence) { sequence in
            try sequence.serialize(certId)
            try sequence.serialize(explicitlyTaggedWithTagNumber: 0, tagClass: .contextSpecific) { context in
                switch certValue {
                case .x509Certificate:
                    try context.appendPrimitiveNode(identifier: .octetString) { octet in
                        try octet.serialize(certValue)
                    }
                }
            }
        }
    }
}
