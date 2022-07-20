require_relative "./space"

class SpaceRepository
    def all
        query = "SELECT * FROM spaces;"
        result_set = DatabaseConnection.exec_params(query, [])
        spaces = []

        result_set.each do |record|
            spaces << record_to_space_object(record)
        end
        spaces
    end

    def find(id)
        query = "SELECT * FROM spaces WHERE id = $1;"
        params = [id]

        result_set = DatabaseConnection.exec_params(query, params)
        record = result_set[0]

        record_to_space_object(record)
    end

    def create(space)
        query = "INSERT INTO spaces (title, description, price_per_night, available_from_date, available_to_date, owner_id, image) VALUES ($1, $2, $3, $4, $5, $6, $7);"
        params = [space.title, space.description, space.price_per_night, space.available_from_date, space.available_to_date, space.owner_id, space.image]

        DatabaseConnection.exec_params(query, params)
    end

    private

    def record_to_space_object(record)
        space = Space.new
        space.id = record["id"].to_i
        space.title = record["title"]
        space.description = record["description"]
        space.price_per_night = record["price_per_night"]
        space.available_from_date = record["available_from_date"]
        space.available_to_date = record["available_to_date"]
        space.owner_id = record["owner_id"]

        return space
    end
end