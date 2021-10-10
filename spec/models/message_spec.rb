require 'rails_helper'

RSpec.describe Message, type: :model do
  subject { Message.new(body: 'Random message') }

  before { subject.save }

  it 'body should be present' do
    subject.body = nil
    expect(subject).to_not be_valid
  end

  it 'body should not be blank' do
    subject.body = ''
    expect(subject).to_not be_valid
  end
end
