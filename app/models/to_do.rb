class ToDo < ActiveRecord::Base
  begin :associations
    belongs_to :user
  end

  begin :validations
    validates :priority,
      presence: true,
      numericality: { in: 1..5 }
    validates :user_id,
      presence: true
  end
end
