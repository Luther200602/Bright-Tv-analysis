SELECT*
FROM `workspace`.`default`.`viewership_dataset` AS A
LEFT JOIN `workspace`.`default`.`bright_tv_dataset` AS B
ON A.UserID0 = B.UserID;
---------------------------------------------------------------------------
SELECT DISTINCT UserID0 AS Total_Users
FROM `workspace`.`default`.`viewership_dataset` AS A
LEFT JOIN `workspace`.`default`.`bright_tv_dataset` AS B
ON A.UserID0 = B.UserID;
--------------------------------------------------------------------
---checking oldest record
-----------------------------------------------------------------------

SELECT MIN(RecordDate2) AS Oldest_Record
FROM `workspace`.`default`.`viewership_dataset` AS A
FULL OUTER JOIN `workspace`.`default`.`bright_tv_dataset` AS B
ON A.UserID0 = B.UserID;
-- oldest record its from 2016-01-01

-------------------------------------------------------------------------
-- latest record 
---------------------------------------------------------------------------
SELECT MAX(RecordDate2) AS Latest_Record
FROM `workspace`.`default`.`viewership_dataset` AS A
FULL OUTER JOIN `workspace`.`default`.`bright_tv_dataset` AS B
ON A.UserID0 = B.UserID;
-- latest record its 2016-03-31
--------------------------------------------------------------------------
-- checking how many channels we have
----------------------------------------------------------------------------
SELECT DISTINCT Channel2 AS different_channels
FROM `workspace`.`default`.`viewership_dataset` AS A
FULL OUTER JOIN `workspace`.`default`.`bright_tv_dataset` AS B
ON A.UserID0 = B.UserID;

-------------------------------------------------------------------------
-- checking age
-----------------------------------------------------------------------------
SELECT MIN(Age) AS youngest_age
FROM `workspace`.`default`.`viewership_dataset` AS A
FULL OUTER JOIN `workspace`.`default`.`bright_tv_dataset` AS B
ON A.UserID0 = B.UserID;
-- YOUNGEST ITS 0

SELECT MAX(Age) AS oldest_age
FROM `workspace`.`default`.`viewership_dataset` AS A
FULL OUTER JOIN `workspace`.`default`.`bright_tv_dataset` AS B
ON A.UserID0 = B.UserID;
-- oldest its 114
------------------------------------------------------------------------------
-- Changing time
------------------------------------------------------------------------------
SElECT RecordDate2,
       DATEADD(HOUR,2,RecordDate2) AS RecordDate2_SA_Time,
             CAST(DATEADD(HOUR,2,RecordDate2) AS DATE) AS RecordDate2_SA_Date
FROM `workspace`.`default`.`viewership_dataset`;

SELECT UserID0, Channel2, Gender, Race, Age, Province, RecordDate2,
from_utc_timestamp(RecordDate2, 'Africa/Johannesburg') AS SA_time
FROM `workspace`.`default`.`viewership_dataset` AS A
FULL OUTER JOIN `workspace`.`default`.`bright_tv_dataset` AS B
ON A.UserID0 = B.UserID;

-----------------------------------------------------------------------------
-- changing time from UTC to SA time
-------------------------------------------------------------------------------
SELECT UserID, Channel2, Gender, Race, Age, Province, RecordDate2,
convert_timezone('UTC', 'Africa/Johannesburg', RecordDate2) AS SA_Time_SAST
FROM `workspace`.`default`.`viewership_dataset` AS A
FULL OUTER JOIN `workspace`.`default`.`bright_tv_dataset` AS B
ON A.UserID0 = B.UserID;

SELECT RecordDate2,
from_utc_timestamp(RecordDate2, 'Africa/Johannesburg') AS SA_time
FROM `workspace`.`default`.`viewership_dataset` AS A
FULL OUTER JOIN `workspace`.`default`.`bright_tv_dataset` AS B
ON A.UserID0 = B.UserID;
------------------------------------------------------------------
------------------------------------------------------------------
SELECT UserID, Channel2, RecordDate2, Race, Gender, Age, Province,
Dayname(RecordDate2) AS Day_name, Monthname(RecordDate2) AS Month_name, Dayofmonth(RecordDate2) AS Day_of_month,
 
 CASE
     WHEN date_format(RecordDate2,'HH:mm:ss') BETWEEN '05:00:00' AND '07:59:00' THEN 'early morning'
     WHEN date_format(RecordDate2,'HH:mm:ss')BETWEEN '08:00:00' AND '10:59:00' THEN 'morning rush' 
     WHEN date_format(RecordDate2,'HH:mm:ss') BETWEEN'11:00:00' AND '13:59:00' THEN 'late morning' 
     WHEN date_format(RecordDate2,'HH:mm:ss') BETWEEN '14:00:00' AND '16:59:00' THEN 'afternoon' 
     WHEN date_format(RecordDate2,'HH:mm:ss') BETWEEN'17:00:00' AND '19:59:00' THEN 'Evening start'  
     ELSE 'night' 
 END AS TV_time_intervals,

CASE
    WHEN(Age) <=2 THEN 'Infancy'
    WHEN(Age) BETWEEN 3 AND 8 THEN 'Early Childhood'
    WHEN(Age) BETWEEN 9 AND 12 THEN 'Later Childhood'
    WHEN(Age) BETWEEN 13 AND 18 THEN 'Adolescence'
    WHEN(Age) BETWEEN 19 AND 39 THEN 'Early Adulthood'
    WHEN(Age) BETWEEN 40 AND 59 THEN 'Middle Adulthood'
    WHEN(Age) BETWEEN 60 AND 79 THEN 'Late Adulthood'
    ELSE 'OLDEST'
    END AS Age_Basket,

CASE 
    WHEN Dayname(RecordDate2) IN ('Sunday','Saturday') THEN'Weekend' ELSE 'Weekday' END AS day_classification,
--------------Changing time-------------------

 DATEADD(HOUR,2,RecordDate2) AS RecordDate2_SA_Time
             CAST(DATEADD(HOUR,2,RecordDate2) AS DATE) AS RecordDate2_SA_Date,
       ROW_NUMBER() OVER(ORDER BY t1.1D) AS countingColumn,
        t1.*,
        t2
             
FROM `workspace`.`default`.`viewership_dataset` AS A
LEFT JOIN `workspace`.`default`.`bright_tv_dataset` AS B
