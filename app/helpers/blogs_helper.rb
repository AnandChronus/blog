module BlogsHelper
  def get_indent_percentage(lvl)
    i6 = 20 #20
    i10 = i6 + 15 #35
    i20 = i10 + 20 #55
    i35 = i20 + 15 #70
    case lvl
    when 0..5
      return (lvl * 4)
    when 6..10
      return (i6 + ((lvl -5) * 3))
    when 11..20
      return (i10 + ((lvl - 10) * 2))
    when 21..35
      return (i20 + ((lvl - 20) * 1))
    else
      return i35
    end
  end
end
