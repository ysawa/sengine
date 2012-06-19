$.extend
  set_locale_en: ->
    dictionary =
      'fu': '歩'
      'keima': '桂'
      'hisha': '飛'
      'kyosha': '香'
      'kin': '金'
      'gin': '銀'
      'gyoku': '玉'
      'kaku': '角'
      'tokin': 'と'
      'narikei': '成桂'
      'narikyo': '成香'
      'narigin': '成銀'
      'uma': '馬'
      'ryu': '竜'
      'Are you sure?': 'Are you sure?'
      'reverse?': 'Reverse?'
      'invite_facebook_title': "Let's invite your facebook friends"
      'invite_facebook_message': "Let's play shogi!"
    $.i18n.setDictionary(dictionary)

    $.extend($.validator.messages,
      required: "The field is necessary."
      remote: "このフィールドを修正してください。"
      email: "有効なEメールアドレスを入力してください。"
      url: "有効なURLを入力してください。"
      date: "有効な日付を入力してください。"
      dateISO: "有効な日付（ISO）を入力してください。"
      number: "有効な数字を入力してください。"
      digits: "数字のみを入力してください。"
      creditcard: "有効なクレジットカード番号を入力してください。"
      equalTo: "同じ値をもう一度入力してください。"
      accept: "有効な拡張子を含む値を入力してください。"
      maxlength: $.format("{0} 文字以内で入力してください。")
      minlength: $.format("{0} 文字以上で入力してください。")
      rangelength: $.format("{0} 文字から {1} 文字までの値を入力してください。")
      range: $.format("{0} から {1} までの値を入力してください。")
      max: $.format("{0} 以下の値を入力してください。")
      min: $.format("{1} 以上の値を入力してください。")
    )
