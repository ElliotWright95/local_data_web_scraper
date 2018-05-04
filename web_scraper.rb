# Require Dependicies
require 'curb'
require 'nokogiri'
require 'json'
require 'pry'
require_relative './scraper_helpers.rb'

include ScraperHelpers

p 'Web Scrapper Start'
#1####################################################################################
# Set Curb to fetch Web Page
@curb = Curl::Easy.new
# Set Web Page URL
@curb.url = "http://amateur-boxing.strefa.pl/Nationalchamps/GreatBritain2017_2.html"
# Fetch Web Page
@curb.perform

# Turn HTML into a Nokogiri object
@web_page = Nokogiri::HTML(@curb.body_str)

p 'Fetched Data'

# Set global variables here
@sport = 'Boxing'
@sportID = ScraperHelpers::sport_name_to_id[@sport]
@competition = 'British Championships'
@season = '2017'
@country = 'England'
@location = 'Sheffield'
@dateEnd = '2017-12-07'
@editionID = ScraperHelpers::build_local_edition_id(@sportID, @competition, @dateEnd)

p 'Page Parsed & Globals Set'

#2#####################################################################################
# Map Competition Edition List Object
comp_edition_list_object = {
  n_CompetitionID: 'Local',
  n_EditionID: @editionID,
  n_SportID: @sportID,
  c_Sport: @sport,
  c_Competition: @competition,
  c_Edition: @season,
  c_Country: @country,
  c_Location: @location,
  d_DateEnd: @dateEnd,
  n_DateLocalSort: '',
  c_Class: '',
  c_GenderShort: ''
}

# Create or merge with original local_competition_editions.json file
original_array = File.read('edition_list_object/local_competition_editions.json')
if original_array == ""
  new_array = [comp_edition_list_object]
else
  new_array = JSON.parse(original_array)
  unless new_array.any? { |obj| obj['n_EditionID'] == comp_edition_list_object[:n_EditionID] }
    new_array << comp_edition_list_object
  end
end

# Write the new local_competition_editions.json file
File.open('edition_list_object/local_competition_editions.json','w') do |f|
  f.write(new_array.to_json)
end

p 'Competition Edition List Object Created'

#3#####################################################################################
comp_info_data = []
gender_counter = 1

# Map Competition Info Data & Competition Results Data
@web_page.css('table').map do |tbody|
  tbody.css('tr').each do |tr|
    comp_results_data = []
    event = tr.css('td')[0].text.gsub(/\s+/, ' ')
    gender_short = ScraperHelpers::gender_short_by_order(gender_counter)
    gender = ScraperHelpers::gender_by_order(gender_counter)
    phase_id = ScraperHelpers::build_local_phase_id(@sportID, @competition, @dateEnd, event, gender_short)

    comp_info_data << {
      "n_PhaseID": phase_id,
      "c_Event": event,
      "c_Gender": gender,
      "c_GenderShort": gender_short,
      "d_DateEnd": @dateEnd,
      "c_Rank1NOC": tr.css('td')[2].text.gsub(/\s+/, ' '),
      "c_Rank2NOC": tr.css('td')[4].text.gsub(/\s+/, ' ')
    }

    comp_results_data << {
      "n_Rank":1,
      "n_RankSort":1,
      "c_Rank":"1",
      "c_Participant": tr.css('td')[1].text.gsub(/\s+/, ' '),
      "c_NOC": tr.css('td')[2].text,
      "c_NOCShort": tr.css('td')[2].text.gsub(/\s+/, ' '),
      "c_Competition": @competition,
      "c_Location": @location,
      "c_Country": @country,
      "n_DateLocalSort": @dateEnd.delete('-').to_i,
      # "n_PersonID": "",
      "n_Season": @season.to_i,
      "c_Season": @season,
      "c_Event": event,
      "c_Gender": gender,
      "c_GenderShort": gender_short,
      "n_CompetitionID": "Local",
      "n_PhaseID": phase_id,
      "c_Class": ""
    }

    comp_results_data << {
      "n_Rank":2,
      "n_RankSort":2,
      "c_Rank":"2",
      "c_Participant": tr.css('td')[3].text.gsub(/\s+/, ' '),
      "c_NOC": tr.css('td')[4].text,
      "c_NOCShort": tr.css('td')[4].text.gsub(/\s+/, ' '),
      "c_Competition": @competition,
      "c_Location": @location,
      "c_Country": @country,
      "n_DateLocalSort": @dateEnd.delete('-').to_i,
      # "n_PersonID": "",
      "n_Season": @season.to_i,
      "c_Season": @season,
      "c_Event": event,
      "c_Gender": gender,
      "c_GenderShort": gender_short,
      "n_CompetitionID": "Local",
      "n_PhaseID": phase_id,
      "c_Class": ""
    }

    File.open("comp_results_data/#{phase_id}.json","w") do |f|
      f.write(comp_results_data.to_json)
    end
  end
  gender_counter += 1
end

File.open("comp_info_data/#{@editionID}.json","w") do |f|
  f.write(comp_info_data.to_json)
end

p 'Done'

# Start Pry to inpect the parsed page - Remember to quit pry to continue
# Pry.start(binding)
