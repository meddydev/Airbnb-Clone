require_relative "./user"

class UserRepository
  def all
    query = "SELECT * FROM users;"
    result_set = DatabaseConnection.exec_params(query, [])
    users = []

    result_set.each do |record|
        users << record_to_user_object(record)
    end
    users
  end

  def find_by_email(email)
    query = "SELECT * FROM users WHERE email = $1;"
    params = [email]

    result_set = DatabaseConnection.exec_params(query, params)
    record = result_set[0]
    record_to_user_object(record)
  end

  def create(user)
    query = "INSERT INTO users (name, email, password) VALUES ($1, $2, $3);"
    params = [user.name, user.email, user.password]

    DatabaseConnection.exec_params(query, params)
  end

  private 

  def record_to_user_object(record)
    user = User.new
    user.id = record["id"].to_i
    user.name = record["name"]
    user.email = record["email"]
    user.password = record["password"]

    return user
  end
end
