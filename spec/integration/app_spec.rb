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
            expect(response.body).to include('input type="text" name="email"')
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
            expect(response.body).to include('input type="text" name="email"')
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
        expect(response.body).to include('<a href="/add_space">Click here to add a new space</a>')
        expect(response.body).to include('<a href="/spaces/1">title_1</a>')
        expect(response.body).to include('<p>description1</p>')
        expect(response.body).to include('<a href="/spaces/2">title_2</a>')
        expect(response.body).to include('<p>description2</p>')
      end
    end
end