require 'album_repository'

RSpec.describe AlbumRepository do
  def reset_albums_table
    seed_sql = File.read('spec/seeds_albums.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  before(:each) do 
    reset_albums_table
  end

  describe '#all' do
    it 'returns the list of albums' do
      repo = AlbumRepository.new

      albums = repo.all


      expect(albums.length).to eq(2)
      expect(albums.first.id).to eq('1')
      expect(albums.first.title).to eq("Master of Puppets")
      expect(albums.first.release_year).to eq("1986")
      expect(albums[1].id).to eq('2')
      expect(albums[1].title).to eq('Audioslave')
      expect(albums[1].release_year).to eq("2002")
    end
  end

  describe '#find' do
    it 'returns the value of a single album' do
      repo = AlbumRepository.new

      album = repo.find(2)
      
      expect(album.id).to eq('2')
      expect(album.title).to eq('Audioslave')
      expect(album.release_year ).to eq('2002')
    end
  end

  describe '#create' do
    it 'inserts a new album into the albums library' do
      repo = AlbumRepository.new

      album = Album.new
      album.title = 'Trompe le Monde'
      album.release_year = '1991'
      album.id = '3'

      repo.create(album)

      all_albums = repo.all
      
      expect(all_albums).to include(
        have_attributes(
          title: album.title, 
          release_year: album.release_year
        )
      )
    end
  end
end