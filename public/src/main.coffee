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

label_click = (event) ->
    $label = $(@)
    label_name = $label.data('name')

    if $label.hasClass('active')
        $(".label.#{label_name}").removeClass('active')
        $(".label.#{label_name}").addClass('label_hidden')
        $(".project.#{label_name}").hide()
        $(".project.#{label_name}").removeClass('active')

    else
        # Show the projects with this label.
        $(".project.#{label_name}").show()
        $(".project.#{label_name}").addClass('active')

        # Hide other projects.
        $('.project').not('.active').hide()

        # Show the labels with the same name.
        $(".label.#{label_name}").addClass('active')
        $(".label.#{label_name}").removeClass('label_hidden')

        # Obscure other labels.
        $('.label').not('.active').addClass('label_hidden')


    # Handle cases where 'all' button should change visibility.
    if $(".active").length == 0
        $('#label_all').trigger 'click'

    else if $(".label.active").length == $('.label').length
        $('#label_all').css('visibility', 'hidden')
    else
        # Show the clear button.
        $('#label_all').css('visibility', 'visible')

window_resize = () ->
    window_width = $(document).width()
    project_width  = $('.project').outerWidth(true)
    n_cols = Math.floor($('#project_container').width() / project_width)
    padding_left = (window_width - (project_width * n_cols)) / 2.0
    $('#project_container').css 'padding-left', padding_left

$ ->
    is_mobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)
    console.log('Hello World')

    $('.label').click label_click

    $('.label').hover label_hover_start, label_hover_end

    $('#label_all').click () ->
        $('.label').removeClass('label_hidden')
        $('.label').removeClass('active')

        $('.project').removeClass('active')
        $('.project').show()

        $(@).css 'visibility', 'hidden'

    window_resize()
    $(window).resize(window_resize)
