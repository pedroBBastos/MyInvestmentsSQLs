CREATE TABLE stocks (
    ticker TEXT NOT NULL,
    setor TEXT,
    subsetor TEXT,
    segmento TEXT,
    PRIMARY KEY (ticker)
);

with contagem as (
	select n.ticker as ticker,
		   sum(
		   		case when n.operacao = 'C' then n.quantidade else -1*n.quantidade end
		   ) as quantidade   
	from negociacao n
	group by n.ticker
)
select * from contagem
inner join stocks s on s.ticker = contagem.ticker
where contagem.quantidade > 0;

----------
--
--delete from negociacao 
--where ticker = 'EALT4' and valor_total in ( 506.0, 580.58);
--
--INSERT INTO negociacao
--(id, date, operacao, preco_unitario, quantidade, ticker, tipo_de_mercado, valor_total)
--VALUES(NULL, '2024-07-29', 'C', 11.38, 51, 'EALT4', NULL, 580.58);
--INSERT INTO negociacao
--(id, date, operacao, preco_unitario, quantidade, ticker, tipo_de_mercado, valor_total)
--VALUES(NULL, '2024-07-26', 'C', 11.5, 44, 'EALT4', NULL, 506.0);

select * from negociacao n
where n.ticker = 'TAEE11';

select * from stocks;

select setor, count(*) from stocks
group by setor;
