###
# Game logics of Shogi
###

class Shogi

  @roles: ['fu', 'ky', 'ke', 'gi', 'ki', 'ka', 'hi', 'ou', 'to', 'ny', 'nk', 'ng', 'ki', 'um', 'ry', 'ou']
  @normal_roles: ['fu', 'ky', 'ke', 'gi', 'ka', 'hi']
  @reversed_roles: ['to', 'ny', 'nk', 'ng', 'um', 'ry']
  @special_roles: ['ou', 'ki']
  @hand_roles: ['fu', 'ky', 'ke', 'gi', 'ki', 'ka', 'hi', 'ou']
  @KANSUJIS = ['零', '一', '二', '三', '四', '五', '六', '七', '八', '九']
  @SUJIS = ['０', '１', '２', '３', '４', '５', '６', '７', '８', '９']

  @edit_game_form: (form) ->
    form.on "click", "a.face", ->
      user_id = $(this).find("img").attr("user-id")
      $("input#game_opponent_id").val user_id
      sliders = $(this).parents(".slider")
      sliders.find(".slide").removeClass "active"
      $(this).parents(".slide").addClass "active"
      false
    form.on "click", "a.theme", ->
      theme_id = $(this).children("img").attr("theme-id")
      $("input#game_theme").val theme_id
      body_class = $("body").attr("class")
      $("body").attr "class", body_class.replace(/theme_\w+/, "theme_" + theme_id)
      sliders = $(this).parents(".slider")
      sliders.find(".slide").removeClass "active"
      $(this).parents(".slide").addClass "active"
      false
    form.find("a.theme:first").click()
    form.find("#themes_slider").form_slider()
    $.get "/games/opponent_fields", (data) ->
      slider = form.find("#opponents_slider")
      slides = $("<ul>").addClass("slides")
      slides.html data
      slider.append slides
      slider.children(".now_loading").remove()
      size = form.find("#opponents_slider a.face").size()
      if size is 0
        $.invite_facebook()
      else
        form.find("#opponents_slider a.face:first").click()
        form.find("#opponents_slider").form_slider()
    form.on "click", "a.game_order", ->
      game_order = $(this).attr("game-order")
      $("a.game_order").removeClass "active"
      $(this).addClass "active"
      $("input#game_order").val game_order
      if game_order == 'handicap'
        form.find("select#game_handicap").attr('disabled', false)
        form.find("#game_handicap_select").show()
      else
        form.find("select#game_handicap").attr('disabled', true)
        form.find("#game_handicap_select").hide()
      false
    form.find('a.game_order[game-order="random"]').click()

  @insert_place_into_editor = (element) ->
    if event.ctrlKey or event.metaKey
      x = Shogi.Board.get_point_x(element)
      y = Shogi.Board.get_point_y(element)
      place = "#{@SUJIS[x]}#{@KANSUJIS[y]}"
      $('textarea[name="comment[content]"]').insertAtCaret(place)
      return true
    null

  @normalize_piece = (piece) ->
    me = @
    $.each(@reversed_roles, (i, role) ->
      if piece.attr('role') == role
        normal_role = me.normal_roles[i]
        piece.removeClass("role_#{role}")
        piece.attr('role', normal_role)
        piece.addClass("role_#{normal_role}")
        return false
    )

  @select_reverse_or_not = (role, from_point, to_point, player) ->
    in_opponent_first_line = (player == 'sente' and to_point[1] == 1) or (player == 'gote' and to_point[1] == 9)
    in_opponent_second_line = (player == 'sente' and to_point[1] == 2) or (player == 'gote' and to_point[1] == 8)
    in_opponent_area = (player == 'sente' and to_point[1] <= 3) or (player == 'gote' and to_point[1] >= 7)
    out_opponent_area = (player == 'sente' and from_point[1] <= 3) or (player == 'gote' and from_point[1] >= 7)
    not_reversed = $.inArray(role, ['fu', 'gi', 'ke', 'ky', 'ka', 'hi']) >= 0
    if in_opponent_first_line and $.inArray(role, ['fu', 'ke', 'ky']) >= 0
      reverse = true
    else if in_opponent_second_line and role == 'ke'
      reverse = true
    else if not_reversed and (in_opponent_area or out_opponent_area) and confirm($.i18n.t('reverse?'))
      reverse = true

  @reverse_piece = (piece) ->
    me = @
    $.each(@normal_roles, (i, role) ->
      if piece.attr('role') == role
        reversed_role = me.reversed_roles[i]
        piece.attr('role', reversed_role)
        piece.removeClass("role_#{role}")
        piece.addClass("role_#{reversed_role}")
        return false
    )

this.Shogi = Shogi
