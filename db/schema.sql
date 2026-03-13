-- Mixsched MySQL schema (initial)
CREATE DATABASE IF NOT EXISTS mixesched CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE mixesched;

CREATE TABLE IF NOT EXISTS users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('admin','user') NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS makers (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS models (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  maker_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_model_per_maker (maker_id, name),
  CONSTRAINT fk_models_maker FOREIGN KEY (maker_id) REFERENCES makers(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS events (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  maker_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(150) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_event_per_maker (maker_id, name),
  CONSTRAINT fk_events_maker FOREIGN KEY (maker_id) REFERENCES makers(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS items (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  maker_id BIGINT UNSIGNED NOT NULL,
  model_id BIGINT UNSIGNED NOT NULL,
  event_id BIGINT UNSIGNED NULL,
  item_no INT NOT NULL,
  npra_date DATE NULL,
  process VARCHAR(255) NULL,
  product VARCHAR(255) NULL,
  potential_failure_mode TEXT NULL,
  potential_cause_of_failure TEXT NULL,
  countermeasure_note TEXT NULL,
  countermeasure_process VARCHAR(255) NULL,
  pic VARCHAR(100) NULL,
  target_date DATE NULL,
  status ENUM('—','Open','Closed','Cancelled','Rejected') NOT NULL DEFAULT '—',
  recovery_date DATE NULL,
  date_closed DATE NULL,
  pfmea_inclusion ENUM('—','for inclusion','already included') NOT NULL DEFAULT '—',
  qcp_inclusion ENUM('—','for inclusion','already included') NOT NULL DEFAULT '—',
  evidence TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_items_lookup (maker_id, model_id, event_id, status, target_date),
  CONSTRAINT fk_items_maker FOREIGN KEY (maker_id) REFERENCES makers(id) ON DELETE CASCADE,
  CONSTRAINT fk_items_model FOREIGN KEY (model_id) REFERENCES models(id) ON DELETE CASCADE,
  CONSTRAINT fk_items_event FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE SET NULL
);

-- Optional seed users (replace password hashes with your backend-generated hashes)
-- INSERT INTO users(username, password_hash, role)
-- VALUES ('admin', '$2y$...', 'admin'), ('user', '$2y$...', 'user');
