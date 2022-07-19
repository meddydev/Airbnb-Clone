require "user_repository"

describe UserRepository do
  def reset_users_table
    seed_sql = File.read("spec/seeds/seeds_tests.sql")
    connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_users_table
  end

  context "Return users" do
    it "return all users" do
      repo = UserRepository.new
      users = repo.all
      expect(users.length).to eq 3
      expect(users.first.id).to eq 1
      expect(users.last.password).to eq "pass_3"
    end

    it "finds specific user by referencing email" do
      repo = UserRepository.new
      user = repo.find_by_email("email2@example.com")

      expect(user.id).to eq 2
      expect(user.name).to eq "name_2"
      expect(user.password).to eq "pass_2"
    end
  end

  context "Create users" do
    it "create a new user" do
      repo = UserRepository.new
      new_user = User.new
      new_user.name = "name4"
      new_user.email = "email4@example.com"
      new_user.password = "pass_4"
      repo.create(new_user)
      users = repo.all
      expect(users.length).to eq 4
      expect(users.last.id).to eq 4
      expect(users.last.name).to eq "name4"
    end
  end
end
