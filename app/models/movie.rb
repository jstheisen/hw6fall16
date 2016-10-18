class Movie < ActiveRecord::Base
  
  
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
 class Movie::InvalidKeyError < StandardError ; end
  
  def self.find_in_tmdb(string)
    begin
      
      Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
      Tmdb::Movie.find(string)
      movies = Tmdb::Movie.find(string)
      movie_hash_array = []
      
      if movies.empty?
        return movie_hash_array
      end
      
      movies.each do |m|
        h = Hash.new  
        h[:tmbdb_id] = m.id
        h[:title] = m.title
######################################################        
        rating = Tmdb::Movie.releases(m.id)
        if rating['countries'].empty? then rating = "NR"
        else
          rating = rating['countries'].select{|s| s['iso_3166_1']=='US'}
          if(rating.count > 0)
            rating = rating[0]['certification'] 
          end
        end
        if rating.empty? then rating = "NR"
        end 
        h[:rating] = rating
##########################################################        
        h[:release_date] = m.release_date
        movie_hash_array.push(h)
      end
      
      return movie_hash_array
      
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
  
  def self.create_from_tmdb(id)
    m = Hash.new
    details = Tmdb::Movie.detail(id)
    m[:title] = details['title']
    m[:release_date] = details['release_date']
    m[:description] = details['overview']
    ######################################################        
    rating = Tmdb::Movie.releases(id)
    if rating['countries'].empty? then rating = "NR"
    else
      rating = rating['countries'].select{|s| s['iso_3166_1']=='US'}
      if(rating.count > 0)
        rating = rating[0]['certification'] 
      end
    end
    if rating.empty? then rating = "NR"
    end 
    m[:rating] = rating
##########################################################
    
    Movie.create!(m)
  end

end