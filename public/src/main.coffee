label_hover_start = (event) ->
    $label = $(@)
    label_name = $label.data('name')

    $('.project').addClass('no_hover')
    $(".label.#{label_name} h3").css('text-decoration','underline')

label_hover_end = (event) ->
    $label = $(@)
    label_name = $label.data('name')

    $('.project').removeClass('no_hover')
    $(".label.#{label_name} h3").css('text-decoration','inherit')

filter_by_label = (label_name) ->
    $('.label').not('.'+label_name).addClass('label_hidden')
    $('.project').not('.'+label_name).hide()
    $(".label.#{label_name}").addClass('active')

clear_label_filter = () ->
    $(".label.active").removeClass('active')
    $(".label.label_hidden").removeClass('label_hidden')
    $(".project").show()

label_click = (event) ->
    $label = $(@)

    if $label.hasClass('active')
        window.location.hash = ''
    else
        # history.pushState(null, null, "?page=1");
        window.location.hash = '#'+$label.data('name')

window_resize = () ->
    # container_width = $('#project_container').width()

    # innerwidth = $('.project').innerWidth()
    # outerwidth = $('.project').outerWidth()


    # num_projects = Math.floor(container_width / outerwidth)
    # margin = container_width - (num_projects * outerwidth)
    # console.log 'inner:', innerwidth
    # console.log 'outer', outerwidth
    # console.log 'num_Projects', num_projects
    # console.log container_width, num_projects*outerwidth
    # console.log 'margin', margin
    # console.log
    # $('.project').css('margin-left', margin/(2*num_projects))
    # $('.project').css('margin-right', margin/(2*num_projects))

window.onpopstate = (event) ->
    clear_label_filter()

    if window.location.hash
        label_name = window.location.hash.slice(1)
        if label_name of labels
            filter_by_label(label_name)

$ ->
    is_mobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)
    console.log('Hello Friend <3')

    $('.label').click label_click
    $(window).resize window_resize

    window_resize()

    window.onpopstate()
    # if window.location.hash
    #     label_name = window.location.hash.slice(1)
    #     $('.label').not('.'+label_name).addClass('label_hidden')
    #     $('.project').not('.'+label_name).hide()
    #     $(".label.#{label_name}").addClass('active')

    # Because of the annoying fact that on iphones clicking the first time
    # only triggers hover.
    $('.project').bind 'touchstart', ()->
        $(@).find('a').trigger("click")

    $('#label_all').click () ->
        $('.label').removeClass('label_hidden')
        $('.label').removeClass('active')

        $('.project').removeClass('active')
        $('.project').show()

        $(@).css 'visibility', 'hidden'
