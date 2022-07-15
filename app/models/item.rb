class Item < ApplicationRecord
    belongs_to :merchant

    validates_presence_of :name, :description, :unit_price 

    def self.find_by_name(name)
        where("lower(name) LIKE ?", "%#{name}%")
        .order(:name)
        # binding.pry
    end

    def self.find_by_price(min, max)
        if max && !min
            where("unit_price < ?", max)
        elsif min && !max
            where("unit_price > ?", min)
        else
            where("unit_price < ? AND unit_price > ?", max, min)
        end
    end
end
