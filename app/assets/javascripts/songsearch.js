// find template and compile it

window.SongSearch = {};

(function (exports) {
    var
    // templateSource = document.getElementById('results-template').innerHTML,
    // template = Handlebars.compile(templateSource),
    resultsPlaceholder = document.getElementById('song_results'),
    playingCssClass = 'playing',
    audioObject = null;

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
                console.log(response);
                //resultsPlaceholder.innerHTML = template(response);
            }
        });
    };

    exports.searchTracks = searchTracks;

})(window.SongSearch);

$(document).ready(function () {
    var cookies = "no really though, lunch things?";
    $('#search_form').on('submit', function (e) {
        e.preventDefault();
        SongSearch.searchTracks(document.getElementById('query').value);
    });
    console.log(cookies);
});
