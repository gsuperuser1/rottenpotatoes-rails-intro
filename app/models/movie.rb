class Movie < ActiveRecord::Base
	def self.full_ratings
	all_ratings = Array.new
	self.select("rating").uniq.each {|movie_| all_ratings.push(movie_.rating)}
	all_ratings.sort.uniq
	end
end
