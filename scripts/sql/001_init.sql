-- Core schema for ChatBox CRM + Chat + Attribution

CREATE TABLE tenants (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  api_key VARCHAR(64) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant_id INT NOT NULL,
  email VARCHAR(190) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('user','manager') DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (tenant_id) REFERENCES tenants(id)
);

CREATE TABLE owners (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(190) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pipelines (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (tenant_id) REFERENCES tenants(id)
);

CREATE TABLE stages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant_id INT NOT NULL,
  pipeline_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (tenant_id) REFERENCES tenants(id),
  FOREIGN KEY (pipeline_id) REFERENCES pipelines(id)
);

CREATE TABLE contacts (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  tenant_id INT NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  email VARCHAR(190),
  phone VARCHAR(32),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (tenant_id) REFERENCES tenants(id)
);

CREATE TABLE companies (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  tenant_id INT NOT NULL,
  name VARCHAR(190) NOT NULL,
  domain VARCHAR(190),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (tenant_id) REFERENCES tenants(id)
);

CREATE TABLE deals (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  tenant_id INT NOT NULL,
  title VARCHAR(190) NOT NULL,
  value DECIMAL(12,2) DEFAULT 0,
  stage_id INT NOT NULL,
  owner_id INT,
  contact_id BIGINT,
  company_id BIGINT,
  status ENUM('open','won','lost') DEFAULT 'open',
  lead_status ENUM('new','qualified','converted','disqualified') DEFAULT 'new',
  qualified_at DATETIME NULL,
  converted_at DATETIME NULL,
  disqualified_at DATETIME NULL,
  disqualify_reason TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (tenant_id) REFERENCES tenants(id),
  FOREIGN KEY (stage_id) REFERENCES stages(id),
  FOREIGN KEY (owner_id) REFERENCES users(id),
  FOREIGN KEY (contact_id) REFERENCES contacts(id),
  FOREIGN KEY (company_id) REFERENCES companies(id)
);

CREATE TABLE activities (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  tenant_id INT NOT NULL,
  deal_id BIGINT,
  contact_id BIGINT,
  owner_id INT,
  type ENUM('call','email','meeting','task') NOT NULL,
  subject VARCHAR(190),
  due_at DATETIME,
  completed TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (tenant_id) REFERENCES tenants(id),
  FOREIGN KEY (deal_id) REFERENCES deals(id),
  FOREIGN KEY (contact_id) REFERENCES contacts(id),
  FOREIGN KEY (owner_id) REFERENCES users(id)
);

CREATE TABLE notes (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  tenant_id INT NOT NULL,
  deal_id BIGINT,
  contact_id BIGINT,
  body TEXT NOT NULL,
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (tenant_id) REFERENCES tenants(id),
  FOREIGN KEY (deal_id) REFERENCES deals(id),
  FOREIGN KEY (contact_id) REFERENCES contacts(id),
  FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE attachments (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  tenant_id INT NOT NULL,
  deal_id BIGINT,
  contact_id BIGINT,
  path VARCHAR(255) NOT NULL,
  mime_type VARCHAR(100),
  size_bytes INT,
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (tenant_id) REFERENCES tenants(id),
  FOREIGN KEY (deal_id) REFERENCES deals(id),
  FOREIGN KEY (contact_id) REFERENCES contacts(id),
  FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE conversations (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  tenant_id INT NOT NULL,
  contact_email VARCHAR(190),
  contact_phone VARCHAR(32),
  allow_anonymous TINYINT(1) DEFAULT 0,
  lead_status ENUM('new','qualified','converted','disqualified') DEFAULT 'new',
  qualified_at DATETIME NULL,
  converted_at DATETIME NULL,
  disqualified_at DATETIME NULL,
  disqualify_reason TEXT,
  gclid VARCHAR(190),
  fbclid VARCHAR(190),
  utm_source VARCHAR(100),
  utm_medium VARCHAR(100),
  utm_campaign VARCHAR(100),
  utm_term VARCHAR(100),
  utm_content VARCHAR(100),
  referrer VARCHAR(255),
  landing_page VARCHAR(255),
  status ENUM('open','closed') DEFAULT 'open',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (tenant_id) REFERENCES tenants(id)
);

CREATE TABLE messages (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  conversation_id BIGINT NOT NULL,
  sender ENUM('user','agent') NOT NULL,
  agent_id INT,
  body TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (conversation_id) REFERENCES conversations(id),
  FOREIGN KEY (agent_id) REFERENCES users(id)
);

CREATE TABLE custom_fields (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenant_id INT NOT NULL,
  entity ENUM('deal','contact','company') NOT NULL,
  name VARCHAR(100) NOT NULL,
  field_key VARCHAR(100) NOT NULL,
  type ENUM('text','number','date','select','multiselect','boolean') NOT NULL,
  options TEXT NULL,
  required TINYINT(1) DEFAULT 0,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (tenant_id) REFERENCES tenants(id),
  UNIQUE KEY unique_field_key (tenant_id, entity, field_key)
);

CREATE TABLE custom_field_values (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  field_id INT NOT NULL,
  entity ENUM('deal','contact','company') NOT NULL,
  entity_id BIGINT NOT NULL,
  value TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (field_id) REFERENCES custom_fields(id),
  INDEX idx_entity (entity, entity_id)
);

