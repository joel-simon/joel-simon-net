'use strict';

(function() {
    $(function() {
        var $title_container = $('#title_container');
        var $animation_container = $('#fullscreen_container');
        var $video = $title_container.find('video');
        var $h1 = $title_container.find('h1');
        var $sources = $video.children();

        function resize() {
            var height = ($title_container.height() - $h1.outerHeight(true));
            $video.css('padding-top', height*0.1);
            $video.height(height * 0.8);
            $video.show()[0].play();
        };

        $video.load(resize);

        /*
            Pick a random video ID.
        */
        var id = 1+ Math.floor((Math.random() * 4));
        $sources[0].src = '/imgs/corals/58A2_g360/out'+id+'.webm';
        $sources[1].src = '/imgs/corals/58A2_g360/out'+id+'.mp4';
        $video[0].load();

        /*
            Clicking video scrolls to animation.
        */
        $video.on('click touchend', function(event) {
            $('html,body').animate({
                scrollTop: $animation_container.offset().top
            }, 2000);
        });

        resize();
        $(window).resize( resize );
    });

})();