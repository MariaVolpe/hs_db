-- School equals zip code given by user
-- example post code searches
-- where postcode is equal to given
SELECT
    CASE WHEN LENGTH(school_name) > 32
        THEN CONCAT(SUBSTRING(school_name, 1, 32), '...')
        ELSE school_name END AS school_name,
    dbn,
    postcode
FROM Schools
WHERE postcode = 10016;

-- where postcode is near given
SELECT
    CASE WHEN LENGTH(school_name) > 32
        THEN CONCAT(SUBSTRING(school_name, 1, 32), '...')
        ELSE school_name END AS school_name,
    dbn,
    postcode
FROM Schools
WHERE 10016-10 < postcode AND postcode < 10016+10
ORDER BY postcode - 10016 ASC;

-- Sort school on average SAT score.
SELECT
    CASE WHEN LENGTH(b.school_name) > 32
        THEN CONCAT(SUBSTRING(b.school_name, 1, 32), '...')
        ELSE b.school_name END AS school_name,
    B.dbn,
    avg_sat_math_score,
    avg_sat_reading_writing_score,
    avg_sat_math_score+(avg_sat_reading_writing_score*2) AS avg_total_sat_score
FROM School_performances AS A
JOIN Schools AS B
    ON A.dbn = B.dbn
WHERE avg_sat_math_score IS NOT NULL
    AND avg_sat_reading_writing_score IS NOT NULL
ORDER BY avg_total_sat_score DESC;

-- sort schools by highest ACT and SAT
SELECT
    CASE WHEN LENGTH(b.school_name) > 60
        THEN CONCAT(SUBSTRING(b.school_name, 1, 60), '...')
        ELSE b.school_name END AS school_name,
    B.dbn,
    avg_sat_math_score+(avg_sat_reading_writing_score*2) AS total_sat_score,
    (avg_act_english_score+avg_act_math_score+avg_act_reading_score+avg_act_science_score)/4
        AS total_act_score
FROM School_performances AS A
JOIN Schools AS B
    ON A.dbn = B.dbn
WHERE avg_sat_math_score IS NOT NULL
    AND avg_act_english_score IS NOT NULL
ORDER BY total_sat_score+total_act_score DESC;

-- Sort school on average ACT score
SELECT
    CASE WHEN LENGTH(b.school_name) > 32
        THEN CONCAT(SUBSTRING(b.school_name, 1, 32), '...')
        ELSE b.school_name END AS school_name,
    b.dbn,
    avg_act_english_score AS avg_english,
    avg_act_math_score AS avg_math,
    avg_act_reading_score AS avg_reading,
    avg_act_science_score AS avg_science,
    (avg_act_english_score+avg_act_math_score+avg_act_reading_score+avg_act_science_score)/4 AS total_act_score
FROM School_performances AS A
JOIN Schools AS B
    ON A.dbn = B.dbn
WHERE avg_act_english_score IS NOT NULL
    OR avg_act_math_score IS NOT NULL
    OR avg_act_reading_score IS NOT NULL
    OR avg_act_science_score IS NOT NULL
ORDER BY total_act_score DESC;

-- sort schools by smallest class size
SELECT 
    CASE WHEN LENGTH(b.school_name) > 32
        THEN CONCAT(SUBSTRING(b.school_name, 1, 32), '...')
        ELSE b.school_name END AS school_name,
    b.dbn,
    avg_class_size
FROM Class_sizes AS A
JOIN Schools AS B
    ON A.dbn = B.dbn
ORDER BY avg_class_size ASC
LIMIT 30;

-- sort by highest SAT scores of closest by zipcode
SELECT 
    CASE WHEN LENGTH(school_name) > 32
        THEN CONCAT(SUBSTRING(school_name, 1, 32), '...')
        ELSE school_name END AS school_name,
    A.dbn,
    postcode,
    avg_sat_math_score AS avg_math,
    avg_sat_reading_writing_score AS avg_r_w,
    avg_sat_math_score+(avg_sat_reading_writing_score*2) AS avg_total_sat_score
FROM Schools AS A
JOIN School_performances AS B
    ON A.dbn = B.dbn
WHERE 10016-10 < postcode AND postcode < 10016+10
ORDER BY avg_total_sat_score DESC;

-- Find schools within a given size of school
-- MAX(total_students) = 5682
-- MIN(total_students) = 105
-- AVG(total_students) = ~699
-- therefore
-- small school: 100-1000 students
-- medium school: 1000-3000 students
-- large school: 3000-6000 students
SELECT 
    CASE WHEN LENGTH(school_name) > 32
        THEN CONCAT(SUBSTRING(school_name, 1, 32), '...')
        ELSE school_name END AS school_name,
    dbn,
    total_students
FROM Schools
-- small
WHERE 100 <= total_students AND total_students <= 1000
ORDER BY total_students DESC;

-- medium
SELECT 
    CASE WHEN LENGTH(school_name) > 32
        THEN CONCAT(SUBSTRING(school_name, 1, 32), '...')
        ELSE school_name END AS school_name,
    dbn,
    total_students
FROM Schools
-- small
WHERE 1000 < total_students AND total_students <= 3000
ORDER BY total_students DESC;
-- large
SELECT 
    CASE WHEN LENGTH(school_name) > 32
        THEN CONCAT(SUBSTRING(school_name, 1, 32), '...')
        ELSE school_name END AS school_name,
    dbn,
    total_students
FROM Schools
-- small
WHERE 3000 < total_students
ORDER BY total_students DESC;

-- search by bus or subway
-- example: m16
SELECT
    CASE WHEN LENGTH(school_name) > 32
        THEN CONCAT(SUBSTRING(school_name, 1, 32), '...')
        ELSE school_name END AS school_name,
    dbn,
    bus
FROM Schools
WHERE bus LIKE '%M11%';

-- or subway
-- example: 6 line
SELECT
    CASE WHEN LENGTH(school_name) > 25
        THEN CONCAT(SUBSTRING(school_name, 1, 25), '...')
        ELSE school_name END AS school_name,
    subway
FROM Schools
WHERE subway LIKE '%6%';