WITH travel(depTime, arrival, arrTime, price, cnt, route) AS
(
    (SELECT depTime, arrival, arrTime, price, 1, 
    cast(departure || '-' || fNo || '->' || arrival AS VARCHAR(60))
    FROM flights
    WHERE departure = 'LBC')
UNION ALL
    (SELECT depTime, arrival, arrTime, price, 1, 
    cast(departure || '-' || tNo || '->' || arrival AS VARCHAR(60))
    FROM rail
    WHERE departure = 'LBC')
UNION ALL
    (SELECT t.depTime, f.arrival, f.arrTime, t.price + f.price, t.cnt + 1, 
    cast(t.route || '-' || f.fNo || '->' || f.arrival AS VARCHAR(60))
    FROM travel t, flights f
    WHERE t.arrival = f.departure
        AND t.arrival <> 'LBC'
        AND f.departure <> 'ALC'
        AND t.arrTime < f.depTime
        AND t.cnt < 4)
UNION ALL
    (SELECT t.depTime, r.arrival, r.arrTime, t.price + r.price, t.cnt + 1, 
    cast(t.route || '-' || r.tNo || '->' || r.arrival AS VARCHAR(60))
    FROM travel t, rail r
    WHERE t.arrival = r.departure
        AND t.arrival <> 'LBC'
        AND r.departure <> 'ALC'
        AND t.arrTime < r.depTime
        AND t.cnt < 4)
)

SELECT DISTINCT depTime, arrTime, timestampdiff(8, arrTime-depTime) AS travelTime, price, cnt, route
FROM travel
WHERE arrival = 'ALC'; 

    
    