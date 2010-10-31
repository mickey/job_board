class AwsmRenderer < WillPaginate::ViewHelpers::LinkRenderer

  protected
  
  def html_container(html)
    tag(:div, tag(:ul, html), container_attributes.merge(:class => "pagination"))
  end
  
  def page_number(page)
    unless page == current_page
      tag(:li, link(page, page, :rel => rel_value(page)))
    else
      tag(:li, page)
    end
  end
  
  def previous_or_next_page(page, text, classname)
    unless page == current_page
      tag(:li, link(text, page), :class => classname)
    else
      tag(:li, text, :class => classname + ' disabled')
    end
  end
  
end