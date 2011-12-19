$(function() {
  $('img.rate').bind('click', function() {
    var el = $(this)
    var ref = el.attr('ref')
    $.post(ref, function(data) {
      el.siblings('span.rating').text(data)
      if(el.hasClass('plus')) el.removeClass('weak').siblings('.minus').addClass('weak')
      else if(el.hasClass('minus')) el.removeClass('weak').siblings('.plus').addClass('weak')
    })
  })

  setTimeout("change_quote()", 10000)

  $(".recommendations").load("/rating/recommendations")
  $(".friends").load("/rating/friends")
  $(".my").load("/rating/my")
  $(".feed").load("/rating/feed")
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
