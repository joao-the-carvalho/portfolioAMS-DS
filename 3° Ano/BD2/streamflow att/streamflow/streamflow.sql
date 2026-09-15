CREATE DATABASE IF NOT EXISTS streamflow;
USE streamflow;

-- tabelas dos assinantes e perfis
CREATE TABLE assinantes (
    id              INT AUTO_INCREMENT NOT NULL UNIQUE PRIMARY KEY,
    nome_completo   VARCHAR(150) NOT NULL,
    email           VARCHAR(255) NOT NULL UNIQUE,
    cpf             CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    uf              CHAR(2) NOT NULL,
    saldo           DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    data_cadastro   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE formas_pagamento (
    id              INT AUTO_INCREMENT NOT NULL UNIQUE PRIMARY KEY,
    id_assinante    INT NOT NULL,
    tipo            VARCHAR(20) NOT NULL CHECK (tipo IN ('CREDITO', 'DEBITO', 'PIX', 'BOLETO')),
    token_cartao    VARCHAR(255), -- token em vez do número real do cartão, evitando guardar dado sensível em texto puro
    CONSTRAINT fk_pagamento_assinante FOREIGN KEY (id_assinante)
        REFERENCES assinantes(id) ON DELETE RESTRICT
);


CREATE TABLE perfis (
    id              INT AUTO_INCREMENT NOT NULL UNIQUE PRIMARY KEY,
    id_assinante    INT NOT NULL,
    nome_exibicao   VARCHAR(50) NOT NULL,
    classificacao   VARCHAR(10) NOT NULL DEFAULT 'LIVRE' CHECK (classificacao IN ('ADULTO', 'LIVRE')),
    ativo           BOOLEAN NOT NULL DEFAULT TRUE,
    data_criacao    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_perfil_assinante FOREIGN KEY (id_assinante)
        REFERENCES assinantes(id) ON DELETE RESTRICT
);

-- tabelas referentes ao catalogo
CREATE TABLE produtoras (
    id              INT AUTO_INCREMENT NOT NULL UNIQUE PRIMARY KEY,
    nome            VARCHAR(150) NOT NULL,
    pais_origem     VARCHAR(50)
);
CREATE TABLE series (
    id              INT AUTO_INCREMENT NOT NULL UNIQUE PRIMARY KEY,
    titulo          VARCHAR(200) NOT NULL,
    id_produtora    INT NOT NULL,
    status_catalogo VARCHAR(10) NOT NULL DEFAULT 'ATIVO' CHECK (status_catalogo IN ('ATIVO','REMOVIDO')),
    CONSTRAINT fk_serie_produtora FOREIGN KEY (id_produtora)
        REFERENCES produtoras(id) ON DELETE RESTRICT
);

CREATE TABLE videos (
    id              INT AUTO_INCREMENT NOT NULL UNIQUE PRIMARY KEY,
    titulo          VARCHAR(200) NOT NULL,
    duracao_seg     INT NOT NULL CHECK (duracao_seg > 0),
    produtora_id    INT NOT NULL,
    ativo           BOOLEAN NOT NULL DEFAULT TRUE,
    data_remocao    TIMESTAMP NULL,
    CONSTRAINT fk_video_produtora FOREIGN KEY (produtora_id)
        REFERENCES produtoras(id) ON DELETE RESTRICT
);
CREATE TABLE filmes (
    id              INT AUTO_INCREMENT NOT NULL UNIQUE PRIMARY KEY,
    id_video        INT NOT NULL UNIQUE,
    CONSTRAINT fk_filme_video FOREIGN KEY (id_video)
        REFERENCES videos(id) ON DELETE RESTRICT
);

CREATE TABLE episodios (
    id              INT AUTO_INCREMENT NOT NULL UNIQUE PRIMARY KEY,
    id_video        INT NOT NULL UNIQUE,
    id_serie        INT NOT NULL,
    temporada       INT NOT NULL,
    numero_episodio INT NOT NULL,
    CONSTRAINT fk_episodio_video FOREIGN KEY (id_video)
        REFERENCES videos(id) ON DELETE RESTRICT,
    CONSTRAINT fk_episodio_serie FOREIGN KEY (id_serie)
        REFERENCES series(id) ON DELETE RESTRICT
);

-- historico de vizualizacao
CREATE TABLE historicos_visualizacao (
    id                          INT AUTO_INCREMENT NOT NULL UNIQUE PRIMARY KEY,
    id_perfil                   INT NOT NULL,
    id_video                    INT NOT NULL,
    tempo_assistido_segundos    INT NOT NULL DEFAULT 0,
    concluido                   BOOLEAN NOT NULL DEFAULT FALSE,
    data_inicio                 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_ultima_atualizacao     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_historico_perfil FOREIGN KEY (id_perfil)
        REFERENCES perfis(id) ON DELETE RESTRICT,
    CONSTRAINT fk_historico_video FOREIGN KEY (id_video)
        REFERENCES videos(id) ON DELETE RESTRICT
);
-- logs
CREATE TABLE logs_reproducao (
    id                  INT AUTO_INCREMENT NOT NULL UNIQUE PRIMARY KEY,
    id_perfil           INT NOT NULL,
    id_video            INT NOT NULL,
    ip_origem           VARCHAR(45) NOT NULL,
    tipo_dispositivo    VARCHAR(15) NOT NULL CHECK (tipo_dispositivo IN('WEB', 'SMARTTV', 'MOBILE', 'TABLET', 'CONSOLE')),
    data_hora_evento    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_log_perfil FOREIGN KEY (id_perfil)
        REFERENCES perfis(id) ON DELETE RESTRICT,
    CONSTRAINT fk_log_video FOREIGN KEY (id_video)
        REFERENCES videos(id) ON DELETE RESTRICT
);

CREATE TABLE faturamento_produtoras (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    id_produtora        INT NOT NULL,
    competencia         DATE NOT NULL,
    minutos_consumidos  DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_fat_produtora FOREIGN KEY (id_produtora) REFERENCES produtoras(id) ON DELETE RESTRICT,
    CONSTRAINT uk_produtora_competencia UNIQUE (id_produtora, competencia)
);

CREATE TABLE auditoria_log (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    tabela              VARCHAR(50) NOT NULL,
    operacao            VARCHAR(10) NOT NULL,
    usuario             VARCHAR(100) NOT NULL,
    valor_antigo        TEXT,
    valor_novo          TEXT,
    data_hora           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE resumo_reproducao (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    total_acessos       INT NOT NULL DEFAULT 0
);

CREATE TABLE generos (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE perfis_preferencias (
    id_perfil INT NOT NULL,
    id_genero INT NOT NULL,
    PRIMARY KEY (id_perfil, id_genero),
    CONSTRAINT fk_pref_perfil FOREIGN KEY (id_perfil) REFERENCES perfis(id) ON DELETE CASCADE,
    CONSTRAINT fk_pref_genero FOREIGN KEY (id_genero) REFERENCES generos(id) ON DELETE CASCADE
);

-- roles
CREATE ROLE IF NOT EXISTS 'app_streamflow';
GRANT SELECT, INSERT, UPDATE, DELETE ON streamflow.assinantes TO 'app_streamflow';
GRANT SELECT, INSERT, UPDATE, DELETE ON streamflow.perfis TO 'app_streamflow';
GRANT SELECT, INSERT, UPDATE, DELETE ON streamflow.formas_pagamento TO 'app_streamflow';
GRANT SELECT, INSERT, UPDATE, DELETE ON streamflow.historicos_visualizacao TO 'app_streamflow';
GRANT SELECT, INSERT ON streamflow.logs_reproducao TO 'app_streamflow';
GRANT SELECT ON streamflow.videos TO 'app_streamflow';
GRANT SELECT ON streamflow.filmes TO 'app_streamflow';
GRANT SELECT ON streamflow.episodios TO 'app_streamflow';
GRANT SELECT ON streamflow.series TO 'app_streamflow';
GRANT SELECT ON streamflow.produtoras TO 'app_streamflow';
GRANT SELECT ON streamflow.generos TO 'app_streamflow';
GRANT SELECT, INSERT, DELETE ON streamflow.perfis_preferencias TO 'app_streamflow';
GRANT EXECUTE ON streamflow.* TO 'app_streamflow';

CREATE USER IF NOT EXISTS 'usuario_app'@'%' IDENTIFIED BY 'senha_app123';
GRANT 'app_streamflow' TO 'usuario_app'@'%';
SET DEFAULT ROLE 'app_streamflow' FOR 'usuario_app'@'%';

CREATE ROLE IF NOT EXISTS 'auditoria';
GRANT SELECT ON streamflow.logs_reproducao TO 'auditoria';
GRANT SELECT ON streamflow.historicos_visualizacao TO 'auditoria';
GRANT SELECT ON streamflow.auditoria_log TO 'auditoria';

CREATE USER IF NOT EXISTS 'usuario_auditor'@'%' IDENTIFIED BY 'senha_auditor123';
GRANT 'auditoria' TO 'usuario_auditor'@'%';
SET DEFAULT ROLE 'auditoria' FOR 'usuario_auditor'@'%';

CREATE ROLE IF NOT EXISTS 'produtora_bi';
GRANT SELECT ON streamflow.produtoras TO 'produtora_bi';
GRANT SELECT ON streamflow.series TO 'produtora_bi';
GRANT SELECT ON streamflow.videos TO 'produtora_bi';
GRANT SELECT ON streamflow.filmes TO 'produtora_bi';
GRANT SELECT ON streamflow.episodios TO 'produtora_bi';
GRANT SELECT ON streamflow.faturamento_produtoras TO 'produtora_bi';
GRANT EXECUTE ON PROCEDURE streamflow.gerar_faturamento_mensal TO 'produtora_bi';
GRANT EXECUTE ON FUNCTION streamflow.minutos_assistidos_por_produtora TO 'produtora_bi';

CREATE USER IF NOT EXISTS 'usuario_produtora'@'%' IDENTIFIED BY 'senha_produtora123';
GRANT 'produtora_bi' TO 'usuario_produtora'@'%';
SET DEFAULT ROLE 'produtora_bi' FOR 'usuario_produtora'@'%';

-- indice pra o continuar assistindo
CREATE INDEX idx_historico_continuar_assistindo
ON historicos_visualizacao (id_perfil, concluido, data_ultima_atualizacao DESC);

-- view para a data de nascimento de acordo com a lgpd
CREATE VIEW vw_analise_assinantes AS
SELECT
    a.id,
    a.uf,
    TIMESTAMPDIFF(YEAR, a.data_nascimento, CURDATE()) AS idade,
    COUNT(h.id) AS total_visualizacoes,
    SUM(h.tempo_assistido_segundos) AS tempo_total_assistido_segundos
FROM assinantes a
INNER JOIN perfis pf ON pf.id_assinante = a.id
LEFT JOIN historicos_visualizacao h ON h.id_perfil = pf.id
GROUP BY a.id, a.uf, idade;

GRANT SELECT ON streamflow.vw_analise_assinantes TO 'auditoria';

-- stored procedures

-- 1.1 - cobrança mensal
DELIMITER //
DROP PROCEDURE IF EXISTS realizar_cobranca_mensal //
CREATE PROCEDURE realizar_cobranca_mensal(
    IN p_id_assinante INT,
    IN p_valor_mensalidade DECIMAL(10,2),
    OUT p_novo_saldo DECIMAL(10,2)
)
BEGIN
    DECLARE v_saldo_atual DECIMAL(10,2);

    SELECT saldo INTO v_saldo_atual
    FROM assinantes
    WHERE id = p_id_assinante;

    IF v_saldo_atual IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro: Assinante não encontrado.';
    ELSEIF v_saldo_atual < p_valor_mensalidade THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro (RN01): Saldo insuficiente para realizar a cobrança.';
    ELSE
        UPDATE assinantes
        SET saldo = saldo - p_valor_mensalidade
        WHERE id = p_id_assinante;

        SELECT saldo INTO p_novo_saldo
        FROM assinantes
        WHERE id = p_id_assinante;
    END IF;
END //

-- 1.2 - registro da reprodução pros logs
DROP PROCEDURE IF EXISTS registrar_reproducao //
CREATE PROCEDURE registrar_reproducao(
    IN p_id_perfil INT,
    IN p_id_video INT,
    IN p_ip VARCHAR(45),
    IN p_dispositivo VARCHAR(15),
    OUT p_log_id INT
)
BEGIN
    -- handler de erro em caso de violação de fk, foreign key, ou erro de inserção
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro de integridade: Perfil ou Video inexistente. Registro de reproducao cancelado.';
    END;

    START TRANSACTION;
    
    -- registra no log de reprodução
    INSERT INTO logs_reproducao (id_perfil, id_video, ip_origem, tipo_dispositivo, data_hora_evento)
    VALUES (p_id_perfil, p_id_video, p_ip, p_dispositivo, CURRENT_TIMESTAMP);

    SET p_log_id = LAST_INSERT_ID();

    -- insere também no histórico do usuário
    INSERT INTO historicos_visualizacao (id_perfil, id_video, tempo_assistido_segundos, concluido, data_inicio)
    VALUES (p_id_perfil, p_id_video, 0, FALSE, CURRENT_TIMESTAMP);

    COMMIT;
END //

-- 1.3 - gerar o faturamento mensal das produtoras
CREATE PROCEDURE gerar_faturamento_mensal(
    IN p_competencia DATE
)
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_produtora_id INT;
    DECLARE v_minutos INT;

    DECLARE cur_produtora CURSOR FOR 
        SELECT id FROM produtoras;
    -- é uma declaração que serve pra gerenciar os loops de cursores
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

    OPEN cur_produtora;

    read_loop: LOOP
        -- o fetch serve pra recuperar linhas de um conjunto ou navegar por um cursor
        FETCH cur_produtora INTO v_produtora_id;
        IF v_done THEN
            LEAVE read_loop;
        END IF;

        SET v_minutos = minutos_assistidos_por_produtora(v_produtora_id, p_competencia);

        INSERT INTO faturamento_produtoras (id_produtora, competencia, minutos_consumidos)
        VALUES (v_produtora_id, p_competencia, v_minutos)
        ON DUPLICATE KEY UPDATE minutos_consumidos = v_minutos;
    END LOOP;

    CLOSE cur_produtora;
END //

DELIMITER ;

-- stored functions

DELIMITER //

-- 1.4 - quantos minutos foram assistidos por produtora
CREATE FUNCTION minutos_assistidos_por_produtora(
    p_produtora_id INT,
    p_competencia DATE
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total_minutos INT DEFAULT 0;

    SELECT IFNULL(SUM(ROUND(v.duracao_seg / 60)), 0) INTO v_total_minutos
    FROM logs_reproducao r
    JOIN videos v ON r.id_video = v.id
    WHERE v.produtora_id = p_produtora_id
      AND DATE_FORMAT(r.data_hora_evento, '%Y-%m-01') = DATE_FORMAT(p_competencia, '%Y-%m-01');

    RETURN v_total_minutos;
END //

-- 1.5 - cálculo da idade
CREATE FUNCTION calcular_idade(p_data_nascimento DATE)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE());
END //



DELIMITER ;

-- procedures do app.sql
-- informações do assinante
DELIMITER //
CREATE PROCEDURE informacoes_assinantes(IN p_id INT)
BEGIN
    SELECT * FROM assinantes WHERE id = p_id;
END //

CREATE PROCEDURE criar_assinantes(
    IN p_nome VARCHAR(150), IN p_cpf CHAR(11), IN p_email VARCHAR(255), IN p_nasc DATE, IN p_uf CHAR(2)
)
BEGIN
    INSERT INTO assinantes (nome_completo, cpf, email, data_nascimento, uf)
    VALUES (p_nome, p_cpf, p_email, p_nasc, p_uf);
END //

-- inserir o saldo na conta do assinante
CREATE PROCEDURE inserir_saldo(IN p_id INT, IN p_valor DECIMAL(10, 2))
BEGIN
    UPDATE assinantes SET saldo = saldo + p_valor WHERE id = p_id;
END //

-- realizar cobrança da assinatura
CREATE PROCEDURE assinatura(IN p_id INT)
BEGIN
    DECLARE v_novo_saldo DECIMAL(10, 2);
    CALL realizar_cobranca_mensal(p_id, 39.90, v_novo_saldo);
END //

-- atualiza dados do assinante, como por exemplo UF
CREATE PROCEDURE atualizar_dados_assinantes(
    IN p_id INT, IN p_nome VARCHAR(150), IN p_cpf CHAR(11), IN p_email VARCHAR(255), IN p_nasc DATE, IN p_uf CHAR(2)
)
BEGIN
    UPDATE assinantes
    SET nome_completo = p_nome, cpf = p_cpf, email = p_email, data_nascimento = p_nasc, uf = p_uf
    WHERE id = p_id;
END //

-- lista os perfis atribuidos ao assinantes
CREATE PROCEDURE listar_perfis(IN p_id_assinante INT)
BEGIN
    SELECT * FROM perfis WHERE id_assinante = p_id_assinante AND ativo = TRUE;
END //

-- cria perfis baseados no assinante
CREATE PROCEDURE criar_perfis(IN p_id_assinante INT, IN p_nome VARCHAR(50))
BEGIN
    INSERT INTO perfis (id_assinante, nome_exibicao) VALUES (p_id_assinante, p_nome);
END //

-- atualiza perfis baseado no id deles
CREATE PROCEDURE atualizar_perfis(IN p_id_perfil INT, IN p_nome VARCHAR(50))
BEGIN
    UPDATE perfis SET nome_exibicao = p_nome WHERE id = p_id_perfil;
END //

-- desativa perfis
CREATE PROCEDURE desativar_perfis(IN p_id_perfil INT)
BEGIN
    UPDATE perfis SET ativo = FALSE WHERE id = p_id_perfil;
END //

-- registra preferencia de generos pro perfil
CREATE PROCEDURE registrar_preferencias(IN p_id_perfil INT, IN p_nome_genero VARCHAR(50))
BEGIN
    DECLARE v_id_genero INT;
    -- retorna NULL ao invés de dar aviso de nenhum registro
    SELECT MAX(id) INTO v_id_genero 
	FROM generos 
	WHERE nome = p_nome_genero;
    IF v_id_genero IS NOT NULL THEN
        INSERT IGNORE INTO perfis_preferencias (id_perfil, id_genero) VALUES (p_id_perfil, v_id_genero);
    END IF;
END //

-- lista as preferencias
CREATE PROCEDURE listar_preferencias(IN p_id_perfil INT)
BEGIN
    SELECT g.nome FROM generos g
    INNER JOIN perfis_preferencias pp ON pp.id_genero = g.id
    WHERE pp.id_perfil = p_id_perfil;
END //
-- remove completamente as preferencias
CREATE PROCEDURE remover_preferencias(IN p_id_perfil INT)
BEGIN
    DELETE FROM perfis_preferencias WHERE id_perfil = p_id_perfil;
END //
-- painel de continuar assistindo
CREATE PROCEDURE painel_continuar_assistindo(IN p_id_perfil INT)
BEGIN
    SELECT v.id, v.titulo, h.tempo_assistido_segundos, v.duracao_seg, h.data_ultima_atualizacao
    FROM historicos_visualizacao h
    INNER JOIN videos v ON v.id = h.id_video
    WHERE h.id_perfil = p_id_perfil AND h.concluido = FALSE
    ORDER BY h.data_ultima_atualizacao DESC;
END //

DELIMITER ;

-- triggers

DELIMITER //

-- 2.1
CREATE TRIGGER trg_valida_saldo_before_update
BEFORE UPDATE ON assinantes
FOR EACH ROW
BEGIN
    IF NEW.saldo < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Operacao cancelada: Saldo do assinante não pode ficar negativo.';
    END IF;
END //

-- 2.2
CREATE TRIGGER trg_bloqueia_update_historico
BEFORE UPDATE ON historicos_visualizacao
FOR EACH ROW
BEGIN
    IF OLD.concluido = TRUE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Operacao bloqueada: Registros de historico concluídos sao imutáveis.';
    END IF;
END //

CREATE TRIGGER trg_bloqueia_delete_historico
BEFORE DELETE ON historicos_visualizacao
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Operação bloqueada: Proibido apagar registros de historico de reprodução.';
END //

-- 2.3
CREATE TRIGGER trg_auditoria_perfis_update
AFTER UPDATE ON perfis
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_log (tabela, operacao, usuario, valor_antigo, valor_novo)
    VALUES (
        'perfis',
        'UPDATE',
        CURRENT_USER(),
        CONCAT('nome_exibicao: ', OLD.nome_exibicao, ', ativo: ', OLD.ativo),
        CONCAT('nome_exibicao: ', NEW.nome_exibicao, ', ativo: ', NEW.ativo)
    );
END //

-- 2.4
CREATE TRIGGER trg_saneamento_assinante_before_insert
BEFORE INSERT ON assinantes
FOR EACH ROW
BEGIN
    SET NEW.nome_completo = UPPER(TRIM(NEW.nome_completo));
END //

DELIMITER ;