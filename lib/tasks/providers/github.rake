require "open-uri"
#TODO : update
namespace :scrap do 
  namespace :providers do

    desc "Scrap Github Jobs feed"
    task :github => :environment do
      
      github_feed = "http://jobs.github.com/positions.atom"

      parsed_feed = Feedzirra::Feed.fetch_and_parse(github_feed)

      parsed_feed.entries.each do |entry|
  
        date = entry.updated #Tue Aug 10 21:52:39 UTC 2010
        description = entry.content.sanitize
        url = entry.url
  
        html = open(entry.url)
        doc = Nokogiri::HTML(html)
  
        title = doc.css('h1').first.content
  
        schedule, location = doc.css('p.supertitle').first.content.split(" / ")
   
        tmp_company = doc.css('.sidebar h2').first.inner_html
        company = Sanitize.clean(tmp_company, :remove_contents => true).strip
  
        company_link = doc.css('div .logo > a').first['href']
  
        company_image_url = ""
        begin
          company_image_url = doc.css('div .logo > a > img').first['src'] 
          company_image_url = "http:#{company_image_url}" if !company_image_url.blank? and company_image_url[0..1] == "//"
        rescue
        end
        company_image = URLTempfile.new(company_image_url, Dir.tmpdir, :encoding => 'ascii-8bit') unless company_image_url.blank?
   
        Job.create({
          :source => "Github",
          :title => title,
          :date => date,
          :description => description,
          :url => url,
          :category => Category::PROGRAMMING,
          :schedule => schedule,
          :company => {
            :name => company,
            :url => url,
            :image => company_image
          },
          :address => {
            :origin => location
          }
        })
        
      end
    end
  end
end