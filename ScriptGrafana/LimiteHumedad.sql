WITH
constantes (temperatura, humedad) AS (values(1, 2)),

time_p AS (SELECT d.time,
t.idx as index,
t.time + cast(extract(epoch from d.base_time) as integer) as tiempo
FROM receiver_data as d, constantes as c
LEFT JOIN UNNEST(d.times) WITH ORDINALITY AS t(time, idx) ON TRUE
WHERE d.measurement_id = c.humedad ),

value_p AS (SELECT d.time,
v.idx as index,
v.value as valor,
d.max_value,
d.min_value,
d.base_time
FROM receiver_data as d, constantes as c
LEFT JOIN UNNEST(d.values) WITH ORDINALITY AS v(value, idx) ON TRUE
WHERE d.measurement_id = c.humedad
and d.base_time >= cast(now() as date) )

SELECT
min(v.valor) as min,
max(v.valor) as max,
(select d.min_value as Limite_diario_minimo FROM receiver_measurement as d where id=2),
(select d.max_value as Limite_diario_maximo FROM receiver_measurement as d where id=2)
FROM time_p t 
LEFT JOIN value_p v on (t.time = v.time AND t.index = v.index);