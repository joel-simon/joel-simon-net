'use strict';


var animation = window.requestAnimationFrame ||
                window.webkitRequestAnimationFrame ||
                window.mozRequestAnimationFrame ||
                window.msRequestAnimationFrame ||
                window.oRequestAnimationFrame;

(function() {
    var width, height

    var n_frames = [97, 103];
    var img_aspect = [1920 / 1080, 1081 / 1358];
    var images = [null, null];
    var size = 0;
    var others_loaded = false;

    var video_scroll_length = 5000;
    var after_padding = 1000;

    var $container = null;
    var $img = null;
    var last_frame = null;
    var last_scroll = null;


    function loop() {
        var frame, y, percent, scroll, src;
        scroll = window.pageYOffset;

        if (scroll == last_scroll) {
            return animation(loop);
        } else {
            last_scroll = scroll;
        }

        if (scroll < video_scroll_length + after_padding) {
            y = 0;
            percent = .5 + (scroll / video_scroll_length) /2;

            frame = Math.min(Math.floor(percent * n_frames[size]), n_frames[size] - 1);
            frame = (frame<0) ? 0 : frame; // Don't allow negative.

            if (frame !== last_frame) {
                last_frame = frame;
                src = images[ size ][ frame ].src
                $img[ 0 ].src = images[ size ][ frame ].src;
                // $container.css('background-image', 'url('+ src +')');
            }

        } else {
            y = video_scroll_length + after_padding - scroll;
        }

        if (scroll > height / 4 ) {
            $img.css('filter', '');
            $img.css('-webkit-filter', '');

        } else {
            $img.css('filter', 'blur(3px)');
            $img.css('-webkit-filter', 'blur(3px)');
        }

        var transform = 'translate3d(0px, ' + y + 'px, 0)';
        $container[0].style.MozTransform = transform;
        $container[0].style.webkitTransform = transform;
        return animation(loop);
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
            if (width > height){
                img.src = '/imgs/virtual-corals/haeckal_half/frame-' + i + '.jpeg';
                images[0].push(img);
            } else {
                img.src = '/imgs/virtual-corals/haeckal_tall/frame-' + i + '.jpeg';
                images[1].push(img);
            }
            img.addEventListener( 'load', incrementCounter, false );
        }
    }

    function resize() {
        height = $(window).height();
        width = $(window).width();
        size = width>height ? 0:1
        load_images();

        var padding_top = 0;

        if (width / img_aspect[size] > height) {
            // console.log('landscape');
            // Limiting factor is height.
            var img_width = height * img_aspect[size];
            $img.css('height', '100%');
            $img.css('width', 'auto');
            $img.css('padding-left', (width - img_width) / 2);
            $img.css('padding-top', 0);
        } else {
            // Limiting factor is width.
            var img_height = width / img_aspect[size];
            padding_top = Math.floor((height - img_height) / 2)
            $img.css('width', '100%');
            $img.css('height', 'auto');
            $img.css('padding-top', padding_top);
            $img.css('padding-left', 0);
        }

        $('#scroll_padding').height(video_scroll_length + height + after_padding - padding_top);
    };

    $(function() {
        var i, j, ref;

        $container = $('#fullscreen_container');
        $img = $container.find('img');

        resize();

        $(window).resize( resize );
        // return $(window).scroll(loop);
        return window.requestAnimationFrame(loop);
    });

})();