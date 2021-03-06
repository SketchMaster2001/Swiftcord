//
//  Emoji.swift
//  Swiftcord
//
//  Created by Alejandro Alonso
//  Copyright © 2017 Alejandro Alonso. All rights reserved.
//

import Foundation

/// Emoji Type
public struct Emoji: Imageable, Codable {
    // MARK: Properties

    /// ID of custom emoji
    public let id: Snowflake?

    /// Whether or not this emoji is animted
    public let isAnimated: Bool?

    /// Whether or not this emoji is managed
    public let isManaged: Bool?

    /// The base64 encoded image
    private let image: String?

    /// Name of the emoji
    public let name: String

    /// Whether this emoji requires colons to use
    public let requiresColons: Bool?

    /// Array of roles that can use this emoji
    public var rolesArray = [Role]()

    /// Array of role Snowflakes
    private var roles = [Snowflake]()

    /// Tag used for rest endpoints
    public var tag: String {
        guard let id = id else {
            return name
        }

        return "\(name):\(id)"
    }

    // MARK: Initializers

    /**
     Creates an Emoji structure

     - parameter json: JSON representable as a dictionary
     */
    init(_ json: [String: Any]) {
        self.id = Snowflake(json["id"])
        self.isAnimated = json["animated"] as? Bool
        self.isManaged = json["managed"] as? Bool
        self.name = json["name"] as! String
        self.requiresColons = json["require_colons"] as? Bool

        if let roles = json["roles"] as? [[String: Any]] {
            for role in roles {
                self.rolesArray.append(Role(role))
            }
        }

        self.image = nil
    }

    /**
     Creates an Emoji structure for use with reactions

     - parameter name: Emoji unicode character or name (if custom)
     - parameter id: Emoji snowflake ID if custom (nil if unicode)
     */
    public init(_ name: String, id: Snowflake? = nil) {
        self.id = id
        self.isAnimated = nil
        self.isManaged = nil
        self.name = name
        self.requiresColons = nil
        self.image = nil
    }

    /// This init is purely for uploading an emoji to Discord
    init(name: String, base64Image: String, roles: [Role] = []) {
        // Required fields
        self.name = name
        self.image = base64Image
        self.roles = roles.map { $0.id }

        self.id = nil
        self.isAnimated = nil
        self.isManaged = nil
        self.requiresColons = nil
    }

    /**
     Gets the link of the emoji's image

     - parameter format: File extension of the avatar (default png)
     */
    public func imageUrl(format: FileExtension = .png) -> URL? {
        guard let id = self.id else {
            return nil
        }
        // as of 7/18/20, the CDN domain is still cdn.discordapp.com
        return URL(string: "https://cdn.discordapp.com/emojis/\(id).\(format)")
    }
}
