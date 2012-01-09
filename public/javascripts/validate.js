(function($){
  $.fn.validate=function(a) {
    this.each(function() {
      $(this).bind('keypress keydown change input paste', function(){
        var me = $(this)
        var valid = me.val().match(a)
        me.addClass(valid ? 'valid' : 'invalid').removeClass(valid ? 'invalid' : 'valid')
      }).blur(function(){
        $(this).removeClass('valid')
      })
    })
  }
})(jQuery)
