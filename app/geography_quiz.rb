require_relative "common"

# Based on https://en.wikipedia.org/wiki/List_of_national_capitals_in_alphabetical_order
# Some not really countries could be removed from this list
Capitals = [
  ["Abu Dhabi", "United Arab Emirates"],
  ["Abuja", "Nigeria"],
  ["Accra", "Ghana"],
  ["Adamstown", "Pitcairn"],
  ["Addis Ababa", "Ethiopia"],
  ["Algiers", "Algeria"],
  ["Amman", "Jordan"],
  ["Amsterdam", "Netherlands"],
  ["Andorra la Vella", "Andorra"],
  ["Ankara", "Turkey"],
  ["Antananarivo", "Madagascar"],
  ["Apia", "Samoa"],
  ["Ashgabat", "Turkmenistan"],
  ["Asmara", "Eritrea"],
  ["Astana", "Kazakhstan"],
  ["Asunción", "Paraguay"],
  ["Athens", "Greece"],
  ["Baghdad", "Iraq"],
  ["Baku", "Azerbaijan"],
  ["Bamako", "Mali"],
  ["Bandar Seri Begawan", "Brunei"],
  ["Bangkok", "Thailand"],
  ["Bangui", "Central African Republic"],
  ["Banjul", "Gambia"],
  ["Basseterre", "Saint Kitts and Nevis"],
  ["Beijing", "People's Republic of China"],
  ["Beirut", "Lebanon"],
  ["Belgrade", "Serbia"],
  ["Belmopan", "Belize"],
  ["Berlin", "Germany"],
  ["Bern", "Switzerland"],
  ["Bishkek", "Kyrgyzstan"],
  ["Bissau", "Guinea-Bissau"],
  ["Bogotá", "Colombia"],
  ["Brasília", "Brazil"],
  ["Bratislava", "Slovakia"],
  ["Brazzaville", "Republic of the Congo"],
  ["Bridgetown", "Barbados"],
  ["Brussels", "Belgium"],
  ["Bucharest", "Romania"],
  ["Budapest", "Hungary"],
  ["Buenos Aires", "Argentina"],
  ["Bujumbura", "Burundi"],
  ["Cairo", "Egypt"],
  ["Canberra", "Australia"],
  ["Caracas", "Venezuela"],
  ["Castries", "Saint Lucia"],
  ["Chișinău", "Moldova"],
  ["Conakry", "Guinea"],
  ["Copenhagen", "Denmark"],
  ["Dakar", "Senegal"],
  ["Damascus", "Syria"],
  ["Dhaka", "Bangladesh"],
  ["Dili", "East Timor"],
  ["Djibouti", "Djibouti"],
  ["Dodoma", "Tanzania"],
  ["Doha", "Qatar"],
  ["Dublin", "Ireland"],
  ["Dushanbe", "Tajikistan"],
  ["Freetown", "Sierra Leone"],
  ["Funafuti", "Tuvalu"],
  ["Gaborone", "Botswana"],
  ["Georgetown", "Guyana"],
  ["Guatemala City", "Guatemala"],
  ["Hanoi", "Vietnam"],
  ["Harare", "Zimbabwe"],
  ["Havana", "Cuba"],
  ["Helsinki", "Finland"],
  ["Honiara", "Solomon Islands"],
  ["Islamabad", "Pakistan"],
  ["Jakarta", "Indonesia"],
  ["Tel Aviv", "Israel"],
  ["Juba", "South Sudan"],
  ["Kabul", "Afghanistan"],
  ["Kampala", "Uganda"],
  ["Kathmandu", "Nepal"],
  ["Khartoum", "Sudan"],
  ["Kiev", "Ukraine"],
  ["Kigali", "Rwanda"],
  ["Kingston", "Jamaica"],
  ["Kingstown", "Saint Vincent and the Grenadines"],
  ["Kinshasa", "Democratic Republic of the Congo"],
  ["Kuala Lumpur", "Malaysia"],
  ["Kuwait City", "Kuwait"],
  ["Libreville", "Gabon"],
  ["Lilongwe", "Malawi"],
  ["Lima", "Peru"],
  ["Lisbon", "Portugal"],
  ["Ljubljana", "Slovenia"],
  ["Lomé", "Togo"],
  ["London", "United Kingdom"],
  ["Luanda", "Angola"],
  ["Lusaka", "Zambia"],
  ["Luxembourg", "Luxembourg"],
  ["Madrid", "Spain"],
  ["Majuro", "Marshall Islands"],
  ["Malabo", "Equatorial Guinea"],
  ["Malé", "Maldives"],
  ["Managua", "Nicaragua"],
  ["Manama", "Bahrain"],
  ["Manila", "Philippines"],
  ["Maputo", "Mozambique"],
  ["Maseru", "Lesotho"],
  ["Lobamba", "Swaziland"],
  ["Mexico City", "Mexico"],
  ["Minsk", "Belarus"],
  ["Mogadishu", "Somalia"],
  ["Monaco", "Monaco"],
  ["Monrovia", "Liberia"],
  ["Montevideo", "Uruguay"],
  ["Moroni", "Comoros"],
  ["Moscow", "Russia"],
  ["Muscat", "Oman"],
  ["Nairobi", "Kenya"],
  ["Nassau", "Bahamas"],
  ["Naypyidaw", "Myanmar"],
  ["N'Djamena", "Chad"],
  ["New Delhi", "India"],
  ["Ngerulmud", "Palau"],
  ["Niamey", "Niger"],
  ["Nicosia", "Cyprus"],
  ["Nouakchott", "Mauritania"],
  ["Nouméa", "New Caledonia"],
  ["Nukuʻalofa", "Tonga"],
  ["Oslo", "Norway"],
  ["Ottawa", "Canada"],
  ["Ouagadougou", "Burkina Faso"],
  ["Palikir", "Federated States of Micronesia"],
  ["Panama City", "Panama"],
  ["Paramaribo", "Suriname"],
  ["Paris", "France"],
  ["Phnom Penh", "Cambodia"],
  ["Podgorica", "Montenegro"],
  ["Port Louis", "Mauritius"],
  ["Port Moresby", "Papua New Guinea"],
  ["Port Vila", "Vanuatu"],
  ["Port-au-Prince", "Haiti"],
  ["Port of Spain", "Trinidad and Tobago"],
  ["Porto-Novo", "Benin"],
  ["Prague", "Czech Republic"],
  ["Praia", "Cabo Verde"],
  ["Cape Town", "South Africa"],
  ["Pyongyang", "North Korea"],
  ["Quito", "Ecuador"],
  ["Rabat", "Morocco"],
  ["Reykjavík", "Iceland"],
  ["Riga", "Latvia"],
  ["Riyadh", "Saudi Arabia"],
  ["Road Town", "British Virgin Islands"],
  ["Rome", "Italy"],
  ["Roseau", "Dominica"],
  ["San José", "Costa Rica"],
  ["San Marino", "San Marino"],
  ["San Salvador", "El Salvador"],
  ["Sana'a", "Yemen"],
  ["Santiago", "Chile"],
  ["Santo Domingo", "Dominican Republic"],
  ["São Tomé", "São Tomé and Príncipe"],
  ["Sarajevo", "Bosnia and Herzegovina"],
  ["Seoul", "South Korea"],
  ["Singapore", "Singapore"],
  ["Skopje", "Republic of Macedonia"],
  ["Sofia", "Bulgaria"],
  ["Sri Jayawardenepura Kotte", "Sri Lanka"],
  ["St. George's", "Grenada"],
  ["St. John's", "Antigua and Barbuda"],
  ["Stockholm", "Sweden"],
  ["Sucre", "Bolivia"],
  ["Suva", "Fiji"],
  ["Taipei", "Republic of China"],
  ["Tallinn", "Estonia"],
  ["Tarawa", "Kiribati"],
  ["Tashkent", "Uzbekistan"],
  ["Tbilisi", "Georgia"],
  ["Tegucigalpa", "Honduras"],
  ["Tehran", "Iran"],
  ["Thimphu", "Bhutan"],
  ["Tirana", "Albania"],
  ["Tokyo", "Japan"],
  ["Tripoli", "Libya"],
  ["Tskhinvali", "South Ossetia"],
  ["Tunis", "Tunisia"],
  ["Ulaanbaatar", "Mongolia"],
  ["Vaduz", "Liechtenstein"],
  ["Valletta", "Malta"],
  ["Vatican City", "Vatican City"],
  ["Victoria", "Seychelles"],
  ["Vienna", "Austria"],
  ["Vientiane", "Laos"],
  ["Vilnius", "Lithuania"],
  ["Warsaw", "Poland"],
  ["Washington, D.C.", "United States"],
  ["Wellington", "New Zealand"],
  ["Windhoek", "Namibia"],
  ["Yamoussoukro", "Côte d'Ivoire"],
  ["Yaoundé", "Cameroon"],
  ["Yaren", "Nauru"],
  ["Yerevan", "Armenia"],
  ["Zagreb", "Croatia"],
]

class Game
  def initialize
    $size_x = $window.view.width
    $size_y = $window.view.height
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

class Score
  attr_reader :value
  def initialize
    @label = $game.add.text(0.5*$size_x, 0.1*$size_y, "", { fontSize: "80px", fill: "#000", align: "center" })
    @label.anchor.set(0.5)
    self.value = 0
  end

  def value=(v)
    @value = v
    @label.text = "Score: #{@value}"
  end
end

class Question
  def initialize
    @label = $game.add.text(0.5*$size_x, 0.3*$size_y, "", { fontSize: "60px", fill: "#000", align: "center" })
    @label.anchor.set(0.5)
  end

  def text=(v)
    @label.text = v
  end
end

class Answer
  attr_accessor :correct
  def initialize(x,y,state)
    @label = $game.add.text(x, y, "", { fontSize: "60px", fill: "#000", align: "center", backgroundColor: "#8AE" })
    @label.anchor.set(0.5)
    @correct = false
    @state = state

    @label.inputEnabled = true
    @label.events.on(:down) do
      @state.answered(@correct)
    end
  end

  def text=(v)
    @label.text = v
  end
end

class MainState < Phaser::State
  def create
    $game.stage.background_color = "ABF"
    @score = Score.new
    @question = Question.new
    @answers = [
      Answer.new(0.25*$size_x, 0.5*$size_y, self),
      Answer.new(0.75*$size_x, 0.5*$size_y, self),
      Answer.new(0.25*$size_x, 0.7*$size_y, self),
      Answer.new(0.75*$size_x, 0.7*$size_y, self),
    ]
    new_question
  end

  def answered(correct)
    if correct
      @score.value += 1
    else
      @score.value -= 1
    end
    new_question
  end

  def new_question
    countries = Capitals.sample(4)
    @question.text = "Capital of #{countries[0][1]}"
    @answers.shuffle.each_with_index do |answer, i|
      answer.text = countries[i][0]
      answer.correct = (i == 0)
    end
  end
end
