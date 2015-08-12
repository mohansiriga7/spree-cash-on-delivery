module Spree
  class PaymentMethod::CashOnDelivery < Spree::PaymentMethod

    preference :fee, :string

    def payment_profiles_supported?
      true # we want to show the confirm step.
    end

    def post_create(payment)
      payment.order.adjustments.each { |a| a.destroy if a.label == I18n.t(:shipping_and_handling) }
      payment.order.adjustments.create(:amount => payment.payment_method.preferences[:fee],
                               :source => payment,
                               :order => payment.order,
                               :label => I18n.t(:shipping_and_handling))
    end

    def update_adjustment(adjustment, src)
      adjustment.update_attribute_without_callbacks(:amount, payment.payment_method.preferences[:fee])
    end


    def authorize(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def capture(payment, source, gateway_options)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def void(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def actions
      %w{capture void}
    end

    def can_capture?(payment)
      payment.state == 'credit'
    end

    def can_void?(payment)
      payment.state != 'void'
    end

    def source_required?
      false
    end

    #def provider_class
    #  self.class
    #end

    def payment_source_class
      nil
    end

    def method_type
      'cash_on_delivery'
    end

    def available?
      active and config_valid?
    end

    def config_valid?
      preferred_fee.present?
    end
  end
end
