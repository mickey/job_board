if defined?(PhusionPassenger) 
   PhusionPassenger.on_event(:starting_worker_process) do |forked| 
     MongoMapper.connection.connect if forked 
   end 
end