require 'spec_helper'

describe "OmniAuth::Strategies::LinkedIn" do
  subject do
    OmniAuth::Strategies::LinkedIn.new(nil, @options || {})
  end

  it 'should add a camelization for itself' do
    OmniAuth::Utils.camelize('linkedin').should == 'LinkedIn'
  end

  context 'client options' do
    it 'has correct LinkedIn site' do
      subject.options.client_options.site.should eq('https://api.linkedin.com')
    end

    it 'has correct request token path' do
      subject.options.client_options.request_token_path.should eq('/uas/oauth/requestToken')
    end

    it 'has correct access token path' do
      subject.options.client_options.access_token_path.should eq('/uas/oauth/accessToken')
    end

    it 'has correct authorize url' do
      subject.options.client_options.authorize_url.should eq('https://www.linkedin.com/uas/oauth/authenticate')
    end
  end

  context '#uid' do
    before :each do
      subject.stub(:raw_info) { { 'id' => '123' } }
    end

    it 'returns the id from raw_info' do
      subject.uid.should eq('123')
    end
  end
end
