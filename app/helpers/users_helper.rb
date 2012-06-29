# -*- coding: utf-8 -*-

module UsersHelper
  def stringify_grade(grade)
    I18n.t("user.grades.grade_#{grade}")
  end
end
