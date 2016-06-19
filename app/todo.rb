require "opal"
require "opal-jquery"

class TodoApp
  def initialize
    new_item.on(:keyup) do |ev|
      add_todo if ev.key_code == 13
    end
  end

  def new_item
    Element["#new_item"]
  end

  def add_todo
    # new_item.blur
    txt = new_item.value
    new_item.value = ""
    # escape html
    Element["#todos"] << Element.parse("<li>#{ txt }</li>")
  end
end

TodoApp.new
