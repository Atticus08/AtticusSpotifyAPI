# SpotifyAPITesting

## Reason for the Repository
I'm currently working on building a framework for pulling music meta data from Spotify. For whatever reason, Spotify deprecated it's Spotify Metadata framework in it's SDK. Also, as of Swift 4, Apple introduced a standardized approach for encoding & decoding data through it's new __Encodable__ and __Decodable__ protocols. So, I thought why not try to work on building my own API client using Swift's native libraries, rather than relying on 3rd party libraries like AlamoFire or AFNetworking (I'd rather rely on native libraries anyways).  

__NOTE:__ This project/repository is currently in a "hot garbage" state. I threw some stuff together really quick to verify I had a basic understanding of working with the Spotify API, and Apple's codable protocol. I'm in the midst of cleaning everything up.