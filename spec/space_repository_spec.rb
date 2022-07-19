require "space_repository"

describe SpaceRepository do
    def reset_tables
        seed_sql = File.read("spec/seeds/seeds_tests.sql")
        connection = PG.connect({ host: "127.0.01", dbname: "makersbnb_test" })
        connection.exec(seed_sql)
    end

    before(:each) do
        reset_tables
    end

    context "Returns spaces" do
      it "returns all spaces" do
        repo = SpaceRepository.new
        spaces = repo.all
        expect(spaces.length).to eq 3
        expect(spaces.first.id).to eq 1
        expect(spaces.last.title).to eq "title_3"
        expect(spaces.last.available_from_date).to eq "2022-09-05"
      end
      
      it "find specific space by referencing id" do
        repo = SpaceRepository.new
        space = repo.find(1)
        
        expect(space.id).to eq 1
        expect(space.title).to eq "title_1"
        expect(space.description).to eq "description1"
      end
    end

    context "create spaces" do
      it "creates a new space" do
        repo = SpaceRepository.new
        new_space = Space.new
        new_space.title = "title_4"
        new_space.description = "description4"
        new_space.price_per_night = 60
        new_space.available_from_date = "2022-08-05"
        new_space.available_to_date = "2022-09-10"
        new_space.owner_id = 3

        repo.create(new_space)

        expect(repo.all.length).to eq 4
        expect(repo.all.last.id).to eq 4
        expect(repo.all.last.title).to eq "title_4"
        expect(repo.all.last.available_from_date).to eq "2022-08-05"
      end
    end
        
end