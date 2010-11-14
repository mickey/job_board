module Search
  include Geokit::Geocoders
  
  def self.included(base)
    class << base
  
      def search(category, tags = [], location = "")
        raise "Category Undefined" unless Category::LIST.include?(category)
    
        tags.uniq!
    
        conditions = {:is_moderated => true, :category => category, :date => {'$gte' => 30.days.ago.midnight}}
        conditions.merge!({'tags_list' => tags}) unless tags.blank?
        
        build_location_conditions(conditions, location)
        jobs = Job.all(:conditions => conditions)
        sort_by_tags(jobs, tags)
      end
  
      private
      def build_location_conditions(conditions, location)
        unless location.blank?
          if Address.is_anywhere?(location)
            conditions.merge!({'address.anywhere' => true})
          else
            location_geocoded = MultiGeocoder.geocode(location)
            if location_geocoded.success
              location_conditions = []
              location_conditions << {'address.zip' => location_geocoded.zip} unless location_geocoded.zip.blank?
              location_conditions << {'address.city' => location_geocoded.city} unless location_geocoded.city.blank?
              #location_conditions << {'address.loc' => {'$near' => [location_geocoded.lat, location_geocoded.lng], '$maxDistance' => 2}} unless location_geocoded.city.blank?
              location_conditions << {'address.state' => location_geocoded.state} unless location_geocoded.state.blank?
              location_conditions << {'address.country' => location_geocoded.country} if location_geocoded.city.blank? and location_geocoded.state.blank? and !location_geocoded.country.blank?
              location_conditions << {'address.country_code' => location_geocoded.country_code} if location_geocoded.city.blank? and location_geocoded.state.blank? and !location_geocoded.country_code.blank?
            
              conditions.merge!({'$or' => location_conditions})
            end
          end
        end
      end
      
      def sort_by_tags(job, tags)
        job.sort!{ |a,b| nb_tags_included(tags, a) <=> nb_tags_included(tags, b) }.reverse!
      end
  
      def nb_tags_included(tags, job)
        tags.inject(0) do |nb_tags, tag| 
          nb_tags += 1 if job.tags_list.include?(tag)
          nb_tags
        end
      end
      
    end
  end
  
end