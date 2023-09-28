/* QUestion: A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it.
You vaguely remember that the crime was a murder that occurred sometime on Jan.15, 2018 and that it took place in SQL City
Start by retrieving the corresponding crime scene report from the police department’s database.*/
-- Search for the crime scene report on the day of the murder. we filter by city and date
SELECT *
FROM crime_scene_report
WHERE city = 'SQL City' AND date = '20180115';
-- Security footage shows that there were 2 witnesses. 
-- The first witness lives at the last house on ""Northwestern Dr"". 
-- The second witness, named Annabel, lives somewhere on ""Franklin Ave""."	SQL City

SELECT *
FROM person
WHERE address_street_name LIKE 'Northwestern Dr%'
ORDER BY address_number DESC
LIMIT 1;

SELECT *
FROM person
WHERE name LIKE 'Annabel%' AND address_street_name = 'Franklin Ave';

/* Our first witness is Morty scorpio with person id 14887
our second witness is Annabel with person id 16371. we can link their id to an interview they did */

SELECT  person.name, person.id, inv. transcript
FROM interview AS inv
JOIN person 
ON person.id = inv.person_id
WHERE person_id = 14887 or person_id = 16371;

/* Our first eye witness morty heard a gunshot and then saw a man run out. 
The suspect had a ""Get Fit Now Gym"" bag. 
The membership number on the bag started with ""48Z"" for gold members.
The man got into a car with a plate that included ""H42W""."

Our second eye witness, Annabel saw the murder happen
she recognized the killer from her gym. suspect was at the gym on the 9th january */

SELECT *
FROM get_fit_now_member AS GFM
JOIN get_fit_now_check_in AS GFC
ON GFM.id = GFC.membership_id
WHERE membership_status = 'gold' AND GFM.id LIKE '48Z%' AND check_in_date = 20180109;

-- After combining the characteristics from bothg our eye witnesses it led to us to two possible suspects 
-- joe Germuska and Jeremey Bowers

/* we have part of the murders plate number and we know he his male.crime_scene_report
- we would combine the drivers liscense table to the person table to his the liscenese plates through the names*/

SELECT *
FROM drivers_license
JOIN person
ON drivers_license.id = person.license_id
WHERE plate_number LIKE '%H42W%' AND gender = 'male';

-- and we have two suspects:
-- Tushar Chandra and Jeremy Bowers

/* After cross referencing the two details, the nail that appaers in both is Jeremy Bowerscrime_scene_report
Therefore, Jeremy committed the murder.
we are going to go a step further and look into the interview data base for his interrogation. */

SELECT *
FROM interview
WHERE person_id = 67318;

/* Jeremey said he was hired by a woman with a lot of money. 
he doesn't know her name but her height is around 5'5"" (65"") or 5'7"" (67""). 
She has red hair and she drives a Tesla Model S. 
she attended the SQL Symphony Concert 3 times in December 2017. */
-- Next step is to find run the details on the license database and join to person table

SELECT *
FROM person
JOIN drivers_license
ON person.license_id = drivers_license.id
WHERE hair_color = 'red' AND car_make = 'Tesla' AND gender = 'female';

/* After running the details through, we have three suspect. 
we need to run it across and find who attends the sql symphony event three times.
To make it more straighforward, i decided to join three tables: the facebook checkin table , the person table and the drivers license table
This way i run the woman's features through the kisence table, i get her name from the person table and i seee the evnts she attends from the facebook event table */

SELECT person.name, person. address_number, person. address_street_name, person.ssn 
FROM person 
JOIN facebook_event_checkin as fbc
ON fbc.person_id = person.id 
JOIN drivers_license
ON person.license_id = drivers_license.id
WHERE date LIKE '201712%' AND event_name LIKE 'SQL%' and hair_color = 'red' and car_make = 'Tesla' AND gender = 'female'
GROUP by person.name
HAVING count(*) = 3



/* st the end, we see that the actaul mastermind behind the crime is Miranda Priestly, as she hired Jeremy Bowers to commit the crime */