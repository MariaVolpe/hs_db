DROP DATABASE High_schools;

CREATE DATABASE IF NOT EXISTS High_schools
DEFAULT CHARACTER SET utf8
DEFAULT COLLATE utf8_bin;

USE High_schools;

-- loading all columns w/o skipping because the data
-- we will keep may change in future
CREATE TABLE Schools
(
    dbn char(6),
    school_name varchar(100),
    boro varchar(1),
    location varchar(180),
    phone_number char(12),
    fax_number char(12),
    school_email varchar(50),
    website varchar(75),
    subway varchar(200),
    bus text,
    total_students int(5),
    start_time varchar(6),
    end_time varchar(6),
    graduation_rate decimal(4,2),
    college_career_rate decimal(4,2),
    primary_address_line_1 varchar(50),
    city varchar(20),
    postcode int(5),
    state_code char(2),
    borough varchar(20),
    latitude varchar(12),
    longitude varchar(12),
    community_board int(3) DEFAULT 0,
    counsel_district int(3) DEFAULT 0,
    census_tract int(3) DEFAULT 0,
    BIN varchar(8),
    BBL varchar(15),
    NTA varchar(100)
);

LOAD DATA LOCAL INFILE 'data/2018_DOE_High_School_Directory.csv'
INTO TABLE Schools
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
IGNORE 1 LINES;

CREATE TABLE School_performance_temp
(
    dbn char(6),
    school_name varchar(100),
    percent_graduated_level_one varchar(7),
    percent_graduated_level_two varchar(7),
    percent_graduated_level_three_four varchar(7),
    avg_act_english_score decimal(3, 1),
    avg_act_math_score decimal(3, 1),
    avg_act_reading_score decimal(3, 1),
    avg_act_science_score decimal(3, 1),
    avg_sat_math_score decimal(4, 1),    
    avg_sat_reading_writing_score decimal(4, 1),
    eid int NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (eid)
);

-- this will warn that the file does not have data to fill all columns
-- this is because of the added eid field and is safe to ignore
LOAD DATA LOCAL INFILE 'data/201718_hs_sqr_results.csv'
INTO TABLE School_performance_temp
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
IGNORE 1 LINES;

CREATE TABLE Class_sizes
(
    dbn char(6),
    school_name varchar(100),
    grade_level char(7),
    program_type varchar(15),
    department varchar(15),
    subject varchar(50),
    num_students int,
    num_classes int,
    avg_class_size decimal(4,1),
    cid int NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (cid)
);

-- this will warn that the file does not have data to fill all columns
-- this is because of the added cid field and is safe to ignore
LOAD DATA LOCAL INFILE 'data/2015_-_2016_Final_Class_Size_Report_Middle___High_School.tsv'
INTO TABLE Class_sizes
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
IGNORE 1 LINES;

-- delete middle school records  
DELETE FROM Class_sizes
WHERE grade_level='MS Core';

-- delete unused columns
ALTER TABLE Schools
DROP boro,
DROP community_board,
DROP counsel_district,
DROP census_tract,
DROP BIN,
DROP BBL,
DROP NTA,
DROP latitude,
DROP longitude,
DROP city,
DROP fax_number,
DROP location;

ALTER TABLE School_performance_temp
DROP school_name,
DROP percent_graduated_level_one,
DROP percent_graduated_level_two,
DROP percent_graduated_level_three_four;

ALTER TABLE Class_sizes
DROP school_name,
DROP grade_level,
DROP program_type,
DROP subject;

-- strip out 0 values (which were inserted b/c of
-- non numerical characters being used to indicate
-- missing information in source data set)
UPDATE School_performance_temp
SET avg_act_english_score = NULL
WHERE avg_act_english_score = 0;

UPDATE School_performance_temp
SET avg_act_math_score = NULL
WHERE avg_act_math_score = 0;

UPDATE School_performance_temp
SET avg_act_reading_score = NULL
WHERE avg_act_reading_score = 0;

UPDATE School_performance_temp
SET avg_act_science_score = NULL
WHERE avg_act_science_score = 0;

UPDATE School_performance_temp
SET avg_sat_math_score = NULL
WHERE avg_sat_math_score = 0;

UPDATE School_performance_temp
SET avg_sat_reading_writing_score = NULL
WHERE avg_sat_reading_writing_score = 0;