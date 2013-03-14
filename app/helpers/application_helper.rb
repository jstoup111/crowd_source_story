module ApplicationHelper

  def full_title(page_title = '', override = false)
    base_title = override.to_s == "true" ? "" : "Open Source Story"
    if page_title.empty?
      base_title.html_safe
    else
      if base_title.empty?
        "#{page_title}".html_safe
      else
        "#{base_title} - #{page_title}".html_safe
      end
    end
  end
end
