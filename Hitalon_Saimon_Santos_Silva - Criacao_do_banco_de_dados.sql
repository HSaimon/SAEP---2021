-- ============================================================
-- SAEP 2021 - Técnico em Desenvolvimento de Sistemas
-- Estudante: Hítalon Saimon Santos Silva
-- Sistema de Gerenciamento de Tarefas - Kanban
-- ============================================================

CREATE DATABASE IF NOT EXISTS gerenciamento_tarefas
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE gerenciamento_tarefas;

-- ============================================================
-- TABELA: usuarios
-- ============================================================
CREATE TABLE IF NOT EXISTS usuarios (
    id          INT          NOT NULL AUTO_INCREMENT,
    nome        VARCHAR(150) NOT NULL,
    email       VARCHAR(200) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABELA: tarefas
-- ============================================================
CREATE TABLE IF NOT EXISTS tarefas (
    id              INT          NOT NULL AUTO_INCREMENT,
    id_usuario      INT          NOT NULL,
    descricao       TEXT         NOT NULL,
    setor           VARCHAR(150) NOT NULL,
    prioridade      ENUM('baixa','media','alta') NOT NULL,
    data_cadastro   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status          ENUM('a_fazer','fazendo','pronto') NOT NULL DEFAULT 'a_fazer',
    PRIMARY KEY (id),
    CONSTRAINT fk_tarefas_usuarios
        FOREIGN KEY (id_usuario) REFERENCES usuarios(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- VIEW: view_tarefas_completa
-- ============================================================
CREATE OR REPLACE VIEW view_tarefas_completa AS
    SELECT
        t.id,
        t.descricao,
        t.setor,
        t.prioridade,
        t.data_cadastro,
        t.status,
        t.id_usuario,
        u.nome  AS nome_usuario,
        u.email AS email_usuario
    FROM tarefas  t
    INNER JOIN usuarios u ON u.id = t.id_usuario;

-- ============================================================
-- DADOS DE EXEMPLO
-- ============================================================
INSERT INTO usuarios (nome, email) VALUES
    ('Ana Silva',    'ana.silva@empresa.com'),
    ('Carlos Lima',  'carlos.lima@empresa.com'),
    ('Maria Souza',  'maria.souza@empresa.com');

INSERT INTO tarefas (id_usuario, descricao, setor, prioridade, status) VALUES
    (1, 'Atualizar relatório mensal de produção',  'Produção',  'alta',  'a_fazer'),
    (2, 'Revisar estoque de matéria-prima',        'Estoque',   'media', 'fazendo'),
    (3, 'Treinamento de segurança alimentar',      'RH',        'baixa', 'pronto'),
    (1, 'Configurar novo sistema de rastreamento', 'TI',        'alta',  'a_fazer'),
    (2, 'Auditoria de qualidade do lote 47',       'Qualidade', 'media', 'fazendo');
