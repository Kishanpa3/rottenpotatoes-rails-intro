class Movie < ActiveRecord::Base
    def self.GetRatingTypes
        %w[G P PG-13 R]
    end
end