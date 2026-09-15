USE streamflow;

-- fechamento do faturamento mensal
CALL gerar_faturamento_mensal('2026-05-01');

-- 2. relaório BI
SELECT 
    p.nome AS produtora,
    SUM(h.tempo_assistido_segundos) / 3600.0 AS total_horas_consumidas
FROM historicos_visualizacao h
INNER JOIN videos v ON v.id = h.id_video
INNER JOIN produtoras p ON p.id = v.produtora_id
WHERE h.data_inicio BETWEEN '2026-05-01' AND '2026-05-31 23:59:59'
GROUP BY p.id, p.nome
HAVING SUM(h.tempo_assistido_segundos) / 3600.0 > 5000
ORDER BY total_horas_consumidas DESC;

-- 3. extrato
SELECT 
    p.nome AS produtora,
    fp.competencia,
    fp.minutos_consumidos,
    ROUND(fp.minutos_consumidos / 60.0, 2) AS horas_consumidas
FROM faturamento_produtoras fp
INNER JOIN produtoras p ON p.id = fp.id_produtora
WHERE fp.competencia = '2026-05-01'
ORDER BY fp.minutos_consumidos DESC;

-- 4. consulta de catálogo
SELECT 
    v.id AS id_video,
    v.titulo,
    v.duracao_seg / 60.0 AS duracao_minutos,
    v.ativo
FROM videos v
WHERE v.produtora_id = 1
ORDER BY v.titulo ASC;