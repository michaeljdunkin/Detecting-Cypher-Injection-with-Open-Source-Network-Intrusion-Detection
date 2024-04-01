CREATE TABLE `Observation1` (
  `ObservationId` int NOT NULL AUTO_INCREMENT,
  `ObservationTs` datetime NOT NULL,
  `RunTs` datetime NOT NULL,
  `QueryId` int NOT NULL,
  `ResponseTxt` varchar(4000) NOT NULL,
  `DetectionTxt` varchar(4000) NOT NULL,
  `DetectedInd` tinyint(1) NOT NULL,
  `DurationMs` int NOT NULL,
  PRIMARY KEY (`ObservationId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into Observation1
select *
from Observation
where RunTs  IN (select max(RunTs) from Observation);

select avg(DurationMs)
from Observation1;

select case when a.InjectionQueryInd = 1 and b.DetectedInd = 1 then 'TP'
			when a.InjectionQueryInd = 1 and b.DetectedInd = 0 then 'FN'
            when a.InjectionQueryInd = 0 and b.DetectedInd = 1 then 'FP'
            when a.InjectionQueryInd = 0 and b.DetectedInd = 0 then 'TN'
            else 'unknown'
            end as DetectionCategory
            ,count(b.ObservationId) as Cnt
from CypherQuery a
INNER JOIN Observation1 b
ON a.QueryId = b.QueryId
group by case when a.InjectionQueryInd = 1 and b.DetectedInd = 1 then 'TP'
			when a.InjectionQueryInd = 1 and b.DetectedInd = 0 then 'FN'
            when a.InjectionQueryInd = 0 and b.DetectedInd = 1 then 'FP'
            when a.InjectionQueryInd = 0 and b.DetectedInd = 0 then 'TN'
            else 'unknown'
            end;