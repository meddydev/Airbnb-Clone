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
  image bytea,
  owner_id int,
  constraint fk_owner foreign key(owner_id) references users(id)
);

CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  confirmed boolean,
  from_date date,
  to_date date,
  requester_id int,
  space_id int,
  constraint fk_space foreign key(space_id) references spaces(id),
  constraint fk_requester foreign key(requester_id) references users(id)
);

-- YYYY-MM-DD