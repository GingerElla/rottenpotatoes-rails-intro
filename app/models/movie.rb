class Movie < ActiveRecord::Base
    def self.get_all_ratings
        self.pluck(:rating).uniq.sort
    end
end