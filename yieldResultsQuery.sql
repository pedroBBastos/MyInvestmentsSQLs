select * from negociacao n
--order by n."date" asc;
--order by ticker asc, date;
where ticker = 'UNIP5';
--delete from negociacao ;



-- BPAC5, como teve desdobramento de ações, o input dos dados não veio correto...
--delete from negociacao
--where ticker = 'ITSA4';

select * from dividendo d
where ticker = 'TRPL4';

select * from dividendo d
--order by data_liquidacao asc ;
where ticker = 'TAEE4';
--delete from dividendo ;

select  date_trunc('month', d.data_movimentacao) as movPorMes, 
		sum(d.lancamento) 
from dividendo d
group by date_trunc('month', d.data_movimentacao)
order by date_trunc('month', d.data_movimentacao);

select cd."data", count(*) from cotacao_dolar cd
--order by id desc ;
group by data;

select * from cotacao_dolar cd 
order by "data" ;

select * from cotacao_dolar cd ;

select * from dividendo d2 
order by data_movimentacao  desc;

-- para bater com os dados no site da corretora, por ação...
select sum(lancamento) from dividendo d
where ticker = 'PSSA3'
and d.data_liquidacao between '2023-01-01' and '2023-12-31';

select sum(lancamento) from dividendo d
where d.data_liquidacao between '2023-01-01' and '2023-12-31';


--delete from cotacao_dolar;

--drop table cotacao_dolar ;
--drop table dividendo ;
--drop table negociacao ;

------------------------------------

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
-- os 3 selects acima são para contabilizar os dividendos das ações que ainda tenho em carteira...
-- enquanto os dois abaixo são para contabilizar em dolar as compras de cada papel
-- para no fim da query eu poder calcular o y1 e y2
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
select total_compras.ticker,
	   total_compras.totalreal as total_compra_real,
	   total_compras.totaldolar as total_compra_dolar,
	   tdd.totaldividendosreal as totaldividendosreal,
	   tdd.totaldividendosdolar as totaldividendosdolar,
	   tdd.totaldividendosreal / total_compras.totalreal as y1,
	   tdd.totaldividendosdolar / total_compras.totaldolar as y2
from total_compras total_compras
inner join total_dividendos_dolarizados tdd on tdd.ticker = total_compras.ticker -- mudar para left join para considerar papeis que não me deram dividendos_dolarizados
order by y2 desc;

-- resultados estranhos... primeiro BO é o fato de, por exemplo, ter comprado o MXRF11 bem antes da primeira cotação de dolar no banco
-- PETR4 tá dando um y1/y2 muito pequeno para o que foi em 2022....
--	-->> aaa... acho que para PETR4, tá considerando compras antigas... (que vendi e depois comprei de novo...)

----------------------------------------------------


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
	where n.quantidade > 0 and d.data_liquidacao between '2022-01-01' and '2022-12-31'
)
select * from dividendos_dolarizados;


-------------------------------------------------------


with agregated as (select * from get_agregated_stocks()),
		compras as (
			select n.ticker,
				   n.quantidade,
				   n."date",
				   n.preco_unitario,
				   CD.id,
				   cd.valor as fechamentoDolarNoDia,
				   n.preco_unitario / cd.valor as precoUnitarioDolarizado
			from negociacao n
			inner join agregated agregated on agregated.ticker = n.ticker
			inner join cotacao_dolar cd on cd."data"  = n."date"
			-- where n."date" between '2022-01-01' and '2022-12-31'
		)
		select c.ticker as ticker,
			   sum(c.preco_unitario*c.quantidade) as total_em_real,
			   sum(c.precoUnitarioDolarizado*c.quantidade) as total_dolarizado
		from compras c
		group by c.ticker;

	
with blas as (select * from get_agregated_stocks())
select n.ticker,
	   n.quantidade,
	   n."date",
	   n.preco_unitario,
	   n.operacao,
	   CD.id,
	   cd.valor as fechamentoDolarNoDia,
	   n.preco_unitario / cd.valor as precoUnitarioDolarizado
from negociacao n
inner join blas blas on blas.ticker = n.ticker
inner join cotacao_dolar cd on cd."data"  = n."date"
where n.ticker = 'PETR4';

select * from negociacao n where n.ticker = 'PETR4';

----------------

select * from ticker_yield_results tyr ;