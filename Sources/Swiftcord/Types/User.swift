//
//  User.swift
//  Swiftcord
//
//  Created by Alejandro Alonso
//  Copyright © 2017 Alejandro Alonso. All rights reserved.
//

import Foundation

/// User Type
public struct User: Imageable {

    // MARK: Properties

    /// Parent class
    public internal(set) weak var swiftcord: Swiftcord?

    /// Avatar hash
    public let avatar: String?

    /// Discriminator of user
    public let discriminator: String?

    /// Email of user (will probably be empty forever)
    public let email: String?

    /// ID of user
    public let id: Snowflake

    /// Whether or not this user is a bot
    public let isBot: Bool?

    /// Whether of not user has mfa enabled (will probably be empty forever)
    public let isMfaEnabled: Bool?

    /// Whether user is verified or not
    public let isVerified: Bool?

    /// Username of user
    public let username: String?

    // MARK: Initializer

    /**
     Creates User struct

     - parameter swiftcord: Parent class to get properties from
     - parameter json: JSON to decode into User struct
     */
    init(_ swiftcord: Swiftcord, _ json: [String: Any]) {
        self.swiftcord = swiftcord

        self.avatar = json["avatar"] as? String
        self.discriminator = json["discriminator"] as? String
        self.email = json["email"] as? String
        self.id = Snowflake(json["id"])!
        self.isBot = json["bot"] as? Bool
        self.isMfaEnabled = json["mfaEnabled"] as? Bool
        self.isVerified = json["verified"] as? Bool
        self.username = json["username"] as? String
    }

    // MARK: Functions

    /// Gets DM for user
    public func getDM() async throws -> DM? {
        return try await self.swiftcord?.getDM(for: self.id)
    }

    /**
     Gets the link of the user's avatar

     - parameter format: File extension of the avatar (default png)
     */
    public func imageUrl(format: FileExtension = .png) -> URL? {
        guard let avatar = self.avatar else {
            guard let discrim = self.discriminator,
                  let discriminator = Int(discrim) else {
                return nil
            }
            // as of 7/18/20, the CDN domain is still cdn.discordapp.com
            return URL(string: "https://cdn.discordapp.com/embed/avatars/\(discriminator % 5).\(format)")
        }

        return URL(string: "https://cdn.discordapp.com/avatars/\(self.id)/\(avatar).\(format)")
    }

}
