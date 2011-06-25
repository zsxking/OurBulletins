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

end
