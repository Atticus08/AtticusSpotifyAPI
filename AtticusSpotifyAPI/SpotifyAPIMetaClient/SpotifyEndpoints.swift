//
//  SpotifyEndpoints.swift
//  SpotifyTesting
//
//  Created by Atticus on 12/24/17.
//  Copyright © 2017 Atticus08. All rights reserved.
//

extension String {
    static let scheme = "https"
    static let authority = "api.spotify.com"
    static let getCurrentUserPlaylistsPath = scheme + "://" + authority + "/v1/me/playlists"
}
