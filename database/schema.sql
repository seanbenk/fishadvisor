CREATE DATABASE fishing_spots_app_db;

CREATE TABLE users (user_id SERIAL PRIMARY KEY, username TEXT, email TEXT, password_digest text);

CREATE TABLE posts (post_id SERIAL PRIMARY KEY, title TEXT, blurb TEXT, spot_name TEXT, lng DOUBLE PRECISION, lat DOUBLE PRECISION, user_id INT);