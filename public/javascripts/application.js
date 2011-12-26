$(function() {
  $('.rate span').live('click', function() {
    var el = $(this)
    var ref = el.attr('ref')
    $.post(ref, function(data) {
      el.siblings('span.rating').text(data)
      if(el.hasClass('plus')) el.removeClass('weak').siblings('.minus').addClass('weak')
      else if(el.hasClass('minus')) el.removeClass('weak').siblings('.plus').addClass('weak')
    })
  })

  setTimeout("change_quote()", 6000)

  $(".recommendations").maskedload("/rating/recommendations")
  $(".friends").maskedload("/rating/friends")
  $(".my").maskedload("/rating/my")
  $(".feed").maskedload("/rating/feed")

  FB.init({appId: '273684999345723', xfbml: true, cookie: true, oauth: true});

  if($('#not_logged_in').length == 1 && $('#no_auto_login').length == 0) {
    FB.getLoginStatus(function(response) {
      if (response.status === 'connected') {
        var uid = response.authResponse.userID;
        var accessToken = response.authResponse.accessToken;
        location.href = "/auth/callback?token="+accessToken+"&uid="+uid
      }
    })
  }

  $('.add .form').liveValidation({
    validIco: '/images/jquery.liveValidation-valid.png', 
    invalidIco: '/images/jquery.liveValidation-invalid.png', 
    required: ['rus', 'content'],
    fields: {rus: /^([А-ЯЁ][а-яё]+(-[А-ЯЁ][а-яё]+)*)(\s[А-ЯЁ][а-яё]+){2,}$/}
  })

  var close_and_reload = function(callback){
    $('.form').hide()
    $('.add').addClass('collapsed')
    $('.add .title').show()
    var query = ($('input#search').val() == $('input#search').attr('rel')) ? '' : $('input#search').val()
    $("#list").maskedload("/?query="+query, callback)
    return false
  }

  $('.add .form input[type=submit]').click(function(){
    $.ajax({
      url: '/person/create',
      data: {
        person: {
          name: $('#name').val(),
          bio: $('#bio').val(),
          photo: $('#photo').val()
        }
      },
      type: 'POST',
      success: function(data){
        close_and_reload(function(){
          $('#list table tr').insertBefore(data)
        })
      },
      error: function(xhr, status, error){
        $.jGrowl(xhr.responseText)
      }
    })
  })

  $('input#search').hidingprompt(function(val){
    $("#list").maskedload("/?query="+val)
  })

  var submit_enable = function(){
    $('.add .form input[type=submit]').attr('disabled',
      ($('.add .form img[alt="Invalid"]').length > 0) || ($('#list table tr').length > 0)
    )
  }

  $('.add input.prompt').hidingprompt(function(val){    
    $("#list").maskedload("/?query="+val, submit_enable)
  })

  $('.add textarea.prompt').hidingprompt(submit_enable)

  $('.collapsed').click(function(){
    $('.add .title').hide()
    $('.collapsed .form').slideDown('veryslow', function(){
      $('.add').removeClass('collapsed')
      submit_enable()
    })
  })
  $('.add .form #cancel').click(close_and_reload)

  $('.menu a.dyn').click(function(){
    var query = ($('input#search').val() == $('input#search').attr('rel')) ? '' : $('input#search').val()
    var filter = $(this).attr('href')
    $("#list").maskedload(filter+"/?query="+query)    
    return false
  })
})

function change_quote() {
  var current = $(".header .sub .quotes p.active")
  current.fadeOut("slow", function() {
    current.removeClass('active')
    var quotes = $(".header .sub .quotes p")
    var index = Math.floor(Math.random()*quotes.length)
    if(index == current.data('index')) index = index + 1
    if(index >= quotes.length) index = 0
    var next = quotes.eq(index)
    next.addClass('active').data('index', index).fadeIn("slow")
  })
  setTimeout("change_quote()", 6000)
}
