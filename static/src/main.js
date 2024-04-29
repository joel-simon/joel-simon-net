
function label_hover_start(event) {
  var $label, label_name;
  $label = $(this);
  label_name = $label.data('name');
  $('.project').addClass('no_hover');
  return $(".label." + label_name + " h3").css('text-decoration', 'underline');
}

function label_hover_end(event) {
  var $label, label_name
  $label = $(this)
  label_name = $label.data('name')
  $('.project').removeClass('no_hover')
  return $(".label." + label_name + " h3").css('text-decoration', 'inherit')
}

function filter_by_label(label_name) {
  $('.label').not('.' + label_name).addClass('label_hidden')
  $('.project').not('.' + label_name).hide()
  return $(".label." + label_name).addClass('active')
}

function clear_label_filter() {
  $(".label.active").removeClass('active')
  $(".label.label_hidden").removeClass('label_hidden')
  return $(".project").show()
}

function label_click(event) {
  var $label
  $label = $(this)
  if ($label.hasClass('active')) {
    return window.location.hash = ''
  } else {
    return window.location.hash = '#' + $label.data('name')
  }
}


window.onpopstate = function(event) {
  var label_name;
  clear_label_filter();
  if (window.location.hash) {
    label_name = window.location.hash.slice(1);
    if (label_name in labels) {
      return filter_by_label(label_name);
    }
  }
};

$(function() {
  // var is_mobile;
  // is_mobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent);
  console.log('Hello Friend <3')
  $('.label').click(label_click)
  window.onpopstate()
  $('.project').bind('touchstart', function() {
    return $(this).find('a').trigger("click")
  })
  return $('#label_all').click(function() {
    $('.label').removeClass('label_hidden')
    $('.label').removeClass('active')
    $('.project').removeClass('active')
    $('.project').show()
    return $(this).css('visibility', 'hidden')
  });
});
