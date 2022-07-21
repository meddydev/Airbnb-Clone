require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
    include Rack::Test::Methods
  
    let(:app) { Application.new }
  
    def reset_tables
      seed_sql = File.read('spec/seeds/seeds_tests.sql')
      connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
      connection.exec(seed_sql)
    end
    
    before(:each) do 
      reset_tables
    end

    context 'GET /' do
        it 'returns 200 OK, sign form and link to log in' do 
            response = get ('/')
            expect(response.status).to eq(200)
            expect(response.body).to include("<h1>Welcome to MakersBnB</h1>")
            expect(response.body).to include('<form action="/signup" method="POST">')
            expect(response.body).to include('input type="text" name="name"')
            expect(response.body).to include('input type="email" name="email"')
            expect(response.body).to include('input type="password" name="password"')
            expect(response.body).to include('<a href="/login"> I already have an account </a>')
        end
    end

    context 'GET /login' do 
        it 'returns 200 OK and the form to log in' do
            response = get('/login')
            expect(response.status).to eq(200)
            expect(response.body).to include('<h1>Login to your account</h1>')
            expect(response.body).to include('<form action="/login" method="POST">')
            expect(response.body).to include('input type="email" name="email"')
            expect(response.body).to include('input type="password" name="password"')
        end
    end

    context 'POST /signup' do
      it "returns 200 OK and new user is created" do
        response = post('/signup', name: "Meddy", email: "meddy@example.com", password: "medmed")
        repo = UserRepository.new
        expect(response.status).to eq(200)
        expect(response.body).to include('<h1>You have successfully signed up for MakersBnB</h1>')
        expect(response.body).to include('<a href="/login">Click here to Login!</a>')
        expect(repo.all.last.email).to eq "meddy@example.com"
        expect(repo.all.length).to eq 4
      end

      it "returns 200 OK and displays HTML error page if user signs up with email already in database" do
        response = post('/signup', name: "name_1", email: "email1@example.com", password: "pass_1")
        repo = UserRepository.new

        expect(response.status).to eq(200)
        expect(response.body).to include('<h2>The email you are trying to sign up with already has an account associated with it.</h2>')
        expect(response.body).to include('<a href="/">Click here to go back to the homepage</a>')
        expect(response.body).to include('<a href="/login">Click here if you would like to login</a>')
        expect(repo.all.length).to eq 3
      end
    end

    context 'POST /login' do
      it "returns 200 OK and gives you link to go to your account page" do
        response = post('/login', email: "email1@example.com", password: "pass_1") 
        
        expect(response.status).to eq(200)
        expect(response.body).to include('<h1>Correct login info!</h1>')
        expect(response.body).to include('<a href="/account_page">Click here to go to your personal MakersBnB account!</a>')
      end

      it "returns 200 OK and give you an error message when password is wrong and link back to login" do
        response = post('/login', email: "email1@example.com", password: "medmed")

        expect(response.status).to eq(200)
        expect(response.body).to include('<h1>Incorrect login info</h1>')
        expect(response.body).to include('<a href="/login">Click here to login again</a>')
        expect(response.body).to include('<a href="/">Click here to go back to the homepage</a>')
      end

      it "return 200 ok and gives an error message when the email doesn't exist" do
        response = post('/login', email: "hello@email.com", password: "pass")

        expect(response.status).to eq(200)
        expect(response.body).to include('<a href="/login">Click here to login again</a>')
        expect(response.body).to include('<a href="/">Click here to go back to the homepage</a>')
      end
    end

    context 'GET to /account_page' do
      it "returns 200 ok and welcomes you to you account page, gives a link to add a new space and shows you a list of spaces" do
        login = post('/login', email: "email1@example.com", password: "pass_1")
        response = get('/account_page')

        expect(response.status).to eq(200)
        expect(response.body).to include('<h1>Welcome to your MakersBnB account</h1>')
        expect(response.body).to include('<a href="/add_space">Add a new space</a>')
        expect(response.body).to include('<a href="/spaces/1">title_1</a>')
        expect(response.body).to include('<p>description1</p>')
        expect(response.body).to include('<a href="/spaces/2">title_2</a>')
        expect(response.body).to include('<p>description2</p>')
      end
    end

    context 'GET /spaces/:id' do
      it "returns 200 OK with relevant information associated with the space" do
        response = get('/spaces/3')

        expect(response.status).to eq(200)
        expect(response.body).to include('title_3')
        expect(response.body).to include('description3')
        expect(response.body).to include('30')
        expect(response.body).to include('2022-09-05')
        expect(response.body).to include('2022-10-05')
        expect(response.body).to include('name_3')
        expect(response.body).to include("/new_request/3")
        expect(response.body).to include('Request this space')
      end
    end

    context 'GET /add_space' do
      it "returns 200 OK with an HTML form to list a new space" do
        response = get('/add_space')

        expect(response.status).to eq(200)
        expect(response.body).to include('List your space!')
        expect(response.body).to include('<form action="/add_space" method="POST">')
        expect(response.body).to include('input type="text" name="title"')
        expect(response.body).to include('input type="text" name="description"')
        expect(response.body).to include('input type="number" step=".01" name="price_per_night"')
        expect(response.body).to include('input type="date" name="available_from_date"')
        expect(response.body).to include('input type="date" name="available_to_date"')
        expect(response.body).to include('input type="hidden" name="owner_id"')
      end
    end

    context 'POST /add_space' do
      it "returns 302 OK and adds space to database" do
        login = post('/login', email: "email1@example.com", password: "pass_1")
        response = post('/add_space', title: "Bob's house", description: "really nice house", price_per_night: 89, available_from_date: "2022-10-07", available_to_date: "2022-10-12", owner_id: 1)
        repo = SpaceRepository.new
        spaces = repo.all


        expect(response.status).to eq(302)
        expect(spaces.length).to eq(4)
        expect(spaces.last.id).to eq(4)
        expect(spaces.last.title).to eq("Bob's house")
        expect(spaces.last.price_per_night).to eq('$89.00')
        expect(spaces.last.available_from_date).to eq("2022-10-07")
        expect(spaces.last.owner_id).to eq("1")
      end

      context 'POST /spaces/space.id/new_request' do
        it "send the request to the owner" do 
          login = post('/login', email: "email1@example.com", password: "pass_1")
          response = post('new_request/3', confirmed: "FALSE", from_date:"2022-07-23", to_date:"2022-07-25", requester_id: 1, space_id: 3)
          repo = BookingRepository.new
          expect(response.status).to eq(302)
          bookings = repo.all

          expect(bookings.length).to eq 4
          expect(bookings.last.confirmed).to eq "f"
        end
      end
    end

    context "GET /account_page/requests" do
      it "shows requests I've made for other spaces" do
        login = post('/login', email: "email1@example.com", password: "pass_1")
        new_request = post('new_request/3', confirmed: "FALSE", from_date:"2022-07-23", to_date:"2022-07-25", requester_id: 1, space_id: 3)
        response = get("/account_page/requests")

        expect(response.status).to eq(200)
        expect(response.body).to include("REQUESTS YOU HAVE MADE")
        expect(response.body).to include("Request pending")
        expect(response.body).to include("2022-07-23")
        expect(response.body).to include("2022-07-25")
        expect(response.body).to include("title_3")
        expect(response.body).to include("description3")
        expect(response.body).to include("name_3")
      end
    end

    it "shows requests for my listed spaces" do
      login = post('/login', email: "email1@example.com", password: "pass_1")
      response = get("/account_page/requests")

      expect(response.status).to eq(200)
      expect(response.body).to include("BOOKINGS FOR YOUR SPACES")
      expect(response.body).to include("title_2")
      expect(response.body).to include("description2")
      expect(response.body).to include("name_3")
      expect(response.body).to include("2022-08-05")
      expect(response.body).to include("2022-09-05")
      expect(response.body).to include('<form action="/update/2" method="POST">')
    end
end
