module Spree
  class PaymentMethod::CashOnDelivery < PaymentMethod

    def payment_profiles_supported?
      true # we want to show the confirm step.
    end

    def post_create(payment)
      # order = payment.order
      # order.adjustments.each { |a| a.destroy if a.label == I18n.t(:shipping_and_handling) }
      # order.adjustments.create(:amount => Spree::Config[:cash_on_delivery_charge],
      #                                  :source => self,
      #                                  :adjustable => payment.order,
      #                                  :order => payment.order,
      #                                  :label => I18n.t(:shipping_and_handling))

      
    end
    
    def update_adjustment(adjustment, src)
      adjustment.update_attribute_without_callbacks(:amount, Spree::Config[:cash_on_delivery_charge])
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
      payment.state == 'checkout'
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
  end
end
