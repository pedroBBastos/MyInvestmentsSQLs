--create table ticker_yield_results
--as
insert into ticker_yield_results (ticker, y1, y2, tracked_period)
with negotiation as (
	select n.ticker as ticker,
		   sum(
		   		case when n.operacao = 'C' then n.quantidade else -1*n.quantidade end
		   ) as quantidade   
	from negociacao n
	group by n.ticker
),
dividendos_dolarizados as (
	select n.ticker as ticker,
		   n.quantidade as quantidade,
		   d.data_liquidacao as data_liquidacao,
		   d.lancamento as lancamento,
		   cd.valor as valor,
		   d.lancamento / cd.valor as lacamentoDolarizado
	from negotiation n
	inner join dividendo d on d.ticker = n.ticker
	inner join cotacao_dolar cd on cd."data" = d.data_liquidacao 
	where n.quantidade > 0 and d.data_liquidacao between '2024-01-01' and '2024-12-31'
),
total_dividendos_dolarizados as (
	select dd.ticker,
		   sum(dd.lancamento) as totalDividendosReal,
		   sum(dd.lacamentoDolarizado) as totalDividendosDolar
	from dividendos_dolarizados dd
	group by dd.ticker
),
compras as (
	select n.ticker,
		   n.quantidade,
		   n."date",
		   n.preco_unitario,
		   CD.id,
		   cd.valor as fechamentoDolarNoDia,
		   n.preco_unitario / cd.valor as precoUnitarioDolarizado
	from negociacao n
	inner join cotacao_dolar cd on cd."data"  = n."date"
	-- where n."date" between '2022-01-01' and '2022-12-31'
),
total_compras as (
	select c.ticker as ticker,
		   sum(c.preco_unitario*c.quantidade) as totalReal,
		   sum(c.precoUnitarioDolarizado*c.quantidade) as totalDolar
	from compras c
	group by c.ticker
)
select total_compras.ticker as ticker,
	   tdd.totaldividendosreal / total_compras.totalreal as y1,
	   tdd.totaldividendosdolar / total_compras.totaldolar as y2,
	   '01/2024 a 12/2024' as tracked_period
from total_compras total_compras
inner join total_dividendos_dolarizados tdd on tdd.ticker = total_compras.ticker -- mudar para left join para considerar papeis que não me deram dividendos_dolarizados
order by y2 desc;


select * from ticker_yield_results tyr ;

--ALTER TABLE ticker_yield_results
--add COLUMN tracked_year int;
--
--update ticker_yield_results 
--set tracked_year = 2022;



