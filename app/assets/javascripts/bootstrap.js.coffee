$ ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  $('body').on('touchstart.dropdown', '.dropdown-menu', (e) ->
    e.stopPropagation()
  )
  $('body').on('click', 'a.dropdown-toggle', (e) ->
    $(this).dropdown()
    false
  )
