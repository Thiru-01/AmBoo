import 'dart:convert';

SpotifyModel spotifyModelFromJson(String str) =>
    SpotifyModel.fromJson(json.decode(str));

String spotifyModelToJson(SpotifyModel data) => json.encode(data.toJson());

class SpotifyModel {
  SpotifyModel({
    required this.tracks,
    required this.artists,
    required this.albums,
    required this.playlists,
    required this.shows,
    required this.episodes,
  });

  Albums tracks;
  Albums artists;
  Albums albums;
  Albums playlists;
  Albums shows;
  Albums episodes;

  factory SpotifyModel.fromJson(Map<String, dynamic> json) => SpotifyModel(
        tracks: Albums.fromJson(json["tracks"]),
        artists: Albums.fromJson(json["artists"]),
        albums: Albums.fromJson(json["albums"]),
        playlists: Albums.fromJson(json["playlists"]),
        shows: Albums.fromJson(json["shows"]),
        episodes: Albums.fromJson(json["episodes"]),
      );

  Map<String, dynamic> toJson() => {
        "tracks": tracks.toJson(),
        "artists": artists.toJson(),
        "albums": albums.toJson(),
        "playlists": playlists.toJson(),
        "shows": shows.toJson(),
        "episodes": episodes.toJson(),
      };
}

class Albums {
  Albums({
    required this.href,
    required this.items,
    required this.limit,
    required this.next,
    required this.offset,
    required this.previous,
    required this.total,
  });

  String href;
  List<Item> items;
  int limit;
  String next;
  int offset;
  String previous;
  int total;

  factory Albums.fromJson(Map<String, dynamic> json) => Albums(
        href: json["href"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        limit: json["limit"],
        next: json["next"],
        offset: json["offset"],
        previous: json["previous"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "limit": limit,
        "next": next,
        "offset": offset,
        "previous": previous,
        "total": total,
      };
}

class Item {
  Item();

  factory Item.fromJson(Map<String, dynamic> json) => Item();

  Map<String, dynamic> toJson() => {};
}
