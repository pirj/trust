function js_ready(){
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

  var timer_id = setTimeout(function(){change_quote(timer_id)}, 6000)

  $(".feed").maskedload("/rating/feed")
  if($('#not_logged_in').length == 0)
    load_feeds()

  $('.fblogin').click(function(){
    FB.login({scope : 'user_relationships,publish_stream,offline_access'})
    return false
  })

  $('#vklogin').click(function(){
    VK.Auth.login(vk_auth)
    return false
  })

  // $('.add .form').liveValidation({
  //   validIco: '/images/jquery.liveValidation-valid.png', 
  //   invalidIco: '/images/jquery.liveValidation-invalid.png', 
  //   required: ['rus', 'content'],
  //   fields: {rus: /^([А-ЯЁ][а-яё]+(-[А-ЯЁ][а-яё]+)*)(\s[А-ЯЁ][а-яё]+){2,}$/}
  // })

  var close_and_reload = function(callback){
    $('.form').hide(.5, function(){
      $('.add').addClass('collapsed')
      $('.add .title').show()
    })

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
    $('.collapsed .form').show('veryslow', function(){
      $('.add').removeClass('collapsed')
      submit_enable()
    })
  })
  $('.add .form #cancel').click(function(){close_and_reload()})

  $('.menu a.dyn').click(function(){
    var query = ($('input#search').val() == $('input#search').attr('rel')) ? '' : $('input#search').val()
    var filter = $(this).attr('href')
    $("#list").maskedload(filter+"/?query="+query)    
    return false
  })
})
}

function facebook_auth(response) {
  if (response.authResponse) {
    var uid = response.authResponse.userID;
    var token = response.authResponse.accessToken;
    $.get("/auth/facebook?token="+token+"&uid="+uid, function(data, status){
      if(status == 'success'){
        $('div.logins .fb').empty().append($('<span>'+data+'</span>'))
        load_feeds()
        $('.form .inputs').removeClass('hidden')
        $('.form .inputs_not_logged').addClass('hidden')
      }
    })
  }
}

function vk_auth(response) {
  if (response.status === 'connected') {
    var uid = response.session.mid
    var sig = response.session.sig
    var sid = response.session.sid
    var name = response.session.user.first_name + ' ' + response.session.user.last_name
    $.get("/auth/vk?sig="+sig+"&sid="+sid+"&uid="+uid+"&name="+name, function(data, status){
      if(status == 'success'){
        $('div.logins .vk').empty().append($('<span>'+data+'</span>'))
        load_feeds()
        $('.form .inputs').removeClass('hidden')
        $('.form .inputs_not_logged').addClass('hidden')
      }
    })
  }
}

function change_quote(timer_id) {
  clearTimeout(timer_id)
  var current = $(".header .quotes span.active")
  current.hide(.5, function() {
    current.removeClass('active')
    var quotes = $(".header .quotes > span")
    var index = Math.floor(Math.random()*quotes.length)
    if(index == current.data('index')) index = index + 1
    if(index >= quotes.length) index = 0
    var next = quotes.eq(index)
    next.addClass('active').data('index', index).fadeIn("slow")
    var new_timer_id = setInterval(function(){change_quote(new_timer_id)}, 6000)
  })
}

function load_feeds() {
  $(".recommendations").maskedload("/rating/recommendations")
  $(".friends").maskedload("/rating/friends")
  $(".my").maskedload("/rating/my")
}
