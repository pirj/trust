$(function() {
  $('img.rate').live('click', function() {
    var el = $(this)
    var ref = el.attr('ref')
    $.post(ref, function(data) {
      el.siblings('span.rating').text(data)
      if(el.hasClass('plus')) el.removeClass('weak').siblings('.minus').addClass('weak')
      else if(el.hasClass('minus')) el.removeClass('weak').siblings('.plus').addClass('weak')
    })
  })

  setTimeout("change_quote()", 10000)

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

  $('.add .form input[type=submit]').click(function(){
    
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
  $('.add .form #cancel').click(function(){
    $('.form').hide()
    $('.add').addClass('collapsed')
    $('.add .title').show()
    $("#list").maskedload("/?query="+$('input#search').val())
    return false
  })
})

function change_quote() {
  var current = $(".header .sub .quotes p.active")
  current.fadeOut("slow", function() {
    var next = current.removeClass('active').next()
    if(next.text() == "") next = $(".header .sub .quotes p").first()
    next.addClass('active').fadeIn("slow")
  })
  setTimeout("change_quote()", 10000)
}
