CREATE DATABASE fishing_spots_app_db;

CREATE TABLE users (user_id SERIAL PRIMARY KEY, username TEXT, email TEXT, password_digest text);

CREATE TABLE posts (post_id SERIAL PRIMARY KEY, location_name TEXT, target_fish TEXT, best_bait TEXT, best_lures TEXT, best_times TEXT, about TEXT, lng DOUBLE PRECISION, lat DOUBLE PRECISION, user_id INT, post_created TIMESTAMP);

CREATE TABLE comments (comment_id SERIAL PRIMARY KEY, comment user_id INT, post_id INT)