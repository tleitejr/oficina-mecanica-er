-- ============================================================
-- PROJETO: Sistema de Oficina Mecânica
-- DESAFIO DIO - Modelagem Lógica + SQL
-- BANCO: MySQL 8.x
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS oficina;
CREATE DATABASE oficina DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE oficina;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- 1) DDL - CRIAÇÃO DAS TABELAS
-- ============================================================

-- ---------- CLIENTE ----------
CREATE TABLE Cliente (
    idCliente   INT AUTO_INCREMENT PRIMARY KEY,
    tipoCliente ENUM('PF','PJ') NOT NULL,
    nome        VARCHAR(100) NOT NULL,
    cpf_cnpj    VARCHAR(20)  NOT NULL UNIQUE,
    email       VARCHAR(100),
    telefone    VARCHAR(20),
    endereco    VARCHAR(200)
) ENGINE=InnoDB;

-- ---------- VEICULO ----------
CREATE TABLE Veiculo (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT NOT NULL,
    placa     VARCHAR(10) NOT NULL UNIQUE,
    marca     VARCHAR(50),
    modelo    VARCHAR(50),
    ano       INT,
    cor       VARCHAR(30),
    CONSTRAINT fk_veiculo_cliente
        FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------- EQUIPE ----------
CREATE TABLE Equipe (
    idEquipe   INT AUTO_INCREMENT PRIMARY KEY,
    nomeEquipe VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- ---------- MECANICO ----------
CREATE TABLE Mecanico (
    idMecanico    INT AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL,
    especialidade VARCHAR(50),
    endereco      VARCHAR(200),
    cpf           VARCHAR(15) UNIQUE
) ENGINE=InnoDB;

-- ---------- MECANICO x EQUIPE (N:M) ----------
CREATE TABLE Mecanico_Equipe (
    idMecanico INT NOT NULL,
    idEquipe   INT NOT NULL,
    PRIMARY KEY (idMecanico, idEquipe),
    CONSTRAINT fk_me_mec FOREIGN KEY (idMecanico) REFERENCES Mecanico(idMecanico),
    CONSTRAINT fk_me_eq  FOREIGN KEY (idEquipe)   REFERENCES Equipe(idEquipe)
) ENGINE=InnoDB;

-- ---------- SERVICO ----------
CREATE TABLE Servico (
    idServico    INT AUTO_INCREMENT PRIMARY KEY,
    descricao    VARCHAR(100) NOT NULL,
    valorMaoObra DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

-- ---------- PECA ----------
CREATE TABLE Peca (
    idPeca        INT AUTO_INCREMENT PRIMARY KEY,
    descricao     VARCHAR(100) NOT NULL,
    valorUnitario DECIMAL(10,2) NOT NULL,
    estoque       INT DEFAULT 0
) ENGINE=InnoDB;

-- ---------- ORDEM DE SERVICO ----------
CREATE TABLE OrdemServico (
    idOS          INT AUTO_INCREMENT PRIMARY KEY,
    idVeiculo     INT NOT NULL,
    idEquipe      INT NOT NULL,
    dataEmissao   DATE NOT NULL,
    dataConclusao DATE,
    status        ENUM('Aberta','Em execução','Concluída','Cancelada') DEFAULT 'Aberta',
    valorTotal    DECIMAL(10,2) DEFAULT 0,
    CONSTRAINT fk_os_veiculo FOREIGN KEY (idVeiculo) REFERENCES Veiculo(idVeiculo),
    CONSTRAINT fk_os_equipe  FOREIGN KEY (idEquipe)  REFERENCES Equipe(idEquipe)
) ENGINE=InnoDB;

-- ---------- SERVICO x OS (N:M) ----------
CREATE TABLE Servico_OS (
    idOS       INT NOT NULL,
    idServico  INT NOT NULL,
    quantidade INT DEFAULT 1,
    PRIMARY KEY (idOS, idServico),
    CONSTRAINT fk_sos_os FOREIGN KEY (idOS)      REFERENCES OrdemServico(idOS),
    CONSTRAINT fk_sos_sv FOREIGN KEY (idServico) REFERENCES Servico(idServico)
) ENGINE=InnoDB;

-- ---------- PECA x OS (N:M) ----------
CREATE TABLE Peca_OS (
    idOS       INT NOT NULL,
    idPeca     INT NOT NULL,
    quantidade INT DEFAULT 1,
    PRIMARY KEY (idOS, idPeca),
    CONSTRAINT fk_pos_os FOREIGN KEY (idOS)  REFERENCES OrdemServico(idOS),
    CONSTRAINT fk_pos_pc FOREIGN KEY (idPeca) REFERENCES Peca(idPeca)
) ENGINE=InnoDB;

-- ---------- PAGAMENTO ----------
CREATE TABLE Pagamento (
    idPagamento   INT AUTO_INCREMENT PRIMARY KEY,
    idOS          INT NOT NULL,
    tipo          ENUM('Dinheiro','Cartão','PIX','Boleto') NOT NULL,
    valor         DECIMAL(10,2) NOT NULL,
    dataPagamento DATE,
    CONSTRAINT fk_pag_os FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS)
) ENGINE=InnoDB;


-- ============================================================
-- 2) DML - PERSISTÊNCIA DE DADOS PARA TESTE
-- ============================================================

-- ---------- Clientes ----------
INSERT INTO Cliente (tipoCliente, nome, cpf_cnpj, email, telefone, endereco) VALUES
('PF','João Silva',      '111.111.111-11', 'joao@email.com',  '11 9999-1111', 'Rua A, 10'),
('PF','Maria Souza',     '222.222.222-22', 'maria@email.com', '11 9999-2222', 'Rua B, 20'),
('PJ','Transportes XYZ', '12.345.678/0001-90','xyz@email.com','11 3333-3333', 'Av. C, 100'),
('PF','Carlos Pereira',  '333.333.333-33', 'carlos@email.com','11 9999-3333', 'Rua D, 30');

-- ---------- Veículos ----------
INSERT INTO Veiculo (idCliente, placa, marca, modelo, ano, cor) VALUES
(1, 'ABC-1234', 'Fiat',   'Uno',     2015, 'Branco'),
(1, 'ABC-5678', 'VW',     'Gol',     2018, 'Prata'),
(2, 'DEF-1111', 'Toyota', 'Corolla', 2020, 'Preto'),
(3, 'GHI-2222', 'Ford',   'Cargo',   2019, 'Branco'),
(4, 'JKL-3333', 'Honda',  'Civic',   2021, 'Cinza');

-- ---------- Equipes ----------
INSERT INTO Equipe (nomeEquipe) VALUES
('Equipe Alfa'), ('Equipe Beta'), ('Equipe Gama');

-- ---------- Mecânicos ----------
INSERT INTO Mecanico (nome, especialidade, endereco, cpf) VALUES
('Ana Lima',     'Motor',    'Rua X, 1', '444.444.444-44'),
('Bruno Alves',  'Suspensão','Rua Y, 2', '555.555.555-55'),
('Caio Castro',  'Elétrica', 'Rua Z, 3', '666.666.666-66'),
('Daniela Reis', 'Funilaria','Rua W, 4', '777.777.777-77');

-- ---------- Mecânico x Equipe ----------
INSERT INTO Mecanico_Equipe VALUES
(1,1),(2,1),(3,2),(4,2),(1,3);

-- ---------- Serviços ----------
INSERT INTO Servico (descricao, valorMaoObra) VALUES
('Troca de óleo',                 80.00),
('Alinhamento e balanceamento',  120.00),
('Revisão completa',             350.00),
('Troca de pastilha de freio',   150.00),
('Reparo elétrico',              200.00);

-- ---------- Peças ----------
INSERT INTO Peca (descricao, valorUnitario, estoque) VALUES
('Óleo 5W30 (litro)', 45.00, 100),
('Filtro de óleo',    35.00,  50),
('Pastilha de freio',110.00,  30),
('Bateria 60Ah',     420.00,  10),
('Amortecedor',      380.00,  15);

-- ---------- Ordens de Serviço ----------
INSERT INTO OrdemServico (idVeiculo, idEquipe, dataEmissao, dataConclusao, status) VALUES
(1, 1, '2024-03-01', '2024-03-02', 'Concluída'),
(2, 1, '2024-03-05', NULL,         'Em execução'),
(3, 2, '2024-03-10', '2024-03-12', 'Concluída'),
(4, 2, '2024-03-15', NULL,         'Aberta'),
(5, 3, '2024-03-18', '2024-03-20', 'Concluída');

-- ---------- Serviços por OS ----------
INSERT INTO Servico_OS VALUES
(1, 1, 1),
(1, 4, 1),
(2, 2, 1),
(3, 3, 1),
(3, 4, 1),
(4, 5, 1),
(5, 3, 1);

-- ---------- Peças por OS ----------
INSERT INTO Peca_OS VALUES
(1, 1, 4),
(1, 2, 1),
(1, 3, 2),
(3, 3, 2),
(3, 4, 1),
(5, 1, 4),
(5, 2, 1);

-- ---------- Pagamentos ----------
INSERT INTO Pagamento (idOS, tipo, valor, dataPagamento) VALUES
(1, 'Cartão',  700.00, '2024-03-02'),
(3, 'PIX',     900.00, '2024-03-12'),
(5, 'Dinheiro',500.00, '2024-03-20'),
(5, 'Cartão',  200.00, '2024-03-20');


-- ============================================================
-- 3) UPDATE - RECALCULAR valorTotal DA OS
-- ============================================================
UPDATE OrdemServico os
SET valorTotal = 
    COALESCE((SELECT SUM(s.valorMaoObra * so.quantidade)
              FROM Servico_OS so
              JOIN Servico s ON s.idServico = so.idServico
              WHERE so.idOS = os.idOS), 0)
    +
    COALESCE((SELECT SUM(p.valorUnitario * po.quantidade)
              FROM Peca_OS po
              JOIN Peca p ON p.idPeca = po.idPeca
              WHERE po.idOS = os.idOS), 0);


-- ============================================================
-- 4) QUERIES - RESPOSTAS DE NEGÓCIO
-- ============================================================

-- ---------------------------------------------------------
-- Q1) [SELECT simples] Quais são todos os clientes cadastrados?
-- ---------------------------------------------------------
SELECT idCliente, nome, tipoCliente, telefone
FROM Cliente;

-- ---------------------------------------------------------
-- Q2) [WHERE] Quais veículos são da marca Ford ou têm ano > 2020?
-- ---------------------------------------------------------
SELECT placa, marca, modelo, ano
FROM Veiculo
WHERE marca = 'Ford' OR ano > 2020;

-- ---------------------------------------------------------
-- Q3) [Atributo derivado + ORDER BY]
-- Qual o valor estimado (mão de obra + peças) de cada OS?
-- ---------------------------------------------------------
SELECT 
    os.idOS,
    v.placa,
    c.nome AS cliente,
    COALESCE((SELECT SUM(s.valorMaoObra * so.quantidade)
              FROM Servico_OS so
              JOIN Servico s ON s.idServico = so.idServico
              WHERE so.idOS = os.idOS), 0)
    +
    COALESCE((SELECT SUM(p.valorUnitario * po.quantidade)
              FROM Peca_OS po
              JOIN Peca p ON p.idPeca = po.idPeca
              WHERE po.idOS = os.idOS), 0) AS valor_estimado
FROM OrdemServico os
JOIN Veiculo v ON v.idVeiculo = os.idVeiculo
JOIN Cliente c ON c.idCliente = v.idCliente
ORDER BY valor_estimado DESC;

-- ---------------------------------------------------------
-- Q4) [JOIN + UNION] Quais serviços e peças foram executados em cada OS?
-- ---------------------------------------------------------
SELECT os.idOS, v.placa, 'Serviço' AS tipo, s.descricao, 
       so.quantidade, s.valorMaoObra AS valor_unit
FROM OrdemServico os
JOIN Veiculo    v  ON v.idVeiculo = os.idVeiculo
JOIN Servico_OS so ON so.idOS = os.idOS
JOIN Servico    s  ON s.idServico = so.idServico

UNION ALL

SELECT os.idOS, v.placa, 'Peça' AS tipo, p.descricao,
       po.quantidade, p.valorUnitario AS valor_unit
FROM OrdemServico os
JOIN Veiculo  v  ON v.idVeiculo = os.idVeiculo
JOIN Peca_OS  po ON po.idOS = os.idOS
JOIN Peca     p  ON p.idPeca = po.idPeca
ORDER BY idOS, tipo;

-- ---------------------------------------------------------
-- Q5) [HAVING] Quais equipes concluíram mais de 1 OS?
-- ---------------------------------------------------------
SELECT e.nomeEquipe, COUNT(os.idOS) AS qtd_os_concluidas
FROM Equipe e
JOIN OrdemServico os ON os.idEquipe = e.idEquipe
WHERE os.status = 'Concluída'
GROUP BY e.idEquipe, e.nomeEquipe
HAVING COUNT(os.idOS) > 1;

-- ---------------------------------------------------------
-- Q6) [HAVING + derivado] Mecânicos cuja equipe gerou
-- mais de R$ 300 em mão de obra
-- ---------------------------------------------------------
SELECT m.nome AS mecanico, e.nomeEquipe,
       SUM(s.valorMaoObra * so.quantidade) AS total_mao_obra
FROM Mecanico m
JOIN Mecanico_Equipe me ON me.idMecanico = m.idMecanico
JOIN Equipe          e  ON e.idEquipe    = me.idEquipe
JOIN OrdemServico    os ON os.idEquipe   = e.idEquipe
JOIN Servico_OS      so ON so.idOS       = os.idOS
JOIN Servico         s  ON s.idServico   = so.idServico
GROUP BY m.idMecanico, m.nome, e.nomeEquipe
HAVING SUM(s.valorMaoObra * so.quantidade) > 300
ORDER BY total_mao_obra DESC;

-- ---------------------------------------------------------
-- Q7) [JOIN + HAVING + ORDER BY] Clientes que pagaram acima de R$ 500
-- ---------------------------------------------------------
SELECT c.nome AS cliente, SUM(pg.valor) AS total_pago
FROM Cliente c
JOIN Veiculo       v  ON v.idCliente = c.idCliente
JOIN OrdemServico  os ON os.idVeiculo = v.idVeiculo
JOIN Pagamento     pg ON pg.idOS = os.idOS
GROUP BY c.idCliente, c.nome
HAVING SUM(pg.valor) > 500
ORDER BY total_pago DESC;

-- ---------------------------------------------------------
-- Q8) [Derivado + ORDER BY] Ranking de peças mais usadas e
-- seu percentual no total gerado por peças
-- ---------------------------------------------------------
SELECT p.descricao,
       SUM(po.quantidade) AS qtd_usada,
       SUM(po.quantidade * p.valorUnitario) AS total_gerado,
       ROUND(
           100.0 * SUM(po.quantidade * p.valorUnitario) /
           (SELECT SUM(po2.quantidade * p2.valorUnitario)
            FROM Peca_OS po2
            JOIN Peca p2 ON p2.idPeca = po2.idPeca), 2
       ) AS percentual
FROM Peca p
JOIN Peca_OS po ON po.idPeca = p.idPeca
GROUP BY p.idPeca, p.descricao
ORDER BY total_gerado DESC;

-- ---------------------------------------------------------
-- Q9) [JOIN complexo + agregação] OS em execução, equipe e mecânicos alocados
-- ---------------------------------------------------------
SELECT os.idOS,
       v.placa,
       e.nomeEquipe,
       GROUP_CONCAT(DISTINCT m.nome ORDER BY m.nome SEPARATOR ', ') AS mecanicos
FROM OrdemServico os
JOIN Veiculo          v  ON v.idVeiculo = os.idVeiculo
JOIN Equipe           e  ON e.idEquipe  = os.idEquipe
JOIN Mecanico_Equipe  me ON me.idEquipe = e.idEquipe
JOIN Mecanico         m  ON m.idMecanico = me.idMecanico
WHERE os.status = 'Em execução'
GROUP BY os.idOS, v.placa, e.nomeEquipe;

-- ---------------------------------------------------------
-- Q10) [BÔNUS] Consolidado por cliente: veículos, OS e valor total
-- ---------------------------------------------------------
SELECT c.nome AS cliente,
       COUNT(DISTINCT v.idVeiculo) AS qtd_veiculos,
       COUNT(DISTINCT os.idOS)     AS qtd_os,
       COALESCE(SUM(DISTINCT os.valorTotal), 0) AS valor_total_os
FROM Cliente c
LEFT JOIN Veiculo      v  ON v.idCliente = c.idCliente
LEFT JOIN OrdemServico os ON os.idVeiculo = v.idVeiculo
GROUP BY c.idCliente, c.nome
ORDER BY valor_total_os DESC;

-- ============================================================
-- FIM DO SCRIPT
-- ============================================================