$.template = (name) ->
  _.template $("##{name}").html()

class App.Alert
  
  @displayValidationErrors: (messages) ->
    for key, message of messages
      @addValidationError key, message
    @show "Warning!", "Fix validation errors and try again", "alert-warning"

  @addValidationError: (field, message) ->
    controlGroup = $("input[name=#{field}]").parents('.control-group')
    controlGroup.addClass "error"
    $(".help-inline", controlGroup).html message
    $(".help-block", controlGroup).html message

  @removeValidationError: (field) ->
    controlGroup = $("input[name=#{field}]").parents('.control-group')
    controlGroup.removeClass "error"
    $(".help-inline", controlGroup).html ""
    $(".help-block", controlGroup).html ""

  @show: (warning, appendTo = $('body')) ->
    alert = $('<div>', class:'alert').append($('<button>', class:'close', 'data-dismiss':'alert', type:'button', html:'&times;'), warning)
    console.log alert, warning
    alert.appendTo(appendTo)

  @hide: ->
    $(".help-inline").html ''
    $(".help-block").html ''
    $('.error').removeClass 'error'
    $(".alert").hide()

App.Router = Parse.Router.extend
  routes:
    "": 'home'
    login: 'login'
    logout: 'logout'
    signup: 'signup'

  initialize: ->
    @navbar = new App.NavBar
    @sidebar = new App.SideBar
    @navbar.render()
    @sidebar.render()
    Parse.history.on 'route', =>
      @sidebar.update()

  requireLogin: (next) ->
    if not Parse.User.current()
      route = Parse.history.fragment
      if route not in ['login', 'signup']
        return app.navigate 'login', yes
    else
      @_switchToLogin no
      @navbar.render()
      @content = next()
      stats = new App.StatsView()
      @content.stats = stats
      $('#pad-wrapper').empty().append @content.el
      @content.render()
      $('#main-stats').html(stats.el).show()
  
  _switchToLogin: (toLogin) ->
    $('html')[if toLogin then 'addClass' else 'removeClass'] 'login-bg'
    $('#sidebar-nav, .navbar, #pad-wrapper')[if toLogin then 'hide' else 'show']()
    $('.header')[if toLogin then 'show' else 'hide']()
    $('.login-wrapper').remove()
    @sidebar.update()
  
  login: ->
    @_switchToLogin yes
    new App.LoginView

  logout: ->
    Parse.User.logOut()
    @navbar.render()
    app.navigate '', yes
  
  signup: ->
    @_switchToLogin yes
    new App.SignupView
  
  home: ->
    @requireLogin ->
      Parse.User.current().fetch()
      new App.HomeView
