class Merchant < ApplicationRecord
    validates :name, presence: true
    
    has_many :items

    def self.find_first_partial(name)
        find_by_name(name.downcase)
    end

    def self.find_by_name(name)
        where("lower(name) LIKE ?", "%#{name}%")
        .order(:name)
        .first
        # binding.pry
    end
end
