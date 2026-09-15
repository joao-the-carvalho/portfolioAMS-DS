USE streamflow;

-- 1.1 chama a procedure para cadastrar um novo assinante
CALL criar_assinantes(
    'Cesar Pires Lopes', 
    '98765432100', 
    'cesarpl@gmail.com', 
    '2002-11-09', 
    'SP'
);

-- 1.2 recupera dados de um assinante
CALL informacoes_assinantes(1);

-- 1.3 adiciona crédito na conta de um assinante
CALL inserir_saldo(1, 150.00);

-- 1.4 cobrança da mensalidade
CALL assinatura(1);

-- 1.5 atualizar dados cadastrais (para, por exemplo, mudar o UF)
CALL atualizar_dados_assinantes(
    1, 
    'Cesar Pires Lopes', 
    '98765432100', 
    'cesarpl@gmail.com', 
    '2002-11-09', 
    'MG'
);

-- 2.1 cria perfis que são dependentes na conta do assinante
CALL criar_perfis(1, 'João');
CALL criar_perfis(1, 'Espaço Kids');
CALL criar_perfis(1, 'Perfil da Sala');

-- 2.2 listar os perfis ativos associados à conta
CALL listar_perfis(1);

-- 2.3 renomeia um perfil existente
CALL atualizar_perfis(1, 'João - Séries');

-- 2.4 Registrar preferências de conteúdo para o perfil principal
CALL registrar_preferencias(1, 'Ficção Científica');
CALL registrar_preferencias(1, 'Comédia');

-- 2.5 Consultar preferências registradas do perfil
CALL listar_preferencias(1);

-- 2.6 Limpar e redefinir preferências do perfil
CALL remover_preferencias(1);
CALL registrar_preferencias(1, 'Ação');

-- 2.7 Desativar um perfil secundário (ex: exclusão lógica)
CALL desativar_perfis(3);

-- 3.1 Registrar evento de "Play" em um filme/episódio (Gera Log e Histórico)
CALL registrar_reproducao(1, 1, '189.23.45.12', 'SMARTTV', @log_reproducao_id);

-- Exibir o ID do log de reprodução gerado na transação
SELECT @log_reproducao_id AS id_evento_log;

-- 3.2 Consultar painel da tela inicial ("Continuar Assistindo")
CALL painel_continuar_assistindo(1);