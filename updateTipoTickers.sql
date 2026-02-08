select * from cotacao_dolar cd
WHERE "data" >= '2023-07-01'
ORDER BY "data";

SELECT sum(quantidade) FROM negociacao n WHERE ticker LIKE "%EALT4%";
SELECT * FROM negociacao n WHERE ticker LIKE "%BBAS3%";

SELECT * FROM dividendo d WHERE ticker LIKE "%ROMI3";

SELECT * FROM cotacao_dolar cd ORDER BY DATA DESC ;

-----------

SELECT * FROM negociacao n WHERE ticker like "%BPAC%" order by date;

--ALTER TABLE ticker_yield_results 
--ADD ticker_type VARCHAR;
--
--ALTER TABLE ticker_yield_results 
--DROP COLUMN tracked_year;

UPDATE ticker_yield_results 
SET tracked_period = '2023'
WHERE tracked_year = 2023;

SELECT * FROM ticker_yield_results tyr;

SELECT * FROM ticker_yield_results tyr
where ticker = 'EALT4';

select * from ticker_yield_results t 
where t.ticker_type = 'FII' and tracked_period = '';



UPDATE ticker_yield_results 
SET ticker_type = 'ACAO'
WHERE ticker NOT IN ('BTAL11', 'BTRA11', 'HFOF11', 'IRDM11', 'XPPR11',
					  'MXRF11', 'RBRF11', 'RECR11', 'TRBL11', 'VISC11', 'VSLH11', 'KNCR11',
					  'GTWR11', 'XPML11', 'GGRC11', 'HGBS11', 'XPIN11', 'GALG11',
                      'VGIR11', 'SNAG11', 'CPTS11', 'HCTR11')
       and ticker_type is null;

-----------