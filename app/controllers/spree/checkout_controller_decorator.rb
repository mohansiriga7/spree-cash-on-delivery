module Spree
  CheckoutController.class_eval do
    before_filter :ensure_no_payment_adjustment_in_cart

    def ensure_no_payment_adjustment_in_cart
      return unless @order.state == 'payment'
      @order.adjustments.each do |a|
        a.destroy if a.source.payment_method.class.name.in? ['Spree::PaymentMethod::CashOnDelivery']
      end
    end
  end
end
