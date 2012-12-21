$ ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  $('body').on('touchstart.dropdown', '.dropdown-menu', (e) ->
    e.stopPropagation()
  )
  $('a.dropdown-toggle').dropdown()
