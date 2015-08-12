Spree::Payment.class_eval do
  has_one :adjustment, :as => :source, :dependent => :destroy
  after_create :payment_method_after_create

  def payment_method_after_create
    if payment_method.respond_to?(:post_create)
      payment_method.post_create(self)
    end
  end
end
