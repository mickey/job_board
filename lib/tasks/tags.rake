#TODO : update
namespace :tags do
  desc "Get all popular tags from stack overflow"
  task :all => :environment do
    pages = [1,2, 3]
    http = Net::HTTP.new('api.stackoverflow.com', 80)
    
    pages.each do |p|
      response = http.get("/1.0/tags?page=#{p}&key=m1AUJ5BVsEeHFk6EuHTtsw&pagesize=100")
      res = ActiveSupport::Gzip.decompress(response.body)
      parsed_res = JSON.parse(res)
      parsed_res["tags"].each do |tag|
        Tag.create({
          :name => tag["name"],
          :stack_popularity => tag["count"]
        })
      end
    end

  end
end