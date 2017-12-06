require 'rails_helper'

RSpec.describe Spree::Events::Processors::MailProcessor do
  let(:processor) { Spree::Events::Processors::MailProcessor }
  let(:order) { create(:order) }

  RSpec.shared_examples 'sends the correct email' do |method|
    it 'sends the email' do
      mail_double = double
      expect(mailer).to receive(method).with(*args).and_return(mail_double)
      expect(mail_double).to receive(:deliver_later)
      subject
    end
  end

  describe '#send_confirm_email' do
    let(:event) { Spree::Events::OrderConfirmedEvent.new(order: order) }
    subject { processor.send_confirm_email(event) }

    include_examples 'sends the correct email', :confirm_email do
      let(:mailer) { Spree::OrderMailer }
      let(:args) { [order] }
    end

    it 'sets confirmation delivered' do
      expect(order.confirmation_delivered?).to be false
      subject
      expect(order.confirmation_delivered?).to be true
    end

    context 'confirmation email has already been sent' do
      it 'does not send duplicate confirmation emails' do
        allow(order).to receive_messages(confirmation_delivered?: true)
        expect(Spree::OrderMailer).not_to receive(:confirm_email)
        subject
      end
    end
  end

  describe '#send_cancel_email' do
    let(:event) { Spree::Events::OrderCancelledEvent.new(order: order) }
    subject { processor.send_cancel_email(event) }

    include_examples 'sends the correct email', :cancel_email do
      let(:mailer) { Spree::OrderMailer }
      let(:args) { [order] }
    end
  end

  describe '#send_inventory_cancellation_email' do
    let(:inventory_units) { [] }
    let(:event) { Spree::Events::OrderInventoryCancelledEvent.new(order: order, inventory_units: inventory_units) }
    subject { processor.send_inventory_cancellation_email(event) }

    include_examples 'sends the correct email', :inventory_cancellation_email do
      let(:mailer) { Spree::OrderMailer }
      let(:args) { [order, inventory_units] }
    end
  end

  describe '#send_reimbursement_email' do
    let(:reimbursement) { create(:reimbursement) }
    let(:event) { Spree::Events::ReimbursementProcessedEvent.new(reimbursement: reimbursement) }
    subject { processor.send_reimbursement_email(event) }

    include_examples 'sends the correct email', :reimbursement_email do
      let(:mailer) { Spree::ReimbursementMailer }
      let(:args) { [reimbursement.id] }
    end
  end

  describe '#send_carton_shipped_emails' do
    let(:carton) { create(:carton) }
    let(:event) { Spree::Events::CartonShippedEvent.new(carton: carton) }
    subject { processor.send_carton_shipped_emails(event) }

    include_examples 'sends the correct email', :shipped_email do
      let(:mailer) { Spree::Config.carton_shipped_email_class }
      let(:args) { [order: carton.orders.first, carton: carton] }
    end
  end
end
