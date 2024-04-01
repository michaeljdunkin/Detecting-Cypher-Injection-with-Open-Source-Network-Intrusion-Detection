select Detections, count(*)
from
(select a.*, b1.DetectedInd + b2.DetectedInd + b3.DetectedInd + b4.DetectedInd + b5.DetectedInd + b6.DetectedInd + b7.DetectedInd + b8.DetectedInd as Detections
from CypherQuery a
	,Observation_sid100001 b1
    	,Observation_sid100002 b2
			,Observation_sid100003 b3
            	,Observation_sid100004 b4
                	,Observation_sid100005 b5
                    	,Observation_sid100006 b6
                        	,Observation_sid100007 b7
                            	,Observation_sid100008 b8
where 	a.QueryId = b1.QueryId
and 	a.QueryId = b2.QueryId
 and 	a.QueryId = b3.QueryId
and 	a.QueryId = b4.QueryId
and 	a.QueryId = b5.QueryId
 and 	a.QueryId = b6.QueryId
 and 	a.QueryId = b7.QueryId
 and 	a.QueryId = b8.QueryId
and 	a.InjectionQueryInd = 1) x
group by Detections