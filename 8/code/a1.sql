connect to UEBUNG;

CREATE OR REPLACE VIEW family (person, familyMember) AS 
WITH MOTHERANCESTRY(Ancestor, Descendant) AS
	((SELECT Mother, Child FROM MOTHERHOOD) UNION ALL
		(SELECT x.Mother, y.Descendant FROM MOTHERHOOD x, MOTHERANCESTRY y WHERE x.Child = y.Ancestor)),
	FATHERANCESTRY(Ancestor, Descendant) AS
	((SELECT Father, Child FROM FATHERHOOD) UNION ALL
		(SELECT x.Father, y.Descendant FROM FATHERHOOD x, FATHERANCESTRY y WHERE x.Child = y.Ancestor)),	
	ANCESTRY(Ancestor, Descendant) AS
	((SELECT Ancestor, Descendant FROM MOTHERANCESTRY) UNION
	(SELECT Ancestor, Descendant FROM FATHERANCESTRY))
	(SELECT * FROM ANCESTRY);
SELECT * FROM family;

terminate;