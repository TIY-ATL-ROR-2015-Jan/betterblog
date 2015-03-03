window.SongSearch = {};

(function (module) {
    var audioObject = null;
    var trackHTML = "<div style='background-image:url(<%= album.images[0].url %>)'" +
            "data-preview-url=<%= preview_url %> class='track cover'></div>";
    var trackTemplate = _.template(trackHTML);

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

    var updateAudio = function (target, attr) {
        if (audioObject) {
            audioObject.pause();
        }
        audioObject = new Audio(target.getAttribute(attr));
        audioObject.play();
        target.classList.add('playing');
        audioObject.addEventListener('ended', function () {
            target.classList.remove('playing');
        });
        audioObject.addEventListener('pause', function () {
            target.classList.remove('playing');
        });
    };

    var playTrack = function (e) {
        console.log(e);
        var target = e.target;
        if (target !== null && target.classList.contains('track')) {
            if (target.classList.contains('playing')) {
                audioObject.pause();
            } else {
                updateAudio(target, 'data-preview-url');
            }
        }
    };

    module.searchTracks = searchTracks;
    module.playTrack = playTrack;

})(window.SongSearch);

$(document).ready(function () {
    var cookies = "no really though, lunch things?";
    $('#search_form').on('submit', function (e) {
        e.preventDefault();
        SongSearch.searchTracks(document.getElementById('query').value);
    });
    $('#song_results').on('click', SongSearch.playTrack);
    console.log(cookies);
});
