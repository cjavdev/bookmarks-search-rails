class CheckoutsController < ApplicationController
  before_action :require_user!

  def show

  end

  def create
    # redirect through Stripe Checkout
    @checkout_session = current_user.payment_processor.checkout(
      mode: "subscription",
      line_items: "price_1LGrRJCZ6qsJgndJhz35LZzj",
      allow_promotion_codes: true
    )

    redirect_to @checkout_session.url, allow_other_host: true, status: :see_other
  end
end
