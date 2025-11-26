import Foundation
import SwiftASN1

/// A PKCS#7 content payload.
///
/// `Content` represents the data form used within PKCS#7/CMS
/// `ContentInfo` sequences. Currently only raw `Data` values are
/// supported. The value is encoded as an `OCTET STRING` when serialized.
///
/// `Content` conforms to `DERSerializable` for use in CMS and PKCS
/// container structures.
public enum Content: Hashable, Sendable, DERSerializable {
    /// Raw binary content.
    case data(Data)

    public func serialize(into coder: inout DER.Serializer) throws {
        switch self {
        case let .data(data):
            coder.serializeRawBytes(data)
        }
    }
}

/// A wrapper for PKCS#7 content.
///
/// `ContentInfo` models the ASN.1 `ContentInfo` structure used in
/// PKCS#7/CMS, associating an object identifier with an encoded content
/// payload. This structure forms the outer envelope for many PKCS
/// serialization formats.
///
/// The `contentType` defaults to `1.2.840.113549.1.7.1`, indicating
/// standard CMS `data` content.
///
/// ## ASN.1 Structure
/// ```
/// ContentInfo ::= SEQUENCE {
///   contentType   OBJECT IDENTIFIER,
///   content       [0] EXPLICIT OCTET STRING
/// }
/// ```
public struct ContentInfo: @unchecked Sendable, DERSerializable {
    /// The identifier describing the content type.
    public let contentType: ASN1ObjectIdentifier
    /// The encapsulated PKCS#7 content.
    public let content: Content

    /// Creates a `ContentInfo` wrapping raw CMS/PKCS#7 data.
    /// - Parameter data: The value to store as a CMS `data` content type.
    public init(data: Data) {
        self.contentType = "1.2.840.113549.1.7.1"
        self.content = .data(data)
    }

    public func serialize(into coder: inout DER.Serializer) throws {
        try coder.appendConstructedNode(identifier: .sequence) { sequence in
            try sequence.serialize(contentType)
            try sequence.serialize(explicitlyTaggedWithTagNumber: 0, tagClass: .contextSpecific) { context in
                switch content {
                case .data:
                    try context.appendPrimitiveNode(identifier: .octetString) { octet in
                        try octet.serialize(content)
                    }
                }
            }
        }
    }
}
