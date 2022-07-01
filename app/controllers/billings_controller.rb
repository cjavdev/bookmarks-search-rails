class BillingsController < ApplicationController
  def show
    @portal_session = current_user.payment_processor.billing_portal

    redirect_to @portal_session.url, allow_other_host: true, status: :see_other
  end
end
