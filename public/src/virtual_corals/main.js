$(function(){
    var $container = $('#webgl_container');

    if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {

    } else {

        $(window).scroll(function(){
            var divTop = $container.offset().top;
            var divBottom = $container.offset().top + $container.height();
            var windowTop = $(window).scrollTop();
            var windowBottom = windowTop+$(window).height();

            if (divBottom >= windowTop && divTop < windowBottom) {
                window.webgl_show = true;
                if (!window.webgl_world_initiated) {
                    window.webgl_world_init();
                    window.webgl_world_initiated = true;
                }
            } else {
                window.webgl_show = false;
            }
        });

        // $('img.coral').click(function() {
        //     var coral_id = $(this).data('coral');
        //     if (!window.webgl_world_initiated) {
        //         window.webgl_world_init();
        //         window.webgl_world_initiated = true;
        //     }
        //     if (coral_id) {
        //         window.webgl_world_add_coral('coral_data/coral/'+coral_id+'/').then(() => {
        //             // alert('Coral added to reef.')
        //         }).catch((error) => {
        //             alert(error)
        //         })
        //     }
        // });
    }

    window.load_all_images = function() {
        $('img').each(function() {
            var src = $(this).data('src');
            if (src) {
                this.src = src;
            };
        });
    }

});
