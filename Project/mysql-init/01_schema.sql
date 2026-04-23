-- ═══════════════════════════════════════════════════
-- JobFinder Pro — Auto Database Setup
-- Runs automatically when MySQL container first starts
-- ═══════════════════════════════════════════════════

USE jobfinder_db;

CREATE TABLE IF NOT EXISTS users (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(150) NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,
    role       ENUM('seeker','recruiter','admin') DEFAULT 'seeker',
    skills     TEXT,
    location   VARCHAR(100),
    streak     INT DEFAULT 0,
    level      INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS jobs (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    title        VARCHAR(200) NOT NULL,
    company      VARCHAR(150) NOT NULL,
    salary_min   DECIMAL(10,2),
    salary_max   DECIMAL(10,2),
    location     VARCHAR(100),
    description  TEXT,
    skills_req   TEXT,
    job_type     ENUM('full-time','part-time','remote','internship') DEFAULT 'full-time',
    recruiter_id INT,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (recruiter_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS applications (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    job_id     INT NOT NULL,
    status     ENUM('applied','viewed','shortlisted','rejected','hired') DEFAULT 'applied',
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (job_id)  REFERENCES jobs(id)  ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS resumes (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL UNIQUE,
    file_path   VARCHAR(300),
    score       INT DEFAULT 0,
    suggestions TEXT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS messages (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    sender_id   INT NOT NULL,
    receiver_id INT NOT NULL,
    content     TEXT NOT NULL,
    is_read     BOOLEAN DEFAULT FALSE,
    sent_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id)   REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS notifications (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    message    TEXT NOT NULL,
    type       ENUM('match','update','message','system') DEFAULT 'system',
    is_read    BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS saved_jobs (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    user_id  INT NOT NULL,
    job_id   INT NOT NULL,
    saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (job_id)  REFERENCES jobs(id)  ON DELETE CASCADE
);

-- ─── Seed test users ──────────────────────────────
INSERT IGNORE INTO users (name, email, password, role, skills, location) VALUES
('Arjun Sharma',   'arjun@gmail.com',    'pass123', 'seeker',    'Java,React,MySQL', 'Bangalore'),
('Priya Mehta',    'priya@techcorp.com', 'pass123', 'recruiter', NULL,               'Mumbai'),
('Admin User',     'admin@jobfinder.com','pass123', 'admin',     NULL,               'Delhi');

-- ─── Seed test jobs ───────────────────────────────
INSERT IGNORE INTO jobs (title,company,salary_min,salary_max,location,description,skills_req,job_type,recruiter_id) VALUES
('Senior Java Developer', 'TechCorp India', 1800000,2600000,'Bangalore','Build scalable backend systems.','Java,Spring Boot,MySQL','full-time',2),
('UI/UX Designer',        'DesignStudio',   1400000,2000000,'Remote',   'Design modern interfaces.',     'Figma,Adobe XD,CSS',   'remote',   2),
('React Developer',       'StartupHub',     1200000,1800000,'Pune',     'Build front-end features.',     'React,JavaScript',     'full-time',2),
('Data Scientist',        'DataWorks',      2000000,3000000,'Delhi',    'Build ML models.',              'Python,TensorFlow',    'full-time',2),
('DevOps Engineer',       'CloudBase',      2200000,3200000,'Remote',   'Manage CI/CD pipelines.',       'AWS,Docker,Kubernetes','remote',   2);