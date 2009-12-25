require 'rubygems'
require 'action_mailer'
require 'haml'
require 'net/smtp'

class InventoryMailer < ActionMailer::Base
  def inventory_notice
    subject 'Inventory'
    recipients 'alexebird+food@gmail.com'
    body :message => 'test'
    template "inventory_notice.haml"
  end
end

#InventoryMailer.template_root = Ramaze.options.roots.first + '/views'
InventoryMailer.template_root = "/home/bird/cs/food/website/view/"
InventoryMailer.delivery_method = :smtp
InventoryMailer.logger = Logger.new(STDOUT)
InventoryMailer.smtp_settings = { 
   :enable_starttls_auto => true,
   :address => 'smtp.gmail.com',
   :port => 587,
   :domain => 'aebird.net',
   :authentication => :plain,
   :user_name => 'food@aebird.net',
   :password => '4D4778'
 }

# this sends the email
InventoryMailer.deliver_inventory_notice
