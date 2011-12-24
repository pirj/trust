(function($){
  $.fn.hidingprompt=function(callback) {
    this.each(function(){
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
        if(callback !== undefined){
          if($(this).val() != prompt)
            callback($(this).val())
          else
            callback(null)
        }
      })
    })
  }
})(jQuery)
