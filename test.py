import os


def write_to_file(filename, variable):
    str = 'open("%s", write, Stream), ' % filename
    for var in variable:
        str += 'write(Stream, "%s = "), writeln(Stream, %s), ' % (var, var)
    str += 'close(Stream)'
    return str


def convert(tests, path):
    if not os.path.exists(path):
        os.mkdir(path)
    str = "swipl -g '[load].' -g '[solution].' "
    for expr, var, name in tests:
        str = str + "-g '" + expr + ', ' + write_to_file(os.path.join(path, name), var) + ".' "
        # print("-g '" + expr + ', ' + write_to_file(os.path.join(path, name), var) + ".' ")
    str += "-g halt"
    return str


test_cases = [
    ('getArtistTracks("Gorillaz", TrackIds, TrackNames)', ["TrackIds", "TrackNames"], "test-1-1.txt"),
    ('getArtistTracks("Adele", TrackIds, TrackNames)', ["TrackIds", "TrackNames"], "test-1-2.txt"),
    ('getArtistTracks("Queen", TrackIds, TrackNames)', ["TrackIds", "TrackNames"], "test-1-3.txt"),
    ('albumFeatures("0cn6MHyx4YuZauaB7Pb66o", AlbumFeatures)', ["AlbumFeatures"], "test-2-1.txt"),
    ('albumFeatures("32fmr8WaoHl7XJXnlzyVyX", AlbumFeatures)', ["AlbumFeatures"], "test-2-2.txt"),
    ('artistFeatures("Tarkan", ArtistFeatures)', ["ArtistFeatures"], "test-3-1.txt"),
    ('artistFeatures("Pantera", ArtistFeatures)', ["ArtistFeatures"], "test-3-2.txt"),
    ('trackDistance("0QZ9l0S8xGFnAiDNHpbNEl", "4jZWeEaLCnwYtLnVEN6BYV", Score)', ["Score"], "test-4-1.txt"),
    ('trackDistance("5EgYSnOYYnIEd74hxuGOTE", "2DcPVRP3xGAX1LxAIJKMWZ", Score)', ["Score"], "test-4-2.txt"),
    ('albumDistance("49MNmJhZQewjt06rpwp6QR", "0bUTHlWbkSQysoM3VsWldT", Score)', ["Score"], "test-5-1.txt"),
    ('albumDistance("49MNmJhZQewjt06rpwp6QR", "0lf5ceMub7KQhLfGxCdM06", Score)', ["Score"], "test-5-2.txt"),
    ('artistDistance("Radiohead", "Florence + The Machine", Score)', ["Score"], "test-6-1.txt"),
    ('artistDistance("Jennifer Lopez", "Ellie Goulding", Score)', ["Score"], "test-6-2.txt"),
    ('artistDistance("Mastodon", "Kendrick Lamar", Score)', ["Score"], "test-6-3.txt"),
    ('findMostSimilarTracks("1FOernT6bFAm8zscEss4Sm", SimilarIds, SimilarNames)', ["SimilarIds", "SimilarNames"], "test-7-1.txt"),
    ('findMostSimilarTracks("7f9I5WdyXm5q1XqnSYgQZb", SimilarIds, SimilarNames)', ["SimilarIds", "SimilarNames"], "test-7-2.txt"),
    ('findMostSimilarAlbums("1Mu6HgmdfdiQTOZ8mPEyFU", SimilarIds, SimilarNames)', ["SimilarIds", "SimilarNames"], "test-8-1.txt"),
    ('findMostSimilarAlbums("32fmr8WaoHl7XJXnlzyVyX", SimilarIds, SimilarNames)', ["SimilarIds", "SimilarNames"], "test-8-2.txt"),
    ('findMostSimilarArtists("Halil Sezai", SimilarArtists)', ["SimilarArtists"], "test-9-1.txt"),
    ('findMostSimilarArtists("Avicii", SimilarArtists)', ["SimilarArtists"], "test-9-2.txt"),
    ('findMostSimilarArtists("deadmau5", SimilarArtists)', ["SimilarArtists"], "test-9-3.txt"),
    ('TrackList = ["0gvQoTWRxsW5Rd7KgPp0u3", "6HZILIRieu8S0iqY8kIKhj", "3B0irDyS69y5eAz15xV2Ee"], filterExplicitTracks(TrackList, FilteredTracks)', ["FilteredTracks"], "test-10-1.txt"),
    ('getTrackGenre("0QZ9l0S8xGFnAiDNHpbNEl", Genres)', ["Genres"], "test-11-1.txt"),
    ('getTrackGenre("0gvQoTWRxsW5Rd7KgPp0u3", Genres)', ["Genres"], "test-11-2.txt"),
    ('discoverPlaylist(["pop", "blues"], ["classic"], [0.6, 0.2, 0.3, 0.4, 0.7, 0.2, 0.5, 0.5], "popblues.txt", Playlist)', ["Playlist"], "test-12-1.txt"),
    ('artistFeatures("Metallica", F), discoverPlaylist(["metal"], ["rock"], F, "likemetallica.txt", Playlist)', ["Playlist"], "test-12-2.txt"),
    ('discoverPlaylist(["birmingham metal"], [], [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5], "ozzy.txt", Playlist)', ["Playlist"], "test-12-3.txt")
]

print(convert(test_cases, "."))
os.system(convert(test_cases, "results"))
