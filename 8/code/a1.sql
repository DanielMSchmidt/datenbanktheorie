connect to UEBUNG;

CREATE OR REPLACE VIEW family (person, familyMember) AS 
WITH MOTHERANCESTRY(Ancestor, Descendant) AS
	((SELECT Mother, Child FROM MOTHERHOOD) UNION ALL
		(SELECT x.Mother, y.Descendant FROM MOTHERHOOD x, MOTHERANCESTRY y WHERE x.Child = y.Ancestor)),
	FATHERANCESTRY(Ancestor, Descendant) AS
	((SELECT Father, Child FROM FATHERHOOD) UNION ALL
		(SELECT x.Father, y.Descendant FROM FATHERHOOD x, FATHERANCESTRY y WHERE x.Child = y.Ancestor)),	
	ANCESTRY(X,Y) AS
	((SELECT Ancestor, Descendant FROM MOTHERANCESTRY) UNION
	(SELECT Descendant, Ancestor FROM MOTHERANCESTRY) UNION
	(SELECT Ancestor, Descendant FROM FATHERANCESTRY) UNION 
	(SELECT Descendant, Ancestor FROM FATHERANCESTRY)),
	COMMONANCESTRY(X,Y) AS 
	(SELECT DISTINCT a.X,b.X FROM ANCESTRY a, ANCESTRY b WHERE a.Y = b.Y)
	(SELECT * FROM COMMONANCESTRY);
SELECT * FROM family;

terminate;