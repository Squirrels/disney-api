require 'nokogiri' 
require 'open-uri'
require 'pry'


namespace :disney do
  desc "Connects to the Disney Wikia and updates the data"
  task update_data: :environment do
  	## Characters
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
				  	#Character.find_or_create_by name: name, url: url
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

end
