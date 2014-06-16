RSpec.describe OmniAuth::Strategies::LinkedIn do
  subject(:linkedin) do
    OmniAuth::Strategies::LinkedIn.new(nil, @options || {})
  end

  it 'adds a camelization for itself' do
    expect(OmniAuth::Utils.camelize('linkedin')).to eq 'LinkedIn'
  end

  context 'client options' do
    it 'has correct LinkedIn site' do
      expect(linkedin.options.client_options.site).to eq 'https://api.linkedin.com'
    end

    it 'has correct request token path' do
      expect(linkedin.options.client_options.request_token_path).to eq '/uas/oauth/requestToken'
    end

    it 'has correct access token path' do
      expect(linkedin.options.client_options.access_token_path).to eq '/uas/oauth/accessToken'
    end

    it 'has correct authorize url' do
      expect(linkedin.options.client_options.authorize_url).to eq 'https://www.linkedin.com/uas/oauth/authenticate'
    end
  end

  context '#uid' do
    before do
      allow(linkedin).to receive(:raw_info).and_return('id' => '123')
    end

    it 'returns the id from raw_info' do
      expect(linkedin.uid).to eq '123'
    end
  end

  context 'returns info hash conformant with omniauth auth hash schema' do
    before do
      allow(linkedin).to receive(:raw_info).and_return({})
    end

    context 'and therefore has all the necessary fields' do
      it {expect(linkedin.info).to have_key :name}
      it {expect(linkedin.info).to have_key :name}
      it {expect(linkedin.info).to have_key :email}
      it {expect(linkedin.info).to have_key :nickname}
      it {expect(linkedin.info).to have_key :first_name}
      it {expect(linkedin.info).to have_key :last_name}
      it {expect(linkedin.info).to have_key :location}
      it {expect(linkedin.info).to have_key :description}
      it {expect(linkedin.info).to have_key :image}
      it {expect(linkedin.info).to have_key :phone}
      it {expect(linkedin.info).to have_key :urls}
    end
  end
end
