require 'customer'

describe Customer do

  before(:each) do
    @order = {}
    @total = 0
  end

  it 'should have an order that is a hash' do
    expect(subject.order.class).to eq Hash # Try to avoid type checking
  end

  describe 'check_menu' do
    it { is_expected.to respond_to(:check_menu).with(1).argument}
  end

  describe 'add_to_order' do

    let(:m) { double :menu, items: { burger: 10, pizza: 8, soup: 7 } }

    # subject { Customer.new(m) }

    it 'responds to order' do
      expect(subject).to respond_to(:add_to_order).with(3).arguments
    end

    it 'adds new items to order' do
      subject.add_to_order(m,'burger', 2) # this is an example of a magic number. Consider using keyword arguments.
      expect(subject.order[:burger]).to eq [2,10] # You might want this to return a hash as it's not clear what these numbers mean
    end

    it 'updates the quantity of items already in order' do
      subject.add_to_order(m,'burger',2)
      subject.add_to_order(m,'burger',3)
      expect(subject.order[:burger]).to eq [5,10]
    end

    it "updates the customer's total price" do
      subject.add_to_order(m,'burger',2)
      subject.add_to_order(m,'pizza',3)
      expect(subject.total_price).to eq 44
    end

    it "should update the customer's total quantity" do # 'should', for me, is implied by this being a test. We're defining here what 'should' be
      subject.add_to_order(m,'burger',2)
      subject.add_to_order(m,'pizza',3)
      expect(subject.total_quantity).to eq 5
    end
  end

  describe 'place order' do
    it 'should not place order if total is miscalculated' do
      m = double :menu, items: { burger: 10, pizza: 8, soup: 7 }
      subject.add_to_order(m,'burger',2)
      subject.add_to_order(m,'pizza',3)
      subject.total_price = 0
      expect{subject.place_order}.to raise_error "Total price miscalculation"
    end

    it 'should send a message to customer' do
      m = double :menu, items: {burger: 10, pizza: 8, soup: 7}
      text_sender = double :text_sender
      expect(text_sender).to receive(:send_message).with('Your order cost 44') # Try to make this test pass.

      subject.add_to_order(m,'burger',2)
      subject.add_to_order(m,'pizza',3)
      subject.place_order(text_sender)
    end
  end
end
