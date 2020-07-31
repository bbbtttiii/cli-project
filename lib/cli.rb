class CLI 

    def run
        input = nil
        puts ""
        puts "     _  _ _____ _   _ ____      ".colorize(:light_blue)
        puts "    | || |_   _| \\ | |  _ \\   ".colorize(:light_blue)
        puts "    | || |_| | |  \\| | |_| |   ".colorize(:light_blue)
        puts "    |__   _| | | |\\  |  _ <    ".colorize(:light_blue)
        puts "       |_| |_| |_| \\_|_| \\_\\ ".colorize(:light_blue)
        puts ""
        puts "4TNR: A Colorado Fourteeners Guide".colorize(:light_yellow)
        puts ""
        puts "Loading, please wait..."
        scrape
        add_bios
        menu
    end

    def menu
        puts ""
        puts "-To see all mountains, enter 'list'".colorize(:green)
        puts "-To exit, enter 'quit'".colorize(:green)

        input = gets.strip
        if input.downcase == "list"
            print_1_to_19
        elsif input.downcase == "quit"
            quit
        elsif input.to_i > 0 && input.to_i <= 53
            mountain = Mountain.find(input.to_i)
            mountain_page(mountain)
        else
            not_found
            menu
        end
    end

    def print_1_to_19
        puts ""
        Mountain.all.each do |mountain|
            if mountain.rank.to_i >= 1 && mountain.rank.to_i <= 19
                puts "##{mountain.rank.to_i}) #{mountain.name}"
            end 
        end

        puts "..."
        puts ""
        puts "To see more, enter 'next'".colorize(:green)
        puts ""
        puts "Enter a number:".colorize(:green)
        puts ""

        input = gets.strip
        if input.downcase == "quit"
            quit
        elsif input.downcase == "next"
            print_20_to_39
        elsif input.downcase == "list"
            print_1_to_19
        elsif input.to_i >= 1 && input.to_i <= 53
            mountain = Mountain.find(input.to_i)
            mountain_page(mountain)
        else
            not_found
            menu
        end
    end

    def print_20_to_39
        puts ""
        Mountain.all.each do |mountain|
            if mountain.rank.to_i >= 20 && mountain.rank.to_i <= 39
                puts "##{mountain.rank.to_i}) #{mountain.name}"
            end 
        end
    
        puts "..."
        puts ""
        puts "To see more, enter 'next'".colorize(:green)
        puts "To go back, enter 'back'".colorize(:green)
        puts ""
        puts "Enter a number:".colorize(:green)
        puts ""

        input = gets.strip
        if input.downcase == "quit"
            quit
        elsif input.downcase == "next"
            print_40_to_53
        elsif input.downcase == "back"
            print_1_to_19
        elsif input.to_i >= 1 && input.to_i <= 53
            mountain = Mountain.find(input.to_i)
            mountain_page(mountain)
        else
            not_found
            menu
        end
    end
    
    def print_40_to_53
        puts ""
        Mountain.all.each do |mountain|
            if mountain.rank.to_i > 39
                puts "##{mountain.rank.to_i}) #{mountain.name}"
            end 
        end
    
        puts ""
        puts "To go back, enter 'back'".colorize(:green)
        puts ""
        puts "Enter a number:".colorize(:green)
        puts ""
        
        input = gets.strip
        if input.downcase == "quit"
            quit
        elsif input.downcase == "back"
            print_20_to_39
        elsif input.downcase == "next"
            puts "End of list!"
            menu
        elsif input.to_i >= 1 && input.to_i <= 53
            mountain = Mountain.find(input.to_i)
            mountain_page(mountain)
        else
            not_found
            menu
        end
    end

    def mountain_page(mountain)
        # add_weather
        puts ""
        puts "##{mountain.rank.to_i})".colorize(:light_blue) + " #{mountain.name}".colorize(:light_blue)
        puts ""
        puts "      Elevation:".colorize(:magenta) + " #{mountain.elevation}"
        puts "      Prominence:".colorize(:magenta) + " #{mountain.prominence}"
        puts "      Range:".colorize(:magenta) + " #{mountain.range}"
        puts "      Location:".colorize(:magenta) + " #{mountain.location}"
        puts ""
        puts "      -------------------------"
        # puts "Current weather:".colorize(:light_yellow)
        # puts ""
        # puts "     Conditions:".colorize(:magenta) + " #{mountain.description}"
        # puts "     Temperature:".colorize(:magenta) + " #{mountain.temp}"
        # puts "     Wind:".colorize(:magenta) + " #{mountain.speed}"
        puts ""
        puts "      About #{mountain.name}".colorize(:light_yellow)
        puts ""
        puts "      #{mountain.bio}".gsub(/\[.*?\]/, "")
        puts ""
        puts "-To go back to the list, enter 'list'".colorize(:green)
        puts "-To exit, enter 'quit'".colorize(:green)

        input = gets.strip
        if input.downcase == "list"
            if (mountain.rank.to_i >= 1 && mountain.rank.to_i <= 19)
                print_1_to_19
            elsif (mountain.rank.to_i >= 20 && mountain.rank.to_i <= 39)
                print_20_to_39
            elsif (mountain.rank.to_i >= 40 && mountain.rank.to_i <=53)
                print_40_to_53
            end
        elsif input.downcase == "quit"
            quit
        else
            invalid_input
            menu
        end
    end

    def scrape
        info = Scraper.get_page
        Mountain.create_from_scrape(info)
    end

    def add_bios
        Mountain.all.each do |mountain|
          attributes = Scraper.get_bio(mountain.mtn_url)
          mountain.add_mtn_bio(attributes)
        end
    end
    
    # def add_weather
    #     Mountain.all.each do |mountain|
    #         weather = Scraper.get_weather(mountain)
    #         mountain.wx_storage(weather)
    #     end
    # end

    def not_found
        puts "Sorry, I couldn't find that."
    end

    def invalid_input
        puts "Sorry, I didn't understand that."
    end

    def quit
       puts "Goodbye!".colorize(:red)
    end

end