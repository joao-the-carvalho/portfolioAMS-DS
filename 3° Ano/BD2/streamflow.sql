
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
    data_cadastro   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE formas_pagamento (
    id              INT AUTO_INCREMENT NOT NULL UNIQUE PRIMARY KEY,
    id_assinante    INT NOT NULL,
    tipo            VARCHAR(20) NOT NULL CHECK (tipo IN ('CARTAO_CREDITO', 'DEBITO', 'PIX', 'BOLETO')),
    token_cartao    VARCHAR(255), -- token em vez do número real do cartão, evitando guardar dado sensível em texto puro
    CONSTRAINT fk_pagamento_assinante FOREIGN KEY (id_assinante)
        REFERENCES assinantes(id) ON DELETE CASCADE
);


CREATE TABLE perfis (
    id              INT AUTO_INCREMENT NOT NULL UNIQUE PRIMARY KEY,
    id_assinante    INT NOT NULL,
    nome_exibicao   VARCHAR(50) NOT NULL,
    classificacao   VARCHAR(10) NOT NULL DEFAULT 'LIVRE' CHECK (classificacao IN ('ADULTO', 'LIVRE')),
    data_criacao    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_perfil_assinante FOREIGN KEY (id_assinante)
        REFERENCES assinantes(id) ON DELETE CASCADE
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

-- roles
CREATE ROLE 'app_streamflow';
GRANT SELECT, INSERT, UPDATE, DELETE ON streamflow.assinantes TO 'app_streamflow';
GRANT SELECT, INSERT, UPDATE, DELETE ON streamflow.perfis TO 'app_streamflow';
GRANT SELECT, INSERT, UPDATE, DELETE ON streamflow.formas_pagamento TO 'app_streamflow';
GRANT SELECT, INSERT, UPDATE, DELETE ON streamflow.historicos_visualizacao TO 'app_streamflow';
GRANT SELECT ON streamflow.videos TO 'app_streamflow';
GRANT SELECT ON streamflow.filmes TO 'app_streamflow';
GRANT SELECT ON streamflow.episodios TO 'app_streamflow';
GRANT SELECT ON streamflow.series TO 'app_streamflow';
GRANT SELECT ON streamflow.produtoras TO 'app_streamflow';
GRANT SELECT, INSERT ON streamflow.logs_reproducao TO 'app_streamflow'; -- sem UPDATE/DELETE: imutabilidade

CREATE ROLE 'auditoria';
GRANT SELECT ON streamflow.logs_reproducao TO 'auditoria';
GRANT SELECT ON streamflow.historicos_visualizacao TO 'auditoria';
-- Nenhum GRANT em assinantes/formas_pagamento -> auditoria não acessa dados sensíveis

CREATE USER 'usuario_app'@'%' IDENTIFIED BY 'senha_segura';
GRANT 'app_streamflow' TO 'usuario_app'@'%';
SET DEFAULT ROLE 'app_streamflow' TO 'usuario_app'@'%';

CREATE USER 'usuario_auditor'@'%' IDENTIFIED BY 'senha_segura2';
GRANT 'auditoria' TO 'usuario_auditor'@'%';
SET DEFAULT ROLE 'auditoria' TO 'usuario_auditor'@'%';

-- consultas
SELECT v.id, v.titulo, h.tempo_assistido_segundos, v.duracao_seg, h.data_ultima_atualizacao
FROM historicos_visualizacao h
INNER JOIN videos v ON v.id = h.id_video
WHERE h.id_perfil = 1          -- parâmetro: id do perfil logado
  AND h.concluido = FALSE
ORDER BY h.data_ultima_atualizacao DESC;

SELECT p.nome,
       SUM(h.tempo_assistido_segundos) / 3600.0 AS horas_consumidas
FROM historicos_visualizacao h
INNER JOIN videos v ON v.id = h.id_video
INNER JOIN produtoras p ON p.id = v.produtora_id
WHERE h.data_inicio BETWEEN '2026-05-01' AND '2026-05-31 23:59:59'
GROUP BY p.id, p.nome
HAVING SUM(h.tempo_assistido_segundos) / 3600.0 > 5000
ORDER BY horas_consumidas DESC;

SELECT a.uf, l.tipo_dispositivo, COUNT(*) AS total_acessos
FROM logs_reproducao l
INNER JOIN perfis pf ON pf.id = l.id_perfil
INNER JOIN assinantes a ON a.id = pf.id_assinante
GROUP BY a.uf, l.tipo_dispositivo
ORDER BY a.uf, total_acessos DESC;

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