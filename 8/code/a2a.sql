WITH REISEN(
	Abflugzeit, 
	Endposition, 
	Ankunftszeit, 
	Route, 
	Anzteilstr, 
	Gesamtkosten) AS
	((SELECT 
		depTime, 
		arrival,
		arrTime,
		cast(departure || ' - ' || fNo AS VARCHAR(60)), 
		1, 
		price
	FROM flights WHERE departure = 'LBC') UNION ALL
	(SELECT 
		depTime, 
		arrival,
		arrTime,
		cast(departure || ' - ' || tNo AS VARCHAR(60)), 
		1, 
		price
	 FROM rail WHERE departure = 'LBC') UNION ALL
	(SELECT
		r.Abflugzeit,
		f.arrival,
		f.arrTime,
		cast(r.Route ||'->'|| f.departure || '-' || f.fNo AS VARCHAR(60)),
		r.AnzTeilstr + 1,
		r.Gesamtkosten + f.price
	FROM REISEN r, flights f WHERE 
		r.Endposition = f.departure AND 
		f.arrival <> 'LBC' AND 
		f.departure <> 'ALC' AND
		r.Ankunftszeit < f.depTime AND
		r.Anzteilstr < 4) UNION ALL
	(SELECT
		r.Abflugzeit,
		t.arrival,
		t.arrTime,
		cast(r.Route ||'->'|| t.departure || '-' || t.tNo AS VARCHAR(60)),
		r.AnzTeilstr + 1,
		r.Gesamtkosten + t.price
	FROM REISEN r, rail t WHERE
		r.Endposition = t.departure AND 
		t.arrival <> 'LBC' AND 
		t.departure <> 'ALC' AND
		r.Ankunftszeit < t.depTime AND
		r.Anzteilstr < 4)
	)
	SELECT DISTINCT Abflugzeit, Endposition, Ankunftszeit, Route, Anzteilstr, Gesamtkosten 
	FROM REISEN WHERE 
	Endposition = 'ALC' AND 
	Gesamtkosten = (SELECT min(Gesamtkosten) FROM REISEN WHERE Endposition = 'ALC') AND 
	timestampdiff(8, Ankunftszeit-Abflugzeit) = (SELECT min(timestampdiff(8, Ankunftszeit-Abflugzeit)) 
            FROM REISEN WHERE
            Endposition = 'ALC' AND
            Gesamtkosten = (SELECT min(Gesamtkosten) FROM REISEN WHERE Endposition = 'ALC'));

