# -*- coding: utf-8 -*-

module UsersHelper
  def stringify_grade(grade)
    I18n.t("user.grades.grade_#{grade}")
  end

  def translate_user_locale(locale)
    t("user.locales.#{locale}")
  end
end
