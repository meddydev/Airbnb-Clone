require "booking_repository"

describe BookingRepository do
  def reset_tables
    seed_sql = File.read("spec/seeds/seeds_tests.sql")
    connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_tables
  end

  it "lists all bookings" do
    repo = BookingRepository.new
    bookings = repo.all

    expect(bookings.length).to eq 3
    expect(bookings.first.confirmed).to eq "f"
    expect(bookings.last.requester_id).to eq 2
  end

  it "finds a booking by its id" do
    repo = BookingRepository.new
    booking = repo.find(1)

    expect(booking.id).to eq 1
    expect(booking.confirmed).to eq "f"
    expect(booking.requester_id).to eq 1
  end

  it "creates a new booking" do
    repo = BookingRepository.new
    booking = Booking.new
    booking.confirmed = 'FALSE'
    booking.from_date = "2022-10-05"
    booking.to_date = "2022-11-04"
    booking.requester_id = 3
    booking.space_id = 1

    repo.create(booking)
    expect(repo.all.length).to eq 4
    expect(repo.all.last.id).to eq 4
    expect(repo.all.last.confirmed).to eq "f"
    expect(repo.all.last.from_date).to eq "2022-10-05"
  end

  it "updates a booking by id" do
    repo = BookingRepository.new
    booking = repo.find(2)
    booking.confirmed = 'TRUE'
    booking.to_date = "2023-01-01"
    repo.update(booking)
    new_booking = repo.find(2)

    expect(new_booking.confirmed).to eq 't'
    expect(new_booking.to_date).to eq "2023-01-01"
    expect(new_booking.from_date).to eq "2022-08-05"
  end
end