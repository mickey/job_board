require "open-uri"

namespace :scrap do 
  namespace :providers do

    desc "Scrap 37signals feeds"
    task :thirty_seven_signals => :environment do
      
      feeds = [
                {:url => "http://jobs.37signals.com/categories/2/jobs.rss", :category => Category::PROGRAMMING},
                {:url => "http://jobs.37signals.com/categories/1/jobs.rss", :category => Category::DESIGN},
                {:url => "http://jobs.37signals.com/categories/3/jobs.rss", :category => Category::MISC, :tags => ["Business/Exec"]},
                {:url => "http://jobs.37signals.com/categories/4/jobs.rss", :category => Category::MISC},
                {:url => "http://jobs.37signals.com/categories/6/jobs.rss", :category => Category::PROGRAMMING, :tags => ["Iphone"]},
                {:url => "http://jobs.37signals.com/categories/7/jobs.rss", :category => Category::MISC, :tags => ["Customer Service/Support"]}
              ]

      feeds.each do |feed|
        parsed_feed = Feedzirra::Feed.fetch_and_parse(feed[:url])

        parsed_feed.entries.each do |entry|
          title = entry.title
          date = entry.published #Fri Aug 13 21:05:31 UTC 2010
          description = entry.summary.sanitize
          url = entry.url 

          html = open(entry.url)
          doc = Nokogiri::HTML(html)

          category = feed[:category]
          tags = feed[:tags]

          company = ""
          begin
            company = doc.css('span.company').first.content
          rescue
          end

          location = ""
          begin 
            location = doc.css('span.location').first.content.split(":").last.strip
          rescue
          end

          company_image = ""
          begin 
            company_image = doc.css('div.listing-logo > img').first['src']
          rescue
          end

        end
      end
      
    end
    
  end
end