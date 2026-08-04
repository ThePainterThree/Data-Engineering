-- NYC Taxi questions
-- 1-Find the average fare_amount and trip_distance overall.
SELECT avg(fare_amount), avg(trip_distance)
FROM samples.nyctaxi.trips;

-- 2-Count total trips per day.
SELECT pickup_zip, COUNT(*) AS total_trips
FROM  samples.nyctaxi.trips
GROUP BY pickup_zip
ORDER BY total_trips DESC;

-- 3-Find the top 10 pickup zip codes by number of trips.
SELECT pickup_zip, COUNT(*) AS total_trips
FROM samples.nyctaxi.trips
GROUP BY pickup_zip
ORDER BY total_trips DESC
LIMIT 10;

-- 4-Find the longest and shortest trips by distance.
SELECT
    MAX(trip_distance) AS longest_trip,
    MIN(trip_distance) AS shortest_trip
FROM samples.nyctaxi.trips
WHERE trip_distance > 0;

--5. Calculate average fare by hour of day (extract hour from tpep_pickup_datetime) to find peak pricing times.
SELECT EXTRACT(HOUR FROM tpep_pickup_datetime) AS hour_of_day, ROUND(AVG(fare_amount), 2) AS avg_fare
FROM samples.nyctaxi.trips
GROUP BY hour_of_day
ORDER BY avg_fare DESC;

-- 6. Compute trip duration (dropoff - pickup) and find its correlation with fare_amount.
SELECT EXTRACT(HOUR FROM tpep_dropoff_datetime - tpep_pickup_datetime) AS trip_duration, 
    AVG(fare_amount) AS avg_fare
FROM samples.nyctaxi.trips
GROUP BY trip_duration
ORDER BY avg_fare DESC;

-- 7. Find the busiest pickup zip → dropoff zip pairs (top routes by trip count).
SELECT pickup_zip, dropoff_zip, COUNT(*) AS total_trips
FROM samples.nyctaxi.trips
GROUP BY pickup_zip, dropoff_zip
ORDER BY total_trips DESC;

-- 8. Flag anomalies: trips with trip_distance = 0 but fare_amount > 0, or very high fare-per-mile.
SELECT pickup_zip, dropoff_zip, trip_distance, fare_amount
FROM samples.nyctaxi.trips
WHERE trip_distance = 0 AND fare_amount > 0 OR trip_distance > 0 AND fare_amount / trip_distance > 100;

-- 9. Compare weekday vs weekend average trip volume and fares.
SELECT CASE WHEN EXTRACT(DOW FROM tpep_pickup_datetime) BETWEEN 1 AND 5 THEN 'weekday' ELSE 'weekend' END AS day_type, COUNT(*) AS total_trips, AVG(fare_amount) AS avg_fare
FROM samples.nyctaxi.trips
GROUP BY day_type
ORDER BY total_trips DESC;

-- Advanced
-- 10. Use a window function to rank zip codes by daily trip count and find each day's top pickup zone.
SELECT pickup_zip, EXTRACT(DOW FROM tpep_pickup_datetime) AS day_of_week, RANK() OVER (PARTITION BY EXTRACT(DOW FROM tpep_pickup_datetime) ORDER BY COUNT(*) DESC) AS rank
FROM samples.nyctaxi.trips
GROUP BY pickup_zip, EXTRACT(DOW FROM tpep_pickup_datetime)
ORDER BY day_of_week, rank
LIMIT 10;

-- 11. Build an hourly heatmap query: trips grouped by hour and day_of_week (useful later for a chart).
SELECT EXTRACT(HOUR FROM tpep_pickup_datetime) AS hour_of_day, EXTRACT(DOW FROM tpep_pickup_datetime) AS day_of_week, COUNT(*) AS total_trips
FROM samples.nyctaxi.trips
GROUP BY EXTRACT(HOUR FROM tpep_pickup_datetime), EXTRACT(DOW FROM tpep_pickup_datetime)
ORDER BY EXTRACT(DOW FROM tpep_pickup_datetime), EXTRACT(HOUR FROM tpep_pickup_datetime);

-- 12. Calculate a rolling 7-day average of daily fare revenue using AVG() OVER (ORDER BY ... ROWS BETWEEN 6 PRECEDING AND CURRENT ROW).
SELECT dayofyear(tpep_pickup_datetime) AS day_of_year, AVG(fare_amount) OVER (ORDER BY dayofyear(tpep_pickup_datetime) ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg_fare
FROM samples.nyctaxi.trips;

-- 13. Identify outlier trips using standard deviation (e.g., fares more than 3 std devs from the mean).
SELECT pickup_zip, dropoff_zip, trip_distance, fare_amount
FROM samples.nyctaxi.trips
WHERE fare_amount > (SELECT AVG(fare_amount) + 3 * STDDEV(fare_amount) FROM samples.nyctaxi.trips);
