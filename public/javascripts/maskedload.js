(function($){
  $.fn.maskedload=function(url, callback) {
    this.each(function() {
      $(this).load(url, function() {
        $(this).unmask()
        callback && callback()
      }).mask("Подождите, идёт загрузка ...")
    })
  }
})(jQuery)
