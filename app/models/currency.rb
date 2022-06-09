class Currency < ApplicationRecord
  enum status: { active: 0, inactive: 5, pending: 9 }

 
end