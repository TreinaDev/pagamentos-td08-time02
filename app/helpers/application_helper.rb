module ApplicationHelper
  def format_percentage(int)
    "#{int}%"
  end

  def format_rubi_value(value)
    ['RU', number_with_precision(value / 100.0, precision: 2)].join(' ')
  end
end
