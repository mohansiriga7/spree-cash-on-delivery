Spree::Order.class_eval do

  def cod_update_order

  	#refer to payment_method/cash_on_delivery.rb
  	cod_adjustments = self.adjustments.where('label=? AND source_type=? ', I18n.t(:shipping_and_handling), 'Spree::PaymentMethod')
  	count_cod_adjustments = cod_adjustments.count 

  	return unless cod_adjustments.count > 0 # return because COD is not involved
  	
  	payment_method = payments.last.payment_method

  	# if payment method is changed and adjustment of cod exists - just remove it.
  	unless payment_method.type == 'Spree::PaymentMethod::CashOnDelivery'
  		cod_adjustments.delete_all #these adjusments are not required anymore as payment method changed from COD to someother
  	end

  	# if total changed after payment is made, reproduce the payment and old one will be voided
  	#recreate payment to handle adjustment cost added after payment step in checkout
  	#for cod adjustment object is created after payment is already created.
    # update because cod adjustment added or payment_method changed from cod to someother
    update_with_updater!
  	if payment_required? && payments.valid.sum(:amount) != total
    	payments.create!(payment_method:payment_method, amount:self.total.to_f)
    end
  end

end

#Spree::Order.state_machine.before_transition :to => :confirm,
#                                             :do => :cod_update_order