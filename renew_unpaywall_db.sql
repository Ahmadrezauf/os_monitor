DELETE FROM oa.unpaywall;

ALTER TABLE oa.unpaywall DROP CONSTRAINT unpaywall_pkey;

CREATE TEMPORARY TABLE unpaywall_copy_2 as (SELECT * FROM oa.unpaywall LIMIT 0);
CREATE TEMPORARY TABLE unpaywall_copy as (SELECT * FROM oa.unpaywall LIMIT 0);

COPY unpaywall_copy_2 FROM '/home/loca/snapshot_unpaywall_261120.csv'
DELIMITER ' ';
/* Remove dublicates */
INSERT INTO unpaywall_copy(doi, oa_status)
SELECT
    DISTINCT ON (doi) doi,
    oa_status
FROM unpaywall_copy_2;

DROP TABLE unpaywall_copy_2;


INSERT INTO oa.unpaywall (doi, oa_status)
SELECT doi,oa_status
FROM unpaywall_copy;

DROP TABLE unpaywall_copy;

ALTER TABLE oa.unpaywall ADD PRIMARY KEY (doi);

