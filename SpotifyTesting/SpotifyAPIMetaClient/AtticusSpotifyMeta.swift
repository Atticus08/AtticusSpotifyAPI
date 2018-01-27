//
//  AtticusSpotifyMeta.swift
//
//
//  Created by Tom Fritz on 12/24/17.
//  Copyright © 2017 Tom Fritz. All rights reserved.
//

import UIKit

/// Class is a Spotify Web API wrapper, which will handle some of the features that used to be
// in the deprecated Spotify Meta Framework.
public final class AtticusSpotifyMeta {
    public func getCurrentUserPlaylists(withAccessToken token: String) {
        guard let url = URL(string: .getCurrentUserPlaylistsPath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10.0
        
        let session = URLSession(configuration: .default)
        _ = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                    print("There was an issue retrieving the response from the server!")
                    return
            }
            
            print("Response Code: \(response.statusCode)")
            let decoder = JSONDecoder()
            do {
                let userPlaylists = try decoder.decode(SpotifyPagingObject<SpotifyPlaylistObject>.self, from: data)
                print("This is the users playlist: \n \(userPlaylists)")
                print("Here's the link I can use to grab the playlists: \n \(userPlaylists.items[0].tracks.href)")
            } catch let error {
                print(error)
            }
        }).resume()
    }
}
