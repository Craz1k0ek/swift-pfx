import SwiftASN1
import X509

struct CertBag: Sendable {
    let certId = ASN1ObjectIdentifier("1.2.840.113549.1.9.22.1")
    let certValue: Certificate

    init(certificate: Certificate) {
        self.certValue = certificate
    }
}

extension CertBag: DERSerializable {
    func serialize(into coder: inout DER.Serializer) throws {
        try coder.appendConstructedNode(identifier: .sequence) { sequence in
            try sequence.serialize(certId)
            try sequence.serialize(explicitlyTaggedWithTagNumber: 0, tagClass: .contextSpecific) { context in
                try context.appendPrimitiveNode(identifier: .octetString) { octet in
                    var certSerializer = DER.Serializer()
                    try certSerializer.serialize(certValue)
                    octet.append(contentsOf: certSerializer.serializedBytes)
                }
            }
        }
    }
}