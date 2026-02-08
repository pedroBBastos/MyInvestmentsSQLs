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
	where n.quantidade > 0 and d.data_liquidacao between '2025-01-01' and '2025-12-31'
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
	-- nesse trecho não filtro por data para pegar TODAS as compras já realizadas....
	-- -> mas e se tiver alguma venda no meio do caminho??
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

-----------------------------------------------

select * from ticker_yield_results
where ticker_type = 'ACAO'
order by ticker;

with negotiation as (
	select n.ticker as ticker,
		   sum(
		   		case when n.operacao = 'C' then n.quantidade else -1*n.quantidade end
		   ) as quantidade
	from negociacao n
	group by n.ticker
)
select tyr.ticker,
       tyr.y2,
       tyr.tracked_period
from ticker_yield_results tyr
inner join negotiation n on n.ticker = tyr.ticker
where tyr.ticker_type = 'ACAO' and n.quantidade > 0
order by tyr.ticker;

-- BRAP4
-- BRSR6
-- BBDC3 e SANB11 - mas BBDC3 tá melhor...
-- CMIG3/4
-- CMIN3, apesar de y1 bom ainda, multiplos já altos..
-- CXSE3, apesar de y1 bom ainda, multiplos já altos..
-- GRND3, MUITO BOA AINDA...
-- ISAE3/4
-- ITSA4, apesar de y1 bom ainda, multiplos já altos..
-- KLBN11
-- LEVE3, apesar de y1 bom ainda, multiplos já altos..
-- MTRE3, MUITO BOA AINDA...
-- PETR4
-- RANI3
-- ROMI3
-- SLCE3
-- TAEE11