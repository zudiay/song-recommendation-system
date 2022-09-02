
% three different types of predicates defined
% artist(ArtistName, Genres, AlbumIds).
% album(AlbumId, AlbumName, ArtistNames, TrackIds).
% track(TrackId, TrackName, ArtistNames, AlbumName, [Explicit, Danceability, Energy,
%                                                    Key, Loudness, Mode, Speechiness,
%                                                    Acousticness, Instrumentalness, Liveness,
%                                                    Valence, Tempo, DurationMs, TimeSignature]).

features([explicit-0, danceability-1, energy-1,
          key-0, loudness-0, mode-1, speechiness-1,
       	  acousticness-1, instrumentalness-1,
          liveness-1, valence-1, tempo-0, duration_ms-0,
          time_signature-0]).

% filter_features(+UnfilteredFeatures, -FilteredFeatures)
filter_features(Features, Filtered) :- features(X), filter_features_rec(Features, X, Filtered).
filter_features_rec([], [], []).
filter_features_rec([FeatHead|FeatTail], [Head|Tail], FilteredFeatures) :-
    filter_features_rec(FeatTail, Tail, FilteredTail),
    _-Use = Head,
    (
        (Use is 1, FilteredFeatures = [FeatHead|FilteredTail]);
        (Use is 0,
            FilteredFeatures = FilteredTail
        )
    ).

% Divides each element of the given list by the given number, returns as Result.
% listDivision(+List, +Number, -Result)
listDivision([], _, []).
listDivision([H|T], N, R) :- H2 is H/N,
    listDivision(T, N, T2),
    R = [H2|T2].


% computes the sum of corresponding elements of lists of same length.
% listSum(+List1,+List2,-List3)
listSum([],L1,L1).
listSum([],[],[]).
listSum(L1,[],L1).
listSum([H1|T1],[H2|T2],[RH|RT]):-listSum(T1,T2,RT), RH is H1+H2.


% Does listSum operation for all lists given in the first argument
% listlistSum(+List1,-List2).
listlistSum([List1],List1).
listlistSum([H1|T1], List2) :- listlistSum(T1, List3),
								listSum(H1,List3, List2),!.

% give us the square of Euclidean distance between two lists.
% listDiffSquaredSum(+List1,+List2,-Score).
listDiffSquaredSum([],[],0).
listDiffSquaredSum([H1|T1],[H2|T2],S):-listDiffSquaredSum(T1,T2,Z), R is abs(H1-H2), S is Z + (R*R) .

% give us the filtered featues of one track of the given artist.
% getArtistTrackFiltered(+ArtistName,-FilteredTrack)
getArtistTrackFiltered(ArtistName,FilteredTrack):- artist(ArtistName,_,AlbumIds), member(AlbumId,AlbumIds), album(AlbumId,_,_,TrackIds), 
													member(TrackId,TrackIds),track(TrackId,_,_,_,UnfilteredTrackFeats),
														filter_features(UnfilteredTrackFeats, FilteredTrack).


% give us track IDs and track names of an artist.
% getArtistTracks(+ArtistName, -TrackIds, -TrackNames) 5 points
getArtistTracks(ArtistName, TrackIds, TrackNames):- findall(L,( artist(ArtistName,_,AlbumIds),member(AlbumId,AlbumIds),album(AlbumId,_,_,TrackIds), member(ID,TrackIds), track(ID,N,_,_,_), append([], [ID,N],L)),TrackInfo), 
															length(TrackInfo,LEN),
															findall(TRID, ((nth1(I,TrackInfo,G), I < LEN+1),nth1(1,G,TRID)), TrackIds),
															findall(TRN, ((nth1(I,TrackInfo,G), I < LEN+1),nth1(2,G,TRN)), TrackNames).
													

% give us the features of an album. Feature of an album is defined as the average of the features of its tracks.
% features considered : danceability, energy, mode, speechiness, acousticness, instrumentalness, liveness, valence.
% albumFeatures(+AlbumId, -AlbumFeatures) 5 points
albumFeatures(AlbumId, AlbumFeatures):- album(AlbumId,_,_,TrackIds), findall(FilteredTrack, (member(TrackId,TrackIds),track(TrackId,_,_,_,UnfilteredTrackFeats),
										filter_features(UnfilteredTrackFeats, FilteredTrack)),FilteredTrackList),
										listlistSum(FilteredTrackList, S),
										length(FilteredTrackList, N),
										listDivision(S,N,AlbumFeatures).


% give us the features of an artist. Feature of an artist is defined as the average of the features of its tracks. 
% artistFeatures(+ArtistName, -ArtistFeatures) 5 points
artistFeatures(ArtistName, ArtistFeatures) :- findall(FilteredTrack, getArtistTrackFiltered(ArtistName, FilteredTrack),FilteredTrackList),
										listlistSum(FilteredTrackList, S),
										length(FilteredTrackList, N),
										listDivision(S,N,ArtistFeatures).



% give us the Euclidean distance between features of two tracks.
% trackDistance(+TrackId1, +TrackId2, -Score) 5 points
trackDistance(TrackId1, TrackId2, Score):- track(TrackId1,_,_,_,TrackFeatures1),track(TrackId2,_,_,_,TrackFeatures2),
											filter_features(TrackFeatures1, FilteredTrackFeatures1),filter_features(TrackFeatures2, FilteredTrackFeatures2),
											listDiffSquaredSum(FilteredTrackFeatures1,FilteredTrackFeatures2,SquaredSum),
											Score is sqrt(SquaredSum),!.


% give us the Euclidean distance between features of two albums.
% albumDistance(+AlbumId1, +AlbumId2, -Score) 5 points
albumDistance(AlbumId1, AlbumId2, Score) :-albumFeatures(AlbumId1, AlbumFeatures1),albumFeatures(AlbumId2, AlbumFeatures2),
											listDiffSquaredSum(AlbumFeatures1,AlbumFeatures2,SquaredSum),
											Score is sqrt(SquaredSum).


% give us the Euclidean distance between features of two artist.
% artistDistance(+ArtistName1, +ArtistName2, -Score) 5 points
artistDistance(ArtistName1, ArtistName2, Score):- artistFeatures(ArtistName1, ArtistFeatures1),artistFeatures(ArtistName2, ArtistFeatures2),
													listDiffSquaredSum(ArtistFeatures1,ArtistFeatures2,SquaredSum),
													Score is sqrt(SquaredSum).


% give us the track names and ids that have the least distance to the given track.
% findMostSimilarTracks(+TrackId, -SimilarIds, -SimilarNames) 10 points
findMostSimilarTracks(TrackId, SimilarIds, SimilarNames):- findall(T, (track(ID,N,_,_,_),(\+(ID=TrackId)), trackDistance(TrackId,ID, D),T=[D,N,ID]),DistList),
															sort(DistList,X),
															findall(E, (nth1(I,X,E), I < 31), L),
															findall(IDN, ((nth1(I,L,G), I < 31),nth1(3,G,IDN)), SimilarIds),
															findall(TRN, ((nth1(I,L,G), I < 31),nth1(2,G,TRN)), SimilarNames).


% give us the album names and ids that have the least distance to the given album.
% findMostSimilarAlbums(+AlbumId, -SimilarIds, -SimilarNames) 10 points
findMostSimilarAlbums(AlbumId, SimilarIds, SimilarNames):- findall(T, (album(ID,N,_,_),(\+(ID=AlbumId)), albumDistance(AlbumId,ID, D),T=[D,N,ID]),DistList),
															sort(DistList,X),
															findall(E, (nth1(I,X,E), I < 31), L),
															findall(IDN, ((nth1(I,L,G), I < 31),nth1(3,G,IDN)), SimilarIds),
															findall(TRN, ((nth1(I,L,G), I < 31),nth1(2,G,TRN)), SimilarNames).


% give us the artist names that have the least distance to the given artist.
% findMostSimilarArtists(+ArtistName, -SimilarArtists) 10 points
findMostSimilarArtists(ArtistName, SimilarArtists) :- findall(T, (artist(N,_,_),(\+(N=ArtistName)), artistDistance(ArtistName,N, D),T=[D,N]),DistList),
															sort(DistList,X),
															findall(E, (nth1(I,X,E), I < 31), L),
															findall(TRN, ((nth1(I,L,G), I < 31),nth1(2,G,TRN)), SimilarArtists).

%  give us the list of tracks which are not explicit, in the given list.
% filterExplicitTracks(+TrackList, -FilteredTracks) 5 points
filterExplicitTracks(TrackList, FilteredTracks):- findall(TrackId, (member(TrackId, TrackList),track(TrackId,_,_,_,[H|_]), H is 0), FilteredTracks).


% give us the set of genres of the artists of the singer of the given track.
% getTrackGenre(+TrackId, -Genres) 5 points
getTrackGenre(TrackId, Genres) :- track(TrackId, _, AL, _,_),
									findall(Genre, (member(Artist,AL), artist(Artist, ArtistGenres,_), member(Genre, ArtistGenres)), GenresList),
									list_to_set(GenresList,Genres).

% give us if the GenreList list contains at least one of the elements in LikedGenres list (substrings accepted).
% suitableLike(+GenreList, +LikedGenres)
suitableLike(GenreList, LikedGenres):-member(X, LikedGenres), (checkElemList(X,GenreList),!).

% give us if the GenreList list contains none one of the elements in DisikedGenres list (substrings accepted).
% suitableDislike(+GenreList, +DislikedGenres)
suitableDislike(GenreList, DislikedGenres):-(\+suitableLike(GenreList,DislikedGenres)).

% give us if the element occurs in the list (substrings accepted).
% checkElemList(+Elem, +[H|T])
checkElemList(Elem, [H|T]):-checkElemList(Elem, T),!; Elem=H,! ; sub_string(H,_,_,_,Elem),!.

% give us 30 tracks, that are most similar to the given features and and that contain at least one genre of LikedGenres and none of DislikedGenres.
% write the track Ids, Names, Artists and Distances to the file named Filename.
% discoverPlaylist(+LikedGenres, +DislikedGenres, +Features, +FileName, -Playlist) 30 points
discoverPlaylist(LikedGenres, DislikedGenres, Features, FileName, Playlist):-findall(TrackId, (track(TrackId,_,_,_,_),getTrackGenre(TrackId,GL), suitableLike(GL, LikedGenres),suitableDislike(GL,DislikedGenres)), GenreFilteredTracks),
																			 findall(T, (member(TID, GenreFilteredTracks), track(TID,_,_,_,TF),filter_features(TF,Feat),listDiffSquaredSum(Features,Feat,DSQ),D is sqrt(DSQ),T=[D,TID]),DistList),
																			 sort(DistList,X),
																			 findall(E, (nth1(I,X,E), I < 31), L),
																			 findall(DIS, ((nth1(I,L,G), I < 31),nth1(1,G,DIS)), PlaylistDistances),
																			 findall(IDN, ((nth1(I,L,G), I < 31),nth1(2,G,IDN)), PlaylistIds),
																			 findall(TRN, (member(ID,PlaylistIds), track(ID, TRN, _,_,_)), PlaylistNames),
																			 findall(ART, (member(ID,PlaylistIds), track(ID, _, ART,_,_)), PlaylistArtist),
																			 Playlist= PlaylistIds,
																			 open(FileName,write,Stream),
   																			 writeln(Stream,PlaylistIds),
   																			 writeln(Stream,PlaylistNames),
   																			 writeln(Stream,PlaylistArtist),
   																			 writeln(Stream,PlaylistDistances),
    																		 close(Stream).   







