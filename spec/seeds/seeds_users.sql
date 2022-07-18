TRUNCATE TABLE users RESTART IDENTITY;

INSERT INTO users (name, email, password) VALUES ('name_1', 'email1@example.com', 'pass_1');
INSERT INTO users (name, email, password) VALUES ('name_2', 'email2@example.com', 'pass_2');
INSERT INTO users (name, email, password) VALUES ('name_3', 'email3@example.com', 'pass_3');
