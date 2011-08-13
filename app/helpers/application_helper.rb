module ApplicationHelper

  #Return a title on a per-page basis.
  def title
    base_title = "OurBulletins"
    if @title.nil?
      base_title
    else
      "#{@title} | #{base_title}"
    end
  end

  def app_name
    "Our Bulletins"
  end

  def logo
    #image_tag("logo.png", :alt => app_name, :class => "round")
    content_tag :div, app_name, :class => 'headAppName'
  end

  def default_locals(defaults)
    @default_locals = defaults
  end

  def method_missing(sym, *args, &block)
    if @default_locals && @default_locals.has_key?(sym)
      @default_locals[sym]
    else
      super
    end
  end

  # Link with class 'super button', with content inside span
  def super_button_link_to *args
    name         = args[0]
    options      = args[1] || {}
    html_options = args[2]
    html_options[:class] ||= ''
    html_options[:class] += ' super button'
    link_to options, html_options do
      "<span>#{name}</span>".html_safe
    end
  end

  def highlight_class
    case
      when params[:controller] == 'books'
        'books'
      when  params[:controller] == 'listings' && params[:action] !=  'new'
        'others'
      when params[:controller] == 'listings' && params[:action] ==  'new'
        'post'
      when params[:controller] == 'devise/registrations'
        'profile'
      when params[:controller] == 'devise/sessions'
        'signin'
    end
  end
end
