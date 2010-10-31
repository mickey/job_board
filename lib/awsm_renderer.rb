class AwsmRenderer < WillPaginate::ViewHelpers::LinkRenderer

  def to_html
    html = pagination.map do |item|
      item.is_a?(Fixnum) ?
        page_number(item) :
        send(item)
    end.join(@options[:separator])

    @options[:container] ? html_container(html) : html
  end

  # def to_html
  #   links = @options[:page_links] ? windowed_links : []
  # 
  #   links.unshift(page_link_or_span(@collection.previous_page, 'previous', @options[:previous_label]))
  #   links.push(page_link_or_span(@collection.next_page, 'next', @options[:next_label]))
  # 
  #   html = links.join(@options[:separator]).html_safe
  #   @options[:container] ? @template.content_tag(:div, content_tag(:ul, html), :class => 'pagination') : html
  # end

# protected
# 
#   def page_link_or_span(page, span_class, text = nil)
#     text ||= page.to_s
#     if page && page != current_page
#       page_link(page, text, :class => span_class)
#     else
#       page_span(page, text, :class => span_class)
#     end
#   end
# 
#   def page_link(page, text, attributes = {})
#     @template.content_tag(:li, @template.link_to(text, url_for(page)), attributes)
#   end
# 
#   def page_span(page, text, attributes = {})
#     @template.content_tag(:li, text, attributes)
#   end

end