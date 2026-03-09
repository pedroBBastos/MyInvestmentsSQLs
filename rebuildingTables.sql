-- rebuilding tables so that deletes/updates can be performed indexing by the id.
-- In the previous way, having all tables using id bigint SQLite was not generating incrementing ids...

create table negociacao_new
(
    id              integer primary key,
    date            date,
    operacao        character(1),
    preco_unitario  real,
    quantidade      integer,
    ticker          character varying(255),
    tipo_de_mercado character varying(255),
    valor_total     real
);

INSERT INTO negociacao_new
(date, operacao, preco_unitario, quantidade, ticker, tipo_de_mercado, valor_total)
SELECT
    date,
    operacao,
    preco_unitario,
    quantidade,
    ticker,
    tipo_de_mercado,
    valor_total
FROM negociacao;

DROP TABLE negociacao;

ALTER TABLE negociacao_new RENAME TO negociacao;

VACUUM; -- This rebuilds the database file and cleans unused space.

-- --------------------------------------

CREATE TABLE dividendo_new (
    id                INTEGER PRIMARY KEY,
    data_liquidacao   DATE,
    data_movimentacao DATE,
    lancamento        REAL,
    ticker            TEXT
);

INSERT INTO dividendo_new
(data_liquidacao, data_movimentacao, lancamento, ticker)
SELECT
    data_liquidacao,
    data_movimentacao,
    lancamento,
    ticker
FROM dividendo;

DROP TABLE dividendo;

ALTER TABLE dividendo_new RENAME TO dividendo;

VACUUM;

-- -------------------------------------------------------

CREATE TABLE cotacao_dolar_new (
    id    INTEGER PRIMARY KEY,
    data  DATE,
    valor REAL
);

INSERT INTO cotacao_dolar_new
(data, valor)
SELECT
    data,
    valor
FROM cotacao_dolar;

DROP TABLE cotacao_dolar;

ALTER TABLE cotacao_dolar_new RENAME TO cotacao_dolar;

VACUUM;