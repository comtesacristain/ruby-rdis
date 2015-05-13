-- Make into a migration

-- Can't see ANO 36

create index index_handlers_on_auto_remediation on handlers(auto_remediation);


create index index_boreholes_on_eno on boreholes(eno);

create index index_boreholes_on_entity_type on boreholes(entity_type);

create index index_boreholes_on_entityid on boreholes(entityid);

create index index_handlers_on_or_status on handlers(or_status);

create index index_handlers_on_borehole_id_and_or_status on handlers(borehole_id,or_status);

create index index_handlers_on_or_status on handlers(or_status);
	
select e1.eno, e2.eno as nearestBoreholeEno, mdsys.sdo_geom.sdo_distance(e1.geom,e2.geom,0.05) as distance
from a.entities e1, a.entities e2
where e1.entity_type in ('WELL','DRILLHOLE')    AND e2.eno in (select eno
	from a.entities e3 where sdo_nn(e3.geom,e1.geom,'sdo_batch_size=10',1) = 'TRUE'
	and e3.entity_type = 'SHOE' and e3.eno <> e1.eno and rownum < 4)
	order by 1,2