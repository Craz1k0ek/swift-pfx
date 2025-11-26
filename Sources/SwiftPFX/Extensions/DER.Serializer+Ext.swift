import SwiftASN1

extension DER.Serializer {
    /// Appends a single, non-constructed node to the content.
    ///
    /// Appends a single, non-constructed node to the content.
    /// - Parameters:
    ///   - identifier: The tag for this ASN.1 node.
    ///   - contentWriter: A callback that will be invoked that allows users to serialize their object into the output stream.
    @inlinable
    mutating func appendPrimitiveNode(identifier: ASN1Identifier, _ contentWriter: (inout DER.Serializer) throws -> Void) rethrows {
        try appendPrimitiveNode(identifier: identifier) { bytes in
            var serializer = DER.Serializer()
            try contentWriter(&serializer)
            bytes.append(contentsOf: serializer.serializedBytes)
        }
    }
}
