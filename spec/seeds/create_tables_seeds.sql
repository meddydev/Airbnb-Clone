CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name text,
  email text,
  password text
);

CREATE TABLE spaces (
  id SERIAL PRIMARY KEY,
  title text,
  description text,
  price_per_night money,
  available_from_date date,
  available_to_date date,
  owner_id int,
  constraint fk_owner foreign key(owner_id) references users(id)
);

-- YYYY-MM-DD