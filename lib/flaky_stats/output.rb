module FlakyStats
  module Output

    def line
      puts "--------------------------------------------------------------------------------"
    end

    def heading(text)
      puts "\n\n"
      line
      puts text
    end
    
  end
end
