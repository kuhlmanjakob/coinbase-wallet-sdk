//
//  Message.swift
//  WalletSegue
//
//  Created by Jungho Bang on 6/13/22.
//

import Foundation
import CryptoKit

@available(iOS 13.0, *)
public typealias Message<C> = CodableMessage<C> where C: UnencryptedContent

@available(iOS 13.0, *)
public protocol UnencryptedContent: CodableContent {
    associatedtype Encrypted: EncryptedContent where Encrypted.Unencrypted == Self
    
    func encrypt(with symmetricKey: SymmetricKey?) throws -> Encrypted
}

// MARK: - base types

public protocol BaseContent {}

@available(iOS 13.0, *)
public struct BaseMessage<C: BaseContent> {
    public let uuid: UUID
    public let sender: CoinbaseWalletSDK.PublicKey
    public let content: C
    public let version: String
    public let timestamp: Date
    public let callbackUrl: String?

    static func copy<T>(_ orig: BaseMessage<T>, replaceContentWith content: C) -> BaseMessage<C> {
        return BaseMessage<C>.init(
            uuid: orig.uuid,
            sender: orig.sender,
            content: content,
            version: orig.version,
            timestamp: orig.timestamp,
            callbackUrl: orig.callbackUrl
        )
    }
}

// MARK: - codable types

@available(iOS 13.0, *)
extension BaseMessage: Codable where C: Codable {}

public protocol CodableContent: BaseContent, Codable {}
extension Array: BaseContent where Element: BaseContent {}
extension Array: CodableContent where Element: CodableContent {}

@available(iOS 13.0, *)
public typealias CodableMessage<C> = BaseMessage<C> where C: CodableContent
