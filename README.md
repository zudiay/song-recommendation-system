# song-recommendation-system

A song recommendation system in Prolog. It helps users to find new songs in their favorite genre with the specified song features.
There are 3 files in the knowledge base: artists.pl, albums.pl, tracks.pl. These are collected with the help of Spotify API. 

There are three different types of predicates defined
as follows:

````
artist(ArtistName, ArtistGenres, AlbumIds).
– ArtistName: Name of the artist. (string)
– ArtistGenres: List of genres the artist associated with. (list of strings)
– AlbumIds: List of albums of the artist specified with their IDs. (list of strings)
````
````
• album(AlbumId, AlbumName, ArtistNames, TrackIds).
– AlbumId: A unique ID of an album. (string)
– AlbumName: Name of the album. (string)
– ArtistNames: Names of album’s artists. (list of strings)
– TrackIds: List of tracks in the album specified with their IDs. (list of strings)
````
````
• track(TrackId, TrackName, ArtistNames, AlbumName, Features).
– TrackId: A unique ID of a track. (string)
– TrackName: Name of the track. (string)
– ArtistNames: List of names of track’s artists. (list of strings)
– AlbumName: Name of the album. (string)
– Features: [explicit, danceability, energy, key, loudness, mode,
speechiness, acousticness, instrumentalness, liveness, valence, tempo,
duration ms, time signature]
````

In the project, you will only use danceability, energy, mode, speechiness, acousticness, instrumentalness, liveness, valence features are used. All features are numbers.

## Predicates

- ````getArtistTracks(+ArtistName, -TrackIds, -TrackNames)````
<br> Return track IDs and track names of an artist.

````
?- getArtistTracks("Queen", TrackIds, TrackNames).
TrackIds = ["3YM9o7X3ar7Dm39zXadQSz", "5txoZyuAmtCfmDjUCEphWm",
"34pz8XUZRfw04lk4DPtwa7", "300YN8ebGB90nDuzgz0f3O",
"5Q2cQZKPvF4bpcjV3TCTss", "3z8h0TU7ReDPLIbEnYhWZb",
"4ysz5yttr3rpRkvyVMLlRB", "1F9NVicWfNQA5ki8WmEtk8",
"6Am82YdURCRXRvoVUObzzG"|...],
TrackNames = ["20th Century Fox Fanfare", "Somebody To Love - 2011 Mix", "Keep
Yourself Alive - Live At The Rainbow", "Killer Queen - 2011 Mix", "Fat Bottomed Girls
- Live In Paris", "Bohemian Rhapsody - 2011 Mix", "Now I’m Here - Live At The Hammersmith
Odeon", "Crazy Little Thing Called Love", "Love Of My Life - Live At Rock In Rio"|...]..
````
- ```albumFeatures(+AlbumId, -AlbumFeatures)```
<br> Return the features of an album. Feature of an album is defined as the average of the features of its tracks.
`````
?- albumFeatures("32fmr8WaoHl7XJXnlzyVyX", AlbumFeatures). (Kuzu Kuzu by Tarkan)
AlbumFeatures = [0.6772, 0.8321999999999999, 0, 0.07518, 0.0970878, 0.165034,
0.12138000000000002, 0.6681999999999999].
`````

- ```artistFeatures(+ArtistName, -ArtistFeatures)```
<br> Return the features of an artist. Feature of an artist is defined as the average of the features of its tracks.
`````
?- artistFeatures("Tarkan", ArtistFeatures).
ArtistFeatures = [0.676012048192771, 0.8034457831325299, 0.3855421686746988,
0.06733493975903615, 0.11073422891566266, 0.04274608807228914, 0.19710722891566274,
0.6231686746987952].
`````

- ```trackDistance(+TrackId1, +TrackId2, -Score)```
<br> Distance between two tracks depends on the Euclidean distance between their features. Lower the distance, the more similar the tracks.
`````
trackDistance("0QZ9l0S8xGFnAiDNHpbNEl", "4jZWeEaLCnwYtLnVEN6BYV", Score). (Tides of Time and Blue Jeans)
Score = 1.1581405830046458.
`````

- ```albumDistance(+AlbumId1, +AlbumId2, -Score) ```
<br> Distance between two albums depends on the Euclidean distance between their features.
`````
?- albumDistance("49MNmJhZQewjt06rpwp6QR", "0bUTHlWbkSQysoM3VsWldT", Score).
Score = 0.5015809817141805.
`````

- ```artistDistance(+ArtistName1, +ArtistName2, -Score)```
<br> Distance between two artists depends on the Euclidean distance between their features.
`````
?- artistDistance("Jennifer Lopez", "Ellie Goulding", Score).
Score = 0.2927784511950276.
`````

- ```findMostSimilarTracks(+TrackId, -SimilarIds, -SimilarNames) ```
<br> Given a track, you will return its 30 closest neighbors (most similar 30 tracks).
````
?- findMostSimilarTracks("7f9I5WdyXm5q1XqnSYgQZb", SimilarIds, SimilarNames). (Brianstorm by Arctic Monkeys)
SimilarIds = ["6807DEj6vL5hhuWU3Qgaw9", "2QKfks5yuzxNtGj16TVL8y",
"3R2ujuKBNOLLmI3BN4pQYh", "4hn85MteYZcc5WMVPYT2Ua",
"1qYDzLpv3mUviEIYN5Q4vG", "2iR5ItVdY6WTMvPEgNT3ri",
"15vTJnpJ9ypbisykXVaawK", "0CHZjALtuGGST7sOEqofJM",
"6V68ItawQkQlZhYIf1S86C"|...],
SimilarNames = ["Going My Way!", "Grammatizator", "Built To Survive", "Milestone",
"An Evening of Extraordinary Circumstance", "Are You There Margaret? It’s Me, God",
"Know", "FEED THE FIRE", "Crazy = Genius"|...].
````

- ```findMostSimilarAlbums(+AlbumId, -SimilarIds, -SimilarNames) ```
<br> Given an album, you will return its 30 closest neighbors (most similar 30 albums).
`````
?- findMostSimilarAlbums("32fmr8WaoHl7XJXnlzyVyX", SimilarIds, SimilarNames). (Kuzu
Kuzu by Tarkan)
SimilarIds = ["0yoy3Hh3yFZGb2KdXw10GQ", "4rVINT2gMVCFNjekXhBnAY",
"40BygoJE7fxxXls20NtptS", "51vRvV83RdWGP9FpzGe4SQ",
"2eVhDmqxQ9nzSs34hhXBFR", "6gCIerPZhK4Suewkg3NjOZ",
"4uzBMJpPFHst5PiCduRKFH", "4VxqrQsfvo0e9GBqcH1qb0",
"1oXQHuGT3v1BxM0gYVcWTg"|...],
SimilarNames = ["Metamorfoz Remixes", "Killing Me Softly", "Yaqti", "The Time
Is Now (Deluxe)", "Spilling Over Every Side", "私を鬼ヶ島に連れてって", "Setareh",
"Arash", "Kusursuz 19"|...].
`````

- ```findMostSimilarArtists(+ArtistName, -SimilarArtists)```
<br> Given an artist, you will return its 30 closest neighbors (most similar 30 artists).
`````
?- findMostSimilarArtists("Avicii", SimilarArtists).
SimilarArtists = ["Olly Murs", "Jennifer Lopez", "Katy Perry", "Sia", "Dua Lipa",
"P!nk", "Kesha", "Red Hot Chili Peppers", "The Knocks"|...].
`````
- ```filterExplicitTracks(+TrackList, -FilteredTracks) ```
<br> Filter tracks which has explicit lyrics and return the filtered tracks
`````
?- TrackList = ["0gvQoTWRxsW5Rd7KgPp0u3", "6HZILIRieu8S0iqY8kIKhj", "3B0irDyS69y5eAz15xV2Ee"],
filterExplicitTracks(TrackList, FilteredTracks).
FilteredTracks = ["3B0irDyS69y5eAz15xV2Ee"].
`````

- ```getTrackGenre(+TrackId, -Genres)```
<br>  Return genres of a track. Genres of a track is a list of genres that its
artists associated with. There may be a multiple of artists of a track. In this case, genres are the
concatenated list genres of both artists. If there is no genre associated with the artist, return an
empty list.
`````
?- getTrackGenre("0gvQoTWRxsW5Rd7KgPp0u3", Genres). (HUMBLE. by Kendrick Lamar)
Genres = ["conscious hip hop", "hip hop", "rap", "west coast rap"].
`````
- ```discoverPlaylist(+LikedGenres, +DislikedGenres, +Features, +FileName, -Playlist)```
<br> The user will enter a list of liked genres, a list of disliked
genres, features (danceability, energy, . . . ) and the recommendation system will return 30 tracks
with respect to these settings. The genre of each track in the playlist includes at least one
string from LikedGenres, and no string from DislikedGenres. 
The playlist is sorted with respect to distances between tracks and Features. The playlist is written to the file with name FileName.






<i> Developed for CMPE 260 Principles of Programming Languages course, Bogazici University Computer Engineering, Spring 2020. <i>
