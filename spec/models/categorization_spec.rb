require 'rails_helper'

RSpec.describe Categorization, type: :model do
  it { should respond_to(:category_id) }
  it { should respond_to(:feed_id) }
end
