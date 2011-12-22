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

  $('input#search').hidingprompt(function(val){
    $("#list").maskedload("/?query="+val)
  })

  $('.add input.prompt').hidingprompt(function(val){    
    $("#list").maskedload("/?query="+val)
  })

  $('.add textarea.prompt').hidingprompt(function(val){
  })

  $('.add .form').liveValidation({
    validIco: '/images/jquery.liveValidation-valid.png', 
    invalidIco: '/images/jquery.liveValidation-invalid.png', 
    required: ['rus', 'content'],
    fields: {rus: /^([А-ЯЁ][а-яё]+(-[А-ЯЁ][а-яё]+)*)(\s[А-ЯЁ][а-яё]+){2,}$/}
  })

  $('.collapsed').click(function(){
    $('.add .title').hide()
    $('.collapsed .form').slideDown('veryslow', function(){
      $('.add').removeClass('collapsed')
    })
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
