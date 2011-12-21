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

  $('input#search').each(function(){
    var prompt = $(this).attr('rel');
    if($(this).val() == "")
      $(this).val(prompt).addClass('prompt');
    $(this).bind('keypress keydown change input paste', function(){
      if($(this).val() === prompt)
        $(this).val('').removeClass('prompt');
    }).bind('blur', function(){
      if($(this).val() === '')
        $(this).val(prompt).addClass('prompt');
    }).bind('input', function(){
      if($(this).val() != prompt)
        $("#list").maskedload("/?query="+$(this).val())
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
