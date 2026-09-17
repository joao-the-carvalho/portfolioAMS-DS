# Relatório de Testes — Sistema de Biblioteca Escolar

**Aluno(s):** João Victor de Paiva Carvalho e Cesar Moreno Fernandes
**Turma:** 3° DS AMS
**Data:** 17/09/2026  

---

## 1. Plano de Testes

| ID | Módulo | Tipo | Pré-condição | Ação | Resultado esperado | Resultado obtido | Status (P/F) |
|----|--------|------|--------------|------|--------------------|------------------|--------------|
| CT-01 | Geral | Não funcional / Usabilidade | Acessar qualquer página do sistema | Diminuir a quantidade de conteúdo da página | Header manter-se fixo no topo e Footer permanecer junto ao conteúdo ao final | Header fica fixo corretamente, mas Footer sobe e descola do final da página em telas curtas | F |
| CT-02 | Geral | Não funcional / Acessibilidade | Navegar pelas páginas e inspecionar elementos | Verificar contraste das cores dos textos e elementos de interface | Textos com contraste adequado conforme normas WCAG | Diversos textos apresentam baixo contraste com o fundo | F |
| CT-03 | Geral | Não funcional / Responsividade | Acessar a aplicação em telas pequenas (mobile) | Visualizar tabelas nos módulos Alunos, Livros e Empréstimos | Tabelas com rolagem horizontal em telas menores | Tabelas quebram o layout e não possuem scroll horizontal | F |
| CT-04 | Geral | Não funcional / Acessibilidade | Utilizar navegação por teclado (Tecla Tab) | Navegar pelos elementos interativos da página | Foco visível e com alto contraste nos elementos selecionados | Borda padrão sem destaque e texto do footer com contraste muito baixo | F |
| CT-05 | Home | Funcional / Caixa preta | Existir dados cadastrados no sistema | Acessar o Painel Principal (Home) | Exibir corretamente o total de livros, alunos e empréstimos cadastrados | Os totais correspondem exatamente aos dados cadastrados | P |
| CT-06 | Home | Funcional / Caixa preta | Existir empréstimos com mais de 14 dias | Verificar a tabela de empréstimos atrasados no Painel | Exibir os empréstimos em atraso corretamente | A tabela de empréstimos reflete os dados esperados | P |
| CT-07 | Alunos | Funcional / Caixa preta | Existir ao menos um aluno cadastrado | Clicar na opção de excluir aluno | O aluno ser removido da listagem e do banco de dados | A exclusão falha e o aluno permanece cadastrado | F |
| CT-08 | Alunos | Caixa cinza / Integração | Modal de confirmação de exclusão aberto | Clicar no botão de exclusão dentro do modal | Disparar requisição para remoção no banco de dados | O botão do modal não envia a requisição HTTP para o banco de dados | F |
| CT-09 | Alunos | Segurança / Caixa preta | Estar na tela de cadastro de alunos | Inserir o script <script>alert(1)</script> no campo Nome e salvar | O nome ser escapado e exibido como texto puro | O script é executado via XSS na listagem de alunos | F |
| CT-10 | Alunos | Funcional / Caixa branca | Acessar formulário de cadastro de alunos | Tentar cadastrar aluno apenas preenchendo Nome e E-mail | Cadastrar o aluno com sucesso, tratando os demais campos como opcionais | Cadastro efetuado com sucesso (apenas Nome e E-mail são obrigatórios) | P |
| CT-11 | Alunos | Segurança / Caixa branca | Existir aluno com payload XSS cadastrado | Realizar uma busca pelo nome do aluno | Escapar os termos buscados na exibição da busca | O script é executado ao carregar os resultados da busca (XSS) | F |
| CT-12 | Alunos | Funcional / Caixa branca | Cadastrar um novo aluno | Salvar o formulário e verificar a mensagem de confirmação | Exibir mensagem de sucesso após a criação do aluno | A mensagem de criação não é exibida na interface (código morto/erro silencioso) | F |
| CT-13 | Alunos | Caixa cinza / Caixa branca | Ter o código fonte acessível | Verificar a presença das opções de edição e exclusão na interface | Existir botões funcionais para editar e deletar alunos | Embora os métodos existam no backend (app/models/), não há interface para editar nem a exclusão funciona | F |
| CT-14 | Livros | Regra de Negócio / Caixa preta | Cadastrar/consultar livro com quantidade 0 | Tentar realizar o empréstimo de um livro com quantidade disponível igual a 0 | O sistema deve bloquear o empréstimo | O sistema permite emprestar o livro, tornando a quantidade disponível negativa | F |
| CT-15 | Livros | Funcional / Caixa preta | Estar na tela de cadastro de livros | Preencher o campo "Ano" com o valor 0 | Aceitar apenas anos válidos positivos conforme regra de negócio | O sistema aceita o ano 0 e qualquer outro número positivo | F |
| CT-16 | Livros | Funcional / Caixa branca | Preencher formulário de cadastro de livros | Cadastrar livro deixando apenas o campo ISBN em branco | Cadastrar o livro com sucesso | Cadastro efetuado com sucesso (único campo não obrigatório é o ISBN) | P |
| CT-17 | Livros | Segurança / Caixa preta | Formulário de cadastro de livros | Inserir código de script no título do livro | Tratar a entrada para evitar XSS | O script executou na página ao renderizar o título do livro | F |
| CT-18 | Livros | Caixa branca / Manutenibilidade | Analisar os métodos da model de Livros | Tentar editar ou excluir um livro cadastrado através da interface | Botões de ação dispostos na tabela de livros | Não existe opção/botão na interface para editar ou excluir livros, apesar dos métodos existirem no código | F |
| CT-19 | Empréstimos | Segurança / Caixa preta | Alunos/Livros cadastrados com scripts no nome | Navegar até a página do módulo de Empréstimos | Exibir nomes higienizados na seleção e na tabela | Os scripts armazenados nos nomes são executados na tela de empréstimos | F |
| CT-20 | Empréstimos | Regra de Negócio / Caixa preta | Livro com estoque 0 e aluno sem pendências | Realizar a solicitação de empréstimo | Exibir mensagem informando indisponibilidade do livro | O empréstimo é concedido com sucesso | F |
| CT-21 | Empréstimos | Funcional / Caixa preta | Existir registros de empréstimo no banco | Acessar a listagem do módulo de Empréstimos | Exibir a lista de empréstimos e seus respectivos status | A tabela exibe os empréstimos cadastrados corretamente | P |

---

## 2. Defeitos Encontrados

### Defeito #1

```

Módulo/Arquivo: Geral / Layout & CSS
Categoria: Não funcional / Usabilidade / Acessibilidade
Tipo de teste que detectou: Caixa preta / Não funcional
Como reproduzir:

1. Navegue para qualquer página do sistema que possua pouco conteúdo (ex: uma listagem vazia).
2. Observe a posição do Header e do Footer.
3. Alterne o foco entre os elementos usando a tecla TAB.
Resultado esperado: Header fixo no topo, Footer colado no final da página (Sticky Footer), borda de foco visível e cores com contraste mínimo de acordo com a WCAG.
Resultado obtido: O Header permanece fixo, mas o Footer descola do rodapé da tela. Há diversos problemas de baixo contraste e o indicador de foco de teclado (outline) é quase imperceptível.
Gravidade: Baixa
Prioridade: 4
Causa provável: Ausência de estrutura Flexbox/Grid no `body` para empurrar o footer ao rodapé (`min-height: 100vh`) e falta de estilização CSS adequada para `:focus` e regras de contraste WCAG.
Proposta de solução:
Ajustar o CSS global do layout:

body {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}
main {
  flex: 1;
}
footer {
  margin-top: auto;
  color: #212529; /* Aumento do contraste do texto */
}
:focus-visible {
  outline: 2px solid #0d6efd !important;
  outline-offset: 2px;
}

Teste de regressão: Reduzir a resolução da tela e a quantidade de conteúdo, navegando via teclado com a tecla TAB para verificar se o footer se mantém na base e o foco visível.

```

---

### Defeito #2

```

Módulo/Arquivo: Geral / CSS Responsivo
Categoria: Não funcional / Responsividade
Tipo de teste que detectou: Não funcional
Como reproduzir:

1. Reduza a largura da janela do navegador para uma dimensão mobile (ex: 375px ou 414px).
2. Acesse as páginas de Alunos, Livros e Empréstimos.
3. Tente visualizar todas as colunas da tabela.
Resultado esperado: As tabelas devem possuir um container com rolagem horizontal (`overflow-x: auto`) permitindo a navegação no celular sem quebrar o layout global.
Resultado obtido: As tabelas estouram a largura da tela, sem rolagem interna, quebrando a responsividade do layout.
Gravidade: Média
Prioridade: 3
Causa provável: Faltou envolver as tabelas HTML em uma `<div>` com classe de responsividade (ex: `.table-responsive` do Bootstrap ou estilo equivalente).
Proposta de solução:
Envolver as tabelas no código HTML:

<div style="overflow-x: auto;">
  <table class="table">
    <!-- Conteúdo da Tabela -->
  </table>
</div>

Teste de regressão: Inspecionar o sistema em dispositivos móveis e simular touch/scroll horizontal sobre as tabelas.

```

---

### Defeito #3

```

Módulo/Arquivo: Alunos / `app/views/alunos/index.php` (ou equivalente)
Categoria: Segurança / Vulnerabilidade
Tipo de teste que detectou: Caixa preta / Caixa branca
Como reproduzir:

1. Acesse a tela de cadastro de alunos.
2. No campo Nome, informe: alert('XSS-Aluno').
3. Salve o cadastro.
4. Acesse a listagem de alunos ou realize uma busca pelo nome.
Resultado esperado: O nome do aluno deve ser exibido sanitizado/escapado na tela, como texto literal (`&lt;script&gt;...`).
Resultado obtido: O script é interpretado pelo navegador e a caixa de alerta dispara.
Gravidade: Crítica
Prioridade: 1
Causa provável: Uso de impressão direta de variáveis PHP no HTML (`<?= $aluno['nome'] ?>`) sem a devida sanitização com `htmlspecialchars()`.
Proposta de solução:
Alterar a renderização da variável no arquivo de visão:

<!-- De: -->
<td><?= $aluno['nome']; ?></td>

<!-- Para: -->
<td><?= htmlspecialchars($aluno['nome'], ENT_QUOTES, 'UTF-8'); ?></td>

Teste de regressão: Tentar cadastrar e buscar o aluno com o payload novamente e assegurar que a string é renderizada literalmente como texto, sem executar JS.

```

---

### Defeito #4

```

Módulo/Arquivo: Alunos / Modal de Exclusão & Controller/Model de Alunos
Categoria: Funcional / Integração
Tipo de teste que detectou: Caixa cinza
Como reproduzir:

1. Vá até a listagem de Alunos.
2. Clicar no botão de excluir algum aluno para abrir o modal de confirmação.
3. Clicar no botão "Confirmar Exclusão" dentro do modal.
Resultado esperado: O formulário do modal deve enviar uma requisição POST/DELETE para o backend e remover o aluno da base.
Resultado obtido: O modal fecha ou ignora a ação sem enviar nenhuma requisição HTTP ao banco de dados; o aluno permanece cadastrado.
Gravidade: Alta
Prioridade: 2
Causa provável: O botão do modal não está associado a um formulário HTML ou não possui evento JavaScript ligado para disparar a submissão da requisição ao servidor.
Proposta de solução:
Ajustar o botão no modal para incluir o formulário correto e ação de envio:

<form action="/alunos/deletar" method="POST">
  <input type="hidden" name="id" value="<?= $aluno['id']; ?>">
  <button type="submit" class="btn btn-danger">Confirmar Exclusão</button>
</form>

Teste de regressão: Clicar no botão de exclusão do modal e validar se o registro é deletado do banco de dados e sumindo da listagem.

```

---

### Defeito #5

```

Módulo/Arquivo: Alunos / `app/controllers/AlunoController.php` (ou equivalente)
Categoria: Funcional / Usabilidade (Código Morto / Feedback)
Tipo de teste que detectou: Caixa branca
Como reproduzir:

1. Preencha os campos obrigatórios (Nome e E-mail) do formulário de alunos.
2. Submeta o formulário.
Resultado esperado: O usuário deve ser redirecionado para a listagem e receber uma mensagem de sucesso "Aluno cadastrado com sucesso!".
Resultado obtido: O aluno é inserido no banco, porém nenhuma mensagem de confirmação/sucesso é apresentada ao usuário.
Gravidade: Baixa
Prioridade: 4
Causa provável: A mensagem de flash/sessão é definida no controller, mas não há código na View responsável por ler a sessão e renderizar o componente de alerta.
Proposta de solução:
Adicionar a checagem e renderização da mensagem no topo da View de Alunos:

<?php if (isset($_SESSION['mensagem'])): ?>
  <div class="alert alert-success">
    <?= htmlspecialchars($_SESSION['mensagem']); ?>
    <?php unset($_SESSION['mensagem']); ?>
  </div>
<?php endif; ?>

Teste de regressão: Cadastrar um novo aluno e verificar se o banner verde com a mensagem de sucesso passa a ser exibido.

```

---

### Defeito #6

```

Módulo/Arquivo: Alunos e Livros / Views de Listagem
Categoria: Funcional / Manutenibilidade (Incompletude da Interface)
Tipo de teste que detectou: Caixa branca / Caixa cinza
Como reproduzir:

1. Acessar os módulos de Alunos e Livros.
2. Inspecionar as colunas da tabela de registros.
3. Verificar o código-fonte em `app/models/` ou `app/controllers/`.
Resultado esperado: Haver botões "Editar" e "Excluir" operacionais na interface para consumir os métodos existentes no backend.
Resultado obtido: Embora os métodos de alteração e exclusão existam no código das Models, a interface gráfica não fornece opções/links para acioná-los (com exceção do modal quebrado em alunos).
Gravidade: Média
Prioridade: 3
Causa provável: As Views não foram finalizadas e deixaram de implementar os links/botões de ação para a edição e exclusão de registros.
Proposta de solução:
Adicionar a coluna de Ações na tabela HTML das Views:

<td>
  <a href="/livros/editar/<?= $livro['id']; ?>" class="btn btn-warning">Editar</a>
  <a href="/livros/deletar/<?= $livro['id']; ?>" class="btn btn-danger">Excluir</a>
</td>

Teste de regressão: Navegar até a lista de livros/alunos, clicar nos botões criados e certificar-se de que os fluxos de edição e exclusão funcionam.

```

---

### Defeito #7

```

Módulo/Arquivo: Livros / `app/models/Livro.php` ou `EmprestimoController.php`
Categoria: Regra de Negócio / Funcional
Tipo de teste que detectou: Caixa preta / Regra de negócio
Como reproduzir:

1. Identifique um livro que possua quantidade disponível igual a `0` (ou cadastre um com quantidade `0`).
2. Vá ao módulo de Empréstimos e tente efetuar o empréstimo deste livro para um aluno.
Resultado esperado: O sistema deve validar o estoque e impedir a transação com a mensagem "Livro indisponível para empréstimo".
Resultado obtido: O sistema autoriza o empréstimo normalmente e altera o estoque do livro para valores negativos (ex: `-1`).
Gravidade: Alta
Prioridade: 1
Causa provável: Falta de validação condicional no backend no momento de registrar o empréstimo (`if ($livro['quantidade'] <= 0)`).
Proposta de solução:
Incluir validação antes da inserção do empréstimo:

if ($livro['quantidade'] <= 0) {
    throw new Exception("Não é possível emprestar um livro com quantidade zerada.");
}

Teste de regressão: Tentar realizar o empréstimo de um livro sem saldo em estoque e verificar se o sistema bloqueia e mantém o saldo zerado sem alterar para negativo.

```

---

### Defeito #8

```

Módulo/Arquivo: Livros / Validação de Formulário (`LivroController.php`)
Categoria: Funcional / Regra de Negócio
Tipo de teste que detectou: Caixa preta
Como reproduzir:

1. Abra o formulário de cadastro de Livros.
2. Preencha os campos obrigatórios e insira o valor `0` no campo "Ano".
3. Envie o formulário.
Resultado esperado: O sistema deve rejeitar o valor `0` para o ano do livro, exigindo um ano válido (ex: superior a 1000 e menor ou igual ao ano atual).
Resultado obtido: O cadastro é realizado aceitando o ano `0`.
Gravidade: Baixa
Prioridade: 4
Causa provável: A validação do campo no backend verifica apenas se o campo é numérico ou não vazio (`empty()`), onde `0` é aceito.
Proposta de solução:
Adicionar regra de validação no controller:

if ($ano <= 0 || $ano > date('Y')) {
    $erros[] = "Por favor, informe um ano válido.";
}

Teste de regressão: Tentar salvar um livro com ano `0` ou negativo e validar se a mensagem de erro é apresentada.

```

---

### Defeito #9

```

Módulo/Arquivo: Livros / `app/views/livros/index.php`
Categoria: Segurança / Vulnerabilidade
Tipo de teste que detectou: Caixa preta
Como reproduzir:

1. Abra o cadastro de livros.
2. Cadastre um livro com o título `<script>alert('XSS-Livro')</script>`.
3. Salve e navegue até a listagem de livros.
Resultado esperado: O título deve ser exibido sanitizado na tabela.
Resultado obtido: O script malicioso é executado no navegador ao carregar a página de listagem.
Gravidade: Crítica
Prioridade: 1
Causa provável: Falta de tratamento de escaping no HTML para a propriedade de título do livro.
Proposta de solução:
Sanitizar o output no arquivo de visão:

<td><?= htmlspecialchars($livro['titulo'], ENT_QUOTES, 'UTF-8'); ?></td>

Teste de regressão: Acessar a página com o livro cadastrado e checar se o título aparece em texto puro sem disparar scripts.

```

---

### Defeito #10

```

Módulo/Arquivo: Empréstimos / `app/views/emprestimos/index.php` ou `form.php`
Categoria: Segurança / Vulnerabilidade
Tipo de teste que detectou: Caixa preta
Como reproduzir:

1. Cadastre um aluno e um livro contendo payloads XSS em seus nomes.
2. Navegue até o módulo de Empréstimos.
3. Abra os selects ou a tabela de listagem de empréstimos.
Resultado esperado: Nomes de alunos e títulos de livros sanitizados nos selects e nas tabelas.
Resultado obtido: Os scripts são herdados e executados novamente dentro do módulo de Empréstimos.
Gravidade: Crítica
Prioridade: 1
Causa provável: Ausência do uso de `htmlspecialchars()` na montagem dos elementos `<option>` e células `<td>` da tela de empréstimos.
Proposta de solução:
Aplicar sanitização nos elementos do formulário e da listagem de empréstimos:

<option value="<?= $aluno['id']; ?>">
  <?= htmlspecialchars($aluno['nome'], ENT_QUOTES, 'UTF-8'); ?>
</option>

Teste de regressão: Abrir a página de Empréstimos com os registros infectados cadastrados e confirmar que nenhum script é executado.

```


---

## 3. Classificação e Estatísticas

- **Total de casos de teste executados:** 21
- **Total de casos aprovados:** 4
- **Total de casos reprovados:** 17

### Nº de defeitos por categoria:
- **Funcional / Regra de Negócio:** 5
- **Segurança (XSS):** 3
- **Não Funcional (Acessibilidade / Responsividade / Layout):** 4
- **Incompletude de Código / Feedback ao Usuário (Código Morto / Erro Silencioso):** 3
- **Integração / Formulário Modal:** 2

### Nº de defeitos por gravidade:
- **Crítica:** 4 (Ataques de XSS em Alunos, Livros e Empréstimos)
- **Alta:** 2 (Lógica de Empréstimo com estoque zerado/negativo e Falha de Exclusão no Modal)
- **Média:** 2 (Responsividade de Tabelas e Recursos Incompletos/Código Morto na Interface)
- **Baixa:** 2 (Estilização de Layout/Acessibilidade e Cadastro com Ano '0')

---

## 4. Conclusão

Com esses testes funcionais, não funcionais, caixa preta, cinza e branca no sistema de biblioteca escolar, foi possível identificar que, mesmo que tudo parece funcionar sem apitar erros que quebrem o site, ainda existem muitas falhas críticas que comprometem a experiência do usuário, desde o UX, até a lógica de algumas funcionalidades básicas no projeto.
Essa atividade comprova o quanto a segurança e os testes de software são essenciais para uma aplicação em produção, e qualquer cuidado é pouco.

Principais aprendizados e apontamentos:
1. **Consistência de Regras de Negócio:** O sistema tolera estados inválidos na base de dados, permitindo estoque negativo de livros e aceitação de anos zerados.
2. **Usabilidade e Acessibilidade:** Problemas em responsividade mobile (tabelas) e falhas de contraste limitam a experiência do usuário.
3. **Alinhamento do Código com a Interface e conscientização sobre código morto:** Foram encontrados métodos nos modelos sem representação visual na interface do usuário (ex: edição de livros e alunos), além de modais com falta de ligação   para ações no banco de dados.

**Sugestões de melhoria:**
- Implementar sanitização centralizada via helper/função global em PHP para todas as saídas no HTML.
- Adicionar validações de formulário tanto no front-end (HTML5) quanto no back-end antes de persistir dados no banco.
- Adicionar uma camada de testes automatizados (unitários com PHPUnit) para assegurar as regras de negócio de empréstimo de estoque zero e limites por aluno.
- Atualizar as folhas de estilo CSS utilizando classes utilitárias responsivas e padrões WCAG de contraste e acessibilidade.
