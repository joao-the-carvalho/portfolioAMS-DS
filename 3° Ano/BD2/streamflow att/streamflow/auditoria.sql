USE streamflow;

-- 1. LGPD
SELECT 
    id AS id_assinante,
    uf,
    idade,
    total_visualizacoes,
    tempo_total_assistido_segundos / 3600.0 AS horas_assistidas
FROM vw_analise_assinantes
ORDER BY horas_assistidas DESC;

-- 2. auditoria de tráfego
SELECT 
    a.uf, 
    l.tipo_dispositivo, 
    COUNT(*) AS total_acessos
FROM logs_reproducao l
INNER JOIN perfis pf ON pf.id = l.id_perfil
INNER JOIN assinantes a ON a.id = pf.id_assinante
GROUP BY a.uf, l.tipo_dispositivo
ORDER BY a.uf ASC, total_acessos DESC;

-- 3. log interno
SELECT 
    id,
    tabela,
    operacao,
    usuario,
    valor_antigo,
    valor_novo,
    data_hora
FROM auditoria_log
ORDER BY data_hora DESC;