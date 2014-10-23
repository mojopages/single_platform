class SinglePlatform::Menu
  attr_reader :location, :menu_sections

  attr_reader :title, :desc, :footnote, :state, :entries, :id, :name, :disclaimer, :attribution_image,
              :attribution_image_link, :secure_attribution_image, :secure_attribution_image_link

  def initialize(location, data)
    @location = location
    @menu_sections = []
    data.each do |key, value|
      instance_variable_set :"@#{key.underscore}", value
    end
    build_menu
  end
  
  def entries
    @entries
  end
  
  def name
    @name
  end
  
  def state
    @state
  end
  
  def title
    @title
  end
  
  def secure_attribution_image
    @secure_attribution_image
  end
  
  def attribution_image
    @attribution_image
  end
  
  def attribution_image_link
    @attribution_image_link
  end
  
  def desc
    @desc
  end
  
  def disclaimer
    @disclaimer
  end
  
  def id
    @id
  end
  
  def footnote
    @footnote
  end
  
  def menu_sections
    @menu_sections
  end
  
  def self.menus_for_location(location)
    data = SinglePlatform::Request.get("/locations/#{location.id}/menu").body["menus"]
    data.collect { |menu_data| new(location, menu_data) }
  end

  def build_menu
    current_section = nil
    entries.each do |entry|
      if entry["type"] == "section"
        current_section = SinglePlatform::MenuSection.new(self, entry)
        menu_sections << current_section
      else
        current_section.menu_items << SinglePlatform::MenuItem.new(current_section, entry)
      end
    end
  end
end
