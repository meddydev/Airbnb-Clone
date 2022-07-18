TRUNCATE TABLE users RESTART IDENTITY CASCADE;
TRUNCATE TABLE spaces RESTART IDENTITY;


INSERT INTO users (name, email, password) VALUES ('name_1', 'email1@example.com', 'pass_1');
INSERT INTO users (name, email, password) VALUES ('name_2', 'email2@example.com', 'pass_2');
INSERT INTO users (name, email, password) VALUES ('name_3', 'email3@example.com', 'pass_3');


INSERT INTO spaces (title, description, price_per_night, available_from_date, available_to_date, owner_id) VALUES ('title_1', 'description1', 54.39, '2022-07-05', '2022-08-05', 1);
INSERT INTO spaces (title, description, price_per_night, available_from_date, available_to_date, owner_id) VALUES ('title_2', 'description2', 30, '2022-08-05', '2022-09-05', 1);
INSERT INTO spaces (title, description, price_per_night, available_from_date, available_to_date, owner_id) VALUES ('title_3', 'description3', 30, '2022-09-05', '2022-10-05', 3);

