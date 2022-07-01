class User < ApplicationRecord
  pay_customer default_payment_processor: :stripe, stripe_attributes: :stripe_attributes

  def email
    "#{nickname}@example.com"
  end

  def stripe_attributes(user)
    {
      metadata: {
        twitter_id: twitter_id,
        user_id: id,
        nickname: "@#{nickname}"
      }
    }
  end
end
