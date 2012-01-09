yepnope([
  { // JQuery or Zepto
    test: navigator.appName.match(/Explorer/), // IE?
    yep: '/javascripts/jquery.min.js',
    nope: ['/javascripts/zepto.min.js', '/javascripts/zepto.fx_methods.js'],
    complete: function(){
      if(!window.jQuery){
        window.jQuery = window.Zepto
        $.fn.removeData=function() {} // Zepto is missing this
      } 
    }
  },
// Plugins
  ['/javascripts/jquery.loadmask.min.js', '/javascripts/jquery.jgrowl_minimized.js', '/javascripts/maskedload.js', '/javascripts/hidingprompt.js', '/javascripts/validate.js'],
  {
    load: '/javascripts/application.js',
    callback: function(){js_ready()}
  }
])

// Plugin CSS
yepnope(['/stylesheets/jquery.loadmask.css', '/stylesheets/jquery.jgrowl.css'])

//Facebook
yepnope({
  load: ['//connect.facebook.net/ru_RU/all.js'],
  complete: function(){
    FB.init({appId: '273684999345723', xfbml: true, cookie: true, oauth: true})
    FB.Event.subscribe('auth.statusChange', facebook_auth)
  }
})

// VKontakte
yepnope({
  load: ['//vkontakte.ru/js/api/openapi.js'],
  complete: function(){
    if(location.href.match(/localhost/)) VK.init({apiId: '2738008'})
    else VK.init({apiId: '2737052'})
    VK.Auth.getLoginStatus(vk_auth, true)
//    VK.UI.button('vklogin')
  }
})

// TenderApp
yepnope('//grajdanin.tenderapp.com/tender_widget.js')

// Reformal
var reformalOptions = {
  project_id: 52686,
  project_host: "grajdanin.reformal.ru",
  force_new_window: false,
  tab_alignment: "left",
  tab_top: "300",
  tab_bg_color: "#F08200",
  tab_image_url: "http://tab.reformal.ru/0JLQsNGI0Lgg0L7RgtC30YvQstGLINC4INC%252F0YDQtdC00LvQvtC20LXQvdC40Y8=/f0f0f0/a18926533175bec9e0a554c5d211faa0"
}
yepnope('//media.reformal.ru/widgets/v1/reformal.js')
