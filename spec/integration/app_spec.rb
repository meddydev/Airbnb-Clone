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
end