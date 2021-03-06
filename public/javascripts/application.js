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
  if($('.not_logged_in').length == 0)
    load_feeds()

  $('.login').click(function(){
    FB.login(function(){}, {scope : 'user_relationships,publish_stream,offline_access'})
    VK.Auth.login(vk_auth, 1027)
    return false
  })

  var close_and_reload = function(callback){
    $('.form').hide('slow', function(){
      $('.add').addClass('collapsed')
      $('.add .title').show('fast')
    })

    var query = ($('input#search').val() == $('input#search').attr('rel')) ? '' : $('input#search').val()
    $("#list").maskedload("/?query="+encodeURI(query), callback)
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
    return false;
  })

  $('input#search').hidingprompt(function(val){
    $("#list").maskedload("/?query="+encodeURI(val))
  })

  $('input#name').validate(/^([А-ЯЁ][а-яё]+(-[А-ЯЁ][а-яё]+)*)(\s[А-ЯЁ][а-яё]+){2,}$/)
  $('textarea#bio').validate(/^(.){1,255}$/)

  $('input#name').hidingprompt(function(val){
    $("#list").maskedload("/?query="+encodeURI(val))
  })
  $('textarea#bio, input#photo').hidingprompt()

  $('.collapsed').click(function(){
    $('.add .title').hide()
    $('.collapsed .form').show('veryslow', function(){
      $('.add').removeClass('collapsed')
    })
  })
  $('.add .form #cancel').click(function(){close_and_reload(); return false})

  $('.menu a.dyn').click(function(){
    var query = ($('input#search').val() == $('input#search').attr('rel')) ? '' : $('input#search').val()
    var filter = $(this).attr('href')
    $("#list").maskedload(filter+"/?query="+encodeURI(query))    
    return false
  })
})
}

function facebook_auth(response) {
  if (response.authResponse) {
    var uid = response.authResponse.userID;
    var token = response.authResponse.accessToken;
    $.get("/auth/facebook?token="+token+"&uid="+uid, function(data, status){
      $('.loggingin').removeClass('loggingfb')
      if(status == 'success'){
        $('#logins .fb').append($('<span>'+data+'</span>'))
        $('body').addClass('loggedinfb')
        load_feeds()
      }
    })
  } else
    $('.loggingin').removeClass('loggingfb')
}

function vk_auth(response) {
  if (response.status === 'connected') {
    var params = JSON.stringify(response.session)
    $.get("/auth/vk?params="+params, function(data, status){
      $('.loggingin').removeClass('loggingvk')
      if(status == 'success'){
        $('#logins .vk').append($('<span>'+data+'</span>'))
        $('body').addClass('loggedinvk')
        load_feeds()
      }
    })
  } else
    $('.loggingin').removeClass('loggingvk')
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
