//
//  SpotifyHTTPResponse.swift
//  SpotifyTesting
//
//  Created by Tom Fritz on 12/25/17.
//  Copyright © 2017 Tom Fritz. All rights reserved.
//

// MARK: - Spotify Web API Object Models

struct SpotifyPagingObject<T: Decodable>: Decodable {
    let href: String
    let items: [T]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}

struct SpotifyExternalUrlObject: Decodable {
    let spotify: String
}

struct SpotifyImageObject: Decodable {
    let height: Int?
    let url: String
    let width: Int?
}

struct SpotifyPublicUserObject: Decodable {
    let displayName: String
    let externalUrls: SpotifyExternalUrlObject
    let followers: String
    let href: String
    let id: String
    let images: SpotifyImageObject
    let type: String
    let uri: String
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case externalUrls = "external_urls"
        case followers
        case href
        case id
        case images
        case type
        case uri
    }
}

struct SpotifyFollowersObject: Decodable {
    let href: String?
    let total: Int
}

struct SpotifyPlaylistTrackObject: Decodable {
    let addedAt: TimeInterval?
    let addedBy: SpotifyPublicUserObject?
    let isLocal: Bool
    let track: SpotifyFullTrackObject
    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case addedBy = "added_by"
        case isLocal = "is_local"
        case track
    }
}

struct SpotifyFullTrackObject: Decodable {
    let album: String
    let artists: [SpotifySimplifiedArtistObject]
    let availableMarkets: [String]
    let discNumber: Int
    let durationMs: Int
    let explicit: Bool?
    let externalIds: SpotifyExternalIdObject
    let externalUrls: SpotifyExternalUrlObject
    let href: String
    let id: String
    let isPlayable: Bool
    let linkedFrom: SpotifyTrackLinkObject
    let restrictions: [String : String]
    let name: String
    let popularity: Int
    let previewUrl: String
    let trackNumber: Int
    let type: String
    let uri: String
    enum CodingKeys: String, CodingKey {
        case album
        case artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case explicit
        case externalIds = "external_ids"
        case externalUrls = "external_urls"
        case href
        case id
        case isPlayable
        case linkedFrom = "linked_from"
        case restrictions
        case name
        case popularity
        case previewUrl = "preview_url"
        case trackNumber = "track_number"
        case type
        case uri
    }
}

struct SpotifyTrackLinkObject: Decodable {
    let externalUrls: SpotifyExternalUrlObject
    let href: String
    let id: String
    let type: String
    let uri: String
    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href
        case id
        case type
        case uri
    }
}

struct SpotifyExternalIdObject: Decodable {
    let key: String
    let value: String
}

struct SpotifySimplifiedAlbumObject: Decodable {
    let albumType: String
    
    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
    }
}

struct SpotifySimplifiedArtistObject: Decodable {
    let externalUrls: String
    let href: String
    let id: String
    let name: String
    let type: String
    let uri: String
    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href
        case id
        case name
        case type
        case uri
    }
}

struct SpotifyPlaylistObject: Decodable {
    let collaborative: Bool
    let externalUrls: SpotifyExternalUrlObject
    let href: String
    let id: String
    let images: [SpotifyImageObject]
    let name: String
    let owner: Owner
    let publicAccess: Bool?
    let snapshotId: String
    let tracks: Track
    let type: String
    let uri: String
    enum CodingKeys: String, CodingKey {
        case collaborative
        case externalUrls = "external_urls"
        case href
        case id
        case images
        case name
        case owner
        case publicAccess = "public"
        case snapshotId = "snapshot_id"
        case tracks
        case type
        case uri
    }
    
    struct Owner: Decodable {
        let displayName: String
        let externalUrls: SpotifyExternalUrlObject
        let href: String
        let id: String
        let type: String
        let uri: String
        enum CodingKeys: String, CodingKey {
            case displayName = "display_name"
            case externalUrls = "external_urls"
            case href
            case id
            case type
            case uri
        }
    }
    struct Track: Decodable {
        let href: String
        let total: Int
    }
}
