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
  
  def self.entries
    @entries
  end
  
  def self.name
    @name
  end
  
  def self.state
    @state
  end
  
  def self.title
    @title
  end
  
  def self.secure_attribution_image
    @secure_attribution_image
  end
  
  def self.attribution_image
    @attribution_image
  end
  
  def self.attribution_image_link
    @attribution_image_link
  end
  
  def self.desc
    @desc
  end
  
  def self.disclaimer
    @disclaimer
  end
  
  def self.id
    @id
  end
  
  def self.footnote
    @footnote
  end
  
  def self.menu_sections
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
