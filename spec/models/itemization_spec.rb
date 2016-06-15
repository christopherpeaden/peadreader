require 'rails_helper'

RSpec.describe Itemization, type: :model do
  it { should respond_to(:category_id) }
  it { should respond_to(:item_id) }
end
