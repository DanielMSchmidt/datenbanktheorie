WITH REISEN(Ziel, Endposition, Route, Plan, Anzteilstr, Gesamtkosten) AS
	(
		(SELECT 
			departure, 
			arrival,
			cast(departure AS VARCHAR(60)), 
			cast(fNo AS VARCHAR(60)), 
			0, 
			price
		FROM flights WHERE departure = 'LBC') UNION ALL
		(SELECT 
			departure, 
			arrival,
			cast(departure AS VARCHAR(60)), 
			cast(tNo AS VARCHAR(60)), 
			0, 
			price
		 FROM rail WHERE departure = 'LBC') UNION ALL
		(SELECT 
			f.departure,
			f.arrival,
			cast(r.Route ||','|| f.departure AS VARCHAR(60)),
			cast(r.Plan ||','|| f.departure AS VARCHAR(60)),
			r.AnzTeilstr + 1,
			r.Gesamtkosten + f.price
		FROM REISEN r, flights f WHERE 
			r.Endposition = f.departure AND 
			f.arrival <> 'LBC' AND 
			f.departure <> 'ALC' AND
			r.Anzteilstr < 4) UNION ALL
		(SELECT 
			t.departure,
			t.arrival,
			cast(r.Route ||','|| t.departure AS VARCHAR(60)),
			cast(r.Plan ||','|| t.departure AS VARCHAR(60)),
			r.AnzTeilstr + 1,
			r.Gesamtkosten + t.price
		FROM REISEN r, rail t WHERE
			r.Endposition = t.departure AND 
			t.arrival <> 'LBC' AND 
			t.departure <> 'ALC' AND
			r.Anzteilstr < 4)
	)
	SELECT Route, Plan, Gesamtkosten
		FROM REISEN;