$(function(){


    const get_url = (p, f) => { return '/imgs/virtual-corals/corals/'+p+'/frame-'+f+'.jpeg' }

    const data = {
        'options': [
            ['2F64_evolve', 30], []
        ]

    }

    $('.evolution_item').each(function() {
        var num = $(this).data('num');
        var path = $(this).data('path');

        var $img = $('<img>').addClass('slide img_small');
        $img.attr('src', get_url(path, 0));
        $(this).append($img);

        // for (var i = 0; i <= num; i++) {
        //     var $img = $('<img>').addClass('slide img_small');
        //     $img.attr('src', '/imgs/virtual-corals/corals/'+path+'/frame-'+i+'.jpeg');
        //     $(this).append($img);
        // }
    });

    $('.evolution_container').each(function() {
        var $items = $(this).find('.evolution_item');
        var slider = $(this).find(".slider")[0];

        slider.oninput = function() {
            // var percent = Math.min(parseInt(this.value) / 100, 0.99);
            var percent = Math.min(parseFloat(this.value), 0.99);

            $items.each(function() {
                var path = $(this).data('path');
                var frame = Math.floor($(this).data('num') * percent);
                $(this).find('img')[0].src = get_url(path, frame);
            });
        };
    });
});