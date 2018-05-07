require 'nokogiri' 
require 'open-uri'
require 'pry'


namespace :disney do
  desc "Connects to the Disney Wikia and updates the data"
  task update_data: :environment do
  	## Characters
  	# TODO: Blacklist to ignore the first one

  	base_url = "http://disney.wikia.com"
  	initial_url = "/wiki/Category:Disney_characters"
  	link_text = "next 200"
  	# Info
  	total_characters = 0
  	target_url = base_url + initial_url
  	while !target_url.empty? do
  		page = Nokogiri::HTML(open(target_url))
		# Get the character columns
		character_columns = page.css("#mw-pages tr td")
		# For each column...
		character_columns.each do |column|
			# uls are the letters
			column.css("ul").each do |letter|
				#Inside of those, each li is a character
				letter.css("li").each do |character_container|
					# And for that, inside is an a
				  	# href= wikia page
				  	# title= char name
				  	character_data = character_container.at_css("a")
				  	name = character_data['title']
				  	url = character_data['href']
				  	# Create a character from that
				  	character = Character.find_or_create_by name: name, url: url
				  	total_characters += 1
				end
			end
		end
		# Now check if there's a next page
		next_link = page.xpath("//*[@id='mw-pages']/a[text()='#{link_text}']").first
		target_url = next_link.nil? ? "" : (base_url + next_link["href"].to_s) 
  	end
		p "Completed. #{total_characters} characters"
  end

  task get_character_data: :environment do
  	# Common
  	base_url = "http://disney.wikia.com"
  	# For each character, visit the url
  	characters = Character.where name: "Simba"
  	characters.each do |character|
  		target_url = base_url + character.url
  		page = Nokogiri::HTML(open(target_url))
  		binding.pry
  		# Does it have a sidebox?
  		sidebox = page.css(".portable-infobox")
  		next unless sidebox.empty?
  		# Inside this, check each section element
  		sidebox.css("section").each do |section|
  			# If the title is Background Information
  			if section.css("h2").text == "Background information"
  				# Now, for appearances and extra information, each of the div (with class pi-item)
  				section.css("div").each do |information|
  					# Title of type is h3
  					info_title = information.css("h3").text
  					# div has all elements
  					# Get all the links inside (there are some inside the <i> tag, and some have (upcoming) or extra data in parenthesis )
  					# Elements
  					information.css("div a").each do |info_element|
  						# TODO: what to store?
  						#link = info_element['href']
  						#name = info_element.text
  					end
  				end
  			end
  		end
  	end
  end

  task fix_characters: :environment do
  	# TODO: Fix the characters with () in their names
  end
end
