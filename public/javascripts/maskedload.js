(function($){
  $.fn.maskedload=function(url) {
    this.each(function() {
      $(this).load(url, function() {
        $(this).unmask()
      }).mask("Подождите, идёт загрузка ...")
    })
  }
})(jQuery)
