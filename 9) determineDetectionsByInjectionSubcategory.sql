
select detectedInd, Count(*), 'Tautology' as Category
from CypherQuery a
INNER JOIN Observation_sid100008 b
ON a.QueryId = b.QueryId

and a.TautologyInd = 1
group by detectedInd
union 
select detectedInd, Count(*), 'piggybacked' as Category
from CypherQuery a
INNER JOIN Observation_sid100008 b
ON a.QueryId = b.QueryId

and a.piggybackedInd = 1
group by detectedInd
union
select detectedInd, Count(*), 'illegalIncorrect' as Category
from CypherQuery a
INNER JOIN Observation_sid100008 b
ON a.QueryId = b.QueryId

and a.illegalIncorrectInd = 1
group by detectedInd
union
select detectedInd, Count(*), 'unionInd' as Category
from CypherQuery a
INNER JOIN Observation_sid100008 b
ON a.QueryId = b.QueryId

and a.unionInd = 1
group by detectedInd
union
select detectedInd, Count(*), 'alternateEncoding' as Category
from CypherQuery a
INNER JOIN Observation_sid100008 b
ON a.QueryId = b.QueryId

and a.alternateEncodingInd = 1
group by detectedInd
union
select detectedInd, Count(*), 'booleanInd' as Category
from CypherQuery a
INNER JOIN Observation_sid100008 b
ON a.QueryId = b.QueryId

and a.booleanInd = 1
group by detectedInd
union
select detectedInd, Count(*), 'OOBInd' as Category
from CypherQuery a
INNER JOIN Observation_sid100008 b
ON a.QueryId = b.QueryId

and a.OOBInd = 1
group by detectedInd
union
select detectedInd, Count(*), 'detectionEvasion' as Category
from CypherQuery a
INNER JOIN Observation_sid100008 b
ON a.QueryId = b.QueryId

and a.detectionEvasionInd = 1
group by detectedInd
union
select detectedInd, Count(*), 'storedProcedure' as Category
from CypherQuery a
INNER JOIN Observation_sid100008 b
ON a.QueryId = b.QueryId

and a.storedProcedureInd = 1
group by detectedInd
order by Category, detectedInd