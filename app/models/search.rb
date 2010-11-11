module Search
  
  def self.included(base)
    class << base
  
      def search(category, tags = [], location = [])
        raise "Category Undefined" unless Category::LIST.include?(category)
    
        tags.uniq!
    
        conditions = {:is_moderated => true, :category => category, :date => {'$gte' => 30.days.ago.midnight}}
        conditions.merge!({'tags_list' => tags}) unless tags.blank?
    
    
        jobs = Job.all(:conditions => conditions)
        sort_by_tags(jobs, tags)
      end
  
      private
      
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