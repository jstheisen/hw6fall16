describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid API key' do
      # elided for brevity
    end
    context 'with invalid API key' do
      before(:each) do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
      end
      # all specs in this block can take advantage the above stub
      it 'raises an InvalidKeyError' do
        expect { Movie.find_in_tmdb('Inception') }.
          to raise_error(Movie::InvalidKeyError)
      end
      # other sad-path specs here
    end
  end
end
