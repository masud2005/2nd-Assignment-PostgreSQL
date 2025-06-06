-- Active: 1748186750108@@127.0.0.1@5432@conservation_db

--creating table rangers
CREATE TABLE rangers (
    ranger_id INT PRIMARY KEY,
    name VARCHAR(30),
    region VARCHAR(20)
);

--creating table species
CREATE TABLE species (
    species_id int PRIMARY KEY,
    common_name VARCHAR(30),
    scientific_name VARCHAR(30),
    discovery_date DATE,
    conservation_status VARCHAR(20)
)

--creating table sightings
CREATE TABLE sightings (
    sighting_id INT PRIMARY KEY,
    ranger_id int REFERENCES rangers (ranger_id),
    species_id int REFERENCES species (species_id),
    sighting_time TIMESTAMP WITHOUT TIME ZONE,
    location VARCHAR(20),
    notes TEXT
)

--inserting data into rangers table
INSERT INTO
    rangers (ranger_id, name, region)
VALUES (
        1,
        'Alice Green',
        'Northern Hills'
    ),
    (2, 'Bob White', 'River Delta'),
    (
        3,
        'Carol King',
        'Mountain Range'
    );

--inserting into species table
INSERT INTO
    species (
        species_id,
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        1,
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        2,
        'Bengal Tiger',
        'Panthera tigris tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        3,
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        4,
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    );

--inserting into sightings table
INSERT INTO
    sightings (
        sighting_id,
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        4,
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        NULL
    );

-- view all tables
-- SELECT * FROM rangers;
-- SELECT * FROM sightings;
-- SELECT * FROM species;

-- 1. Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers (ranger_id, name, region)
    VALUES (4, 'Derek Fox', 'Coastal Plains');

-- 2. Count unique species ever sighted.
SELECT count(DISTINCT species_id) AS unique_species_count
    FROM sightings;

-- 3. Find all sightings where the location includes "Pass".
SELECT * FROM sightings WHERE location LIKE '%Pass%';

-- 4. List each ranger's name and their total number of sightings.
SELECT name, count(*) AS total_sightings
    FROM rangers
    JOIN sightings ON rangers.ranger_id = sightings.ranger_id
    GROUP BY name
    ORDER BY name ASC;

-- 5. List species that have never been sighted.
SELECT common_name
    FROM species
    LEFT JOIN sightings ON species.species_id = sightings.species_id
    WHERE sighting_id IS NULL;

