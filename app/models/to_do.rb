class ToDo < ActiveRecord::Base
  begin :associations
    belongs_to :user
  end

  begin :validations
    validates :content,
      presence: true,
      length:   { minimum: 1 }
    validates :priority,
      presence: true,
      numericality: { in: 1..5 }
    validates :user_id,
      presence: true
  end
end
