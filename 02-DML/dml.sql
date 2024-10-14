CREATE TABLE coaches (
    coach_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(200) NOT NULL,
    last_name VARCHAR(200),
    salary DECIMAL(10, 2) NOT NULL DEFAULT 0,
    email VARCHAR(500) NOT NULL
) engine = innodb;

-- INSERT INTO: add a new row
-- INSERT INTO (<col1>, <col2>...) VALUES (<value1>, <value2>...)
INSERT INTO coaches (first_name ,email ) VALUES ("David", "david@swimcoaches.com");


-- Insert many
INSERT INTO coaches (first_name, last_name, salary, email)
 VALUES ("Tony", "Stark", 3000, "tonystark@swimcoaches.com"),
        ("Peter", NULL, 4000, "peterparker@swimcoaches.com"),
        ("Eddard", "Stark", 4500, "eddard@swimcoaches.com");

-- UPDATE : update an existing row
-- UPDATE <table> SET COL1=VAL1, COL2=VAL2.... WHERE 
-- If no `WHERE` it will update all the ROWS
UPDATE coaches SET salary=30000 WHERE coach_id = 5;

-- update multiple rows at the same time 
-- if the WHERE clause matches multiple rows
-- eg. all coaches that are paid less than 5000 
-- get a 10% pay increment
UPDATE coaches SET salary=salary*1.1 WHERE salary < 5000;

-- if your intention is to change a single column, THEN
-- always use the PRIMARY KEY in WHERE clause
UPDATE coaches SET last_name="Park", email="peterpark@swimcoaches.com" 
    WHERE coach_id = 6;


-- DELETE FROM: delete an existing row
DELETE FROM coaches WHERE coach_id = 7;

INSERT INTO coaches (first_name, email) VALUES ("John", "johnwick@asd.com");