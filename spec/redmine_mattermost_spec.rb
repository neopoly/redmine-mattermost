require "spec_helper"

describe RedmineMattermost do
  subject { RedmineMattermost }

  it "has a version" do
    subject::VERSION.wont_be_nil
  end
end
