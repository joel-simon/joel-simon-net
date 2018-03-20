'use strict';


var animation = window.requestAnimationFrame ||
                window.webkitRequestAnimationFrame ||
                window.mozRequestAnimationFrame ||
                window.msRequestAnimationFrame ||
                window.oRequestAnimationFrame;

(function() {
    var width, height

    var n_frames = [97, 103];
    var img_aspect = [1920/1080, 1081/1358 ];
    var images = [null, null];
    var size = 0;
    var others_loaded = false;

    var video_scroll_length = 5000;
    var after_padding = 1000;

    var $container = null;
    var $img = null;
    var $footer = $('#footer');
    var last_frame = null;
    var last_scroll = null;

    function scroll() {
        var frame, y, percent, src;

        var scroll = window.pageYOffset;
        var top = $('img#haeckal').offset().top;

        percent = (scroll / top) * 1.1;
        frame = Math.min(Math.floor(percent * n_frames[size]), n_frames[size] - 1);
        frame = (frame<0) ? 0 : frame; // Don't allow negative.

        if (frame !== last_frame) {
            last_frame = frame;
            src = images[ size ][ frame ].src
            $img[ 0 ].src = images[ size ][ frame ].src;
        }
        if (percent > 1.2) {
            $footer.show()
        } else {
            $footer.hide()
        }
    };

    function load_images() {
        var img;
        if (images[ size ]) {
            return;
        }

        var counter = [];
        var n = n_frames[ size ];
        console.log('load images', size, n);
        console.time('load_header');

        images[ size ] = [];

        function incrementCounter() {
            counter++;
            // resize()
            // scroll()
            if ( counter == n-1 ) {
                console.timeEnd('load_header');
                if (!others_loaded) {
                    window.load_all_images();
                    others_loaded = true;
                }

            } else if (counter == 1) {
                $img.show()
            }
            // last_scroll = -1;
        }

        for (var i = 1; i <= n; i++) {
            img = new Image();
            if (size == 0){
                img.src = '/imgs/corals/haeckal_half/frame-' + i + '.jpeg';
                images[size].push(img);
            } else {
                img.src = '/imgs/corals/haeckal_tall/frame-' + i + '.jpeg';
                images[size].push(img);
            }
            img.addEventListener( 'load', incrementCounter, false );
        }
    }

    function resize() {

        var $title_container = $('#title_container');

        // return
        height = $(window).height();
        width = $(window).width();
        size = width>height ? 0:1
        load_images();

        var padding_top = 0;

        if (width / img_aspect[size] > height) {
            // Limiting factor is height.
            var img_width = height * img_aspect[size];
            $img.css('height', '100vh');
            $img.css('width', 'auto');
            // $img.css('padding-left', (width - img_width) / 2);
            // $img.css('padding-top', 0);
        } else {
            // Limiting factor is width.
            var img_height = width / img_aspect[size];
            padding_top = Math.floor((height - img_height) / 2)
            $img.css('width', '100vw');
            $img.css('height', 'auto');
            $img.css('padding-left', 0);
        }
    };

    $(function() {
        $container = $('#fullscreen_container');
        $img = $container.find('img');
        resize();
        $(window).resize( resize );
        return $(window).scroll(scroll);
        // return window.requestAnimationFrame(loop);
    });

})();