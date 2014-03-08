class ToDo < ActiveRecord::Base
  begin :associations
    belongs_to :user
  end

  begin :validations
    validates :priority,
      presence: true,
      numericality: { in: 1..5 }
    validates :sort_order,
      presence: true,
      numericality: { greater_than_or_equal_to: 0 }
    validates :user_id,
      presence: true
  end
end
