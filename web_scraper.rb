# Require Dependicies
require 'curb'
require 'Nokogiri'
require 'JSON'
require 'Pry'
require 'csv'

# Set Curb to fetch Web Page
@curb = Curl::Easy.new
@curb.url = "https://www.iaaf.org/records/toplists/sprints/100-metres/outdoor/men/senior/2017"
@curb.perform
# Set page to HTML
page = @curb.body_str

# Turn HTML into a Nokogiri object
parse_page = Nokogiri::HTML(page)

# Fetch Data
athlete_arr = []

parse_page.css('.outer-container').css('.container').css('#collapse-2017-top-list').css('tbody').css('tr').map do |a|
  athlete = a.text
  athlete_arr << athlete
end

# Start Pry
Pry.start(binding)
