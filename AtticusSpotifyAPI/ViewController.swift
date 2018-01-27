//
//  ViewController.swift
//  SpotifyTesting
//
//  Created by Atticus on 12/23/17.
//  Copyright © 2017 Atticus08. All rights reserved.
//

import UIKit


class ViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.layer.cornerRadius = 5
        button.backgroundColor = .green
        button.setTitle("LOG INTO SPOTIFY", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(spotifyLogin), for: .touchUpInside)
        return button
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.layer.cornerRadius = 5
        button.backgroundColor = .black
        button.setTitle("Play Song!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(initSpotifyPlayer), for: .touchUpInside)
        return button
    }()
    
    let playlistsButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.layer.cornerRadius = 5
        button.backgroundColor = .blue
        button.setTitle("User Playlists", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pullPlaylists), for: .touchUpInside)
        return button
    }()
    
    let clientId = AppPrivateInfo.shared.clientId
    let redirectUrl = AppPrivateInfo.shared.redirectUrl
    let auth = SPTAuth.defaultInstance()
    var session: SPTSession?
    var player: SPTAudioStreamingController?    
    var loginUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spotifyAuthSetup()
        self.subviewSetup()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessful"), object: nil)
    }
    
    private func spotifyAuthSetup() {
        guard let auth = self.auth else { print ("Spotify OAuth Object does not exist!"); return }
        auth.clientID = self.clientId
        auth.redirectURL = URL(string: self.redirectUrl)
        auth.sessionUserDefaultsKey = "GFCurrentSession"
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadCollaborativeScope, SPTAuthPlaylistReadPrivateScope,
                                 SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        
        // This creates the URL string based on the information provided above.
        self.loginUrl = auth.spotifyWebAuthenticationURL()
    }
    
    @objc private func spotifyLogin() {
        guard let loginUrl = loginUrl, let auth = auth else { return }
        UIApplication.shared.open(loginUrl, options: [:]) { (loginSuccessful) in
            if loginSuccessful {
                if auth.canHandle(auth.redirectURL) {
                    print("I can handle the redirect URL!")
                }
            }
        }
    }
    
    private func subviewSetup() {
        self.view.addSubview(self.loginButton)
        self.loginButton.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.loginButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        self.loginButton.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: 0).isActive = true
        
        self.view.addSubview(self.playButton)
        self.playButton.topAnchor.constraint(equalTo: self.loginButton.bottomAnchor, constant: 8).isActive = true
        self.playButton.leftAnchor.constraint(equalTo: self.loginButton.leftAnchor, constant: 0).isActive = true
        self.playButton.rightAnchor.constraint(equalTo: self.loginButton.rightAnchor, constant: 0).isActive = true
        self.playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(self.playlistsButton)
        self.playlistsButton.topAnchor.constraint(equalTo: self.playButton.bottomAnchor, constant: 8).isActive = true
        self.playlistsButton.leftAnchor.constraint(equalTo: self.playButton.leftAnchor, constant: 0).isActive = true
        self.playlistsButton.rightAnchor.constraint(equalTo: self.playButton.rightAnchor, constant: 0).isActive = true
        self.playlistsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func updateAfterFirstLogin () {
        let sessionObj = UserDefaults.standard.value(forKeyPath: "SpotifySession")
        let userid = UserDefaults.standard.value(forKeyPath: "SpotifyUserId")
        let sessionDataObj = sessionObj as! Data
        let userIdDataObj = userid as! Data
        let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
        let spotifyUserId = NSKeyedUnarchiver.unarchiveObject(with: userIdDataObj) as! String
        self.session = firstTimeSession
        print("I'm in the updateAfterFirstLogin Routine and I was able to pull this user id from user defaults: \(spotifyUserId)")
    }
    
    @objc func initSpotifyPlayer(){
        guard let authSession = self.session, self.player == nil else { return }
        self.player = SPTAudioStreamingController.sharedInstance()
        self.player?.playbackDelegate = self
        self.player?.delegate = self
        try! self.player?.start(withClientId: auth!.clientID)
        self.player?.login(withAccessToken: authSession.accessToken)
    }
    
    @objc func pullPlaylists() {
        let sptMeta = AtticusSpotifyMeta()
        guard let authSession = self.session else { return }
        sptMeta.getCurrentUserPlaylists(withAccessToken: authSession.accessToken)
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        print("Audio streaming logged in")
        self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 45, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String!) {
        NSLog("Started Playing Track, %@", trackUri)
    }
    
    func audioStreamingDidLosePermission(forPlayback audioStreaming: SPTAudioStreamingController!) {
        print("Audio Streaming did lose permissions")
    }
    
    func audioStreamingDidLogout(_ audioStreaming: SPTAudioStreamingController!) {
        print("Audio Streaming logged out")
    }
    
    func audioStreamingDidDisconnect(_ audioStreaming: SPTAudioStreamingController!) {
        print("Audio Streaming Did Disconnect")
    }
    
    func audioStreamingDidBecomeActivePlaybackDevice(_ audioStreaming: SPTAudioStreamingController!) {
        print("Audio streaming did become active playback on ios device")
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceiveError error: Error!) {
        print("Audio Streaming received the following error: \(error)")
    }
    
    private func startAuthFlow() {
        guard let auth = self.auth else { return }
        if auth.session.isValid() {
            self.player?.login(withAccessToken: auth.session.accessToken)
        } else {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

