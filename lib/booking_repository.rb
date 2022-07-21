require_relative './booking'

class BookingRepository
    def all
        query = "SELECT * FROM bookings;"
        result_set = DatabaseConnection.exec_params(query, [])
        bookings = []

        result_set.each do |record|
            bookings << record_to_booking_object(record)
        end
        bookings
    end

    def find(id)
        query = "SELECT * FROM bookings WHERE id = $1;"
        params = [id]

        result_set = DatabaseConnection.exec_params(query, params)
        record = result_set[0]

        record_to_booking_object(record)
    end

    def create(booking)
        query = "INSERT INTO bookings (confirmed, from_date, to_date, requester_id, space_id) VALUES ($1, $2, $3, $4, $5);"
        params = [booking.confirmed, booking.from_date, booking.to_date, booking.requester_id, booking.space_id]

        DatabaseConnection.exec_params(query, params)
    end

    def update(booking)
        query = "UPDATE bookings SET confirmed = $1, from_date = $2, to_date = $3, requester_id = $4, space_id = $5 WHERE id = $6;"
        params = [booking.confirmed, booking.from_date, booking.to_date, booking.requester_id, booking.space_id, booking.id]

        DatabaseConnection.exec_params(query, params)
    end

    private

    def record_to_booking_object(record)
        booking = Booking.new
        booking.id = record["id"].to_i
        booking.confirmed = record["confirmed"]
        booking.from_date = record["from_date"]
        booking.to_date = record["to_date"]
        booking.requester_id = record["requester_id"].to_i
        booking.space_id = record["space_id"].to_i
        booking
    end
end