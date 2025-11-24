import SwiftASN1

struct ContentInfo: @unchecked Sendable {
    let contentType = ASN1ObjectIdentifier("1.2.840.113549.1.7.1")
    let content: DERSerializable

    init(data: DERSerializable) {
        self.content = data
    }
}

extension ContentInfo: DERSerializable {
    func serialize(into coder: inout DER.Serializer) throws {
        try coder.appendConstructedNode(identifier: .sequence) { sequence in
            try sequence.serialize(contentType)
            try sequence.serialize(explicitlyTaggedWithTagNumber: 0, tagClass: .contextSpecific) { context in
                try context.appendPrimitiveNode(identifier: .octetString) { octet in
                    var serializer = DER.Serializer()
                    try serializer.serialize(content)
                    octet.append(contentsOf: serializer.serializedBytes)
                }
            }
        }
    }
}
