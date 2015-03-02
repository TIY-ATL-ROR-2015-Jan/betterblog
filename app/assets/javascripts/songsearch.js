window.SongSearch = {};

(function (module) {
    var audioObject = null;
    var trackHTML = "<div style='background-image:url(<%= album.images[0].url %>)'" +
            "data-album-id=<%= id %> class='track cover'></div>";
    var trackTemplate = _.template(trackHTML);

    var fetchTracks = function (albumId, callback) {
        $.ajax({
            url: 'https://api.spotify.com/v1/albums/' + albumId,
            success: function (response) {
                callback(response);
            }
        });
    };

    var searchTracks = function (query) {
        $.ajax({
            url: 'https://api.spotify.com/v1/search',
            data: {
                q: query,
                type: 'track'
            },
            success: function (response) {
                $("#song_results").empty();
                console.log(response);
                _.each(response.tracks.items, function(track) {
                    $('#song_results').append(trackTemplate(track));
                });
            }
        });
    };

    module.searchTracks = searchTracks;

})(window.SongSearch);

$(document).ready(function () {
    var cookies = "no really though, lunch things?";
    $('#search_form').on('submit', function (e) {
        e.preventDefault();
        SongSearch.searchTracks(document.getElementById('query').value);
    });
    console.log(cookies);
});
