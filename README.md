# Esquema Conceitual — Oficina Mecânica

## Descrição do projeto

Este repositório contém a solução do desafio de modelagem conceitual para um sistema de controle e gerenciamento de execução de ordens de serviço em uma oficina mecânica.

O objetivo é representar, por meio de um diagrama entidade-relacionamento, as principais entidades, atributos e relacionamentos necessários para apoiar o processo descrito na narrativa:

- Clientes levam veículos à oficina para consertos ou revisões periódicas.
- Cada veículo é designado a uma equipe de mecânicos.
- A equipe identifica os serviços, avalia e executa os trabalhos.
- A oficina preenche uma Ordem de Serviço (OS) com data de entrega.
- O valor dos serviços é calculado com base em uma tabela de referência de mão de obra.
- O valor das peças também compõe a OS.
- O cliente autoriza a execução dos serviços.
- Uma OS pode conter vários serviços e várias peças.
- Um mesmo serviço ou peça pode estar presente em mais de uma OS.

## Entidades do modelo

- Cliente
- Veículo
- Equipe
- Mecânico
- Serviço
- Tabela de Referência de Mão de Obra
- Peça
- Ordem de Serviço
- Equipe_Mecânico
- OS_Serviço
- OS_Peça

## Principais relacionamentos

- Um cliente possui vários veículos.
- Um veículo pertence a um cliente.
- Uma equipe atende vários veículos.
- Uma equipe avalia e executa várias ordens de serviço.
- Uma ordem de serviço pertence a um veículo e é executada por uma equipe.
- Uma equipe é composta por vários mecânicos.
- Uma OS contém vários serviços e várias peças.
- Serviços e peças podem aparecer em várias OS.
- Cada serviço consulta uma tabela de referência de mão de obra.
- O cliente autoriza a execução da OS.

## Diagrama conceitual

O diagrama ER está representado no arquivo `diagrama.mmd` ou diretamente no README com Mermaid.

## Decisões e premissas adotadas

Como a narrativa não define todos os atributos, foram adotadas as seguintes premissas:

1. Cada veículo pertence a um único cliente.
2. Um cliente pode possuir vários veículos.
3. Cada veículo é designado a uma equipe; o modelo representa a designação atual.
4. Cada OS pertence a um veículo e é executada por uma equipe.
5. A mesma equipe que avalia é a que executa a OS, conforme a narrativa.
6. Um mecânico pode compor mais de uma equipe; por isso foi criada a entidade associativa `EQUIPE_MECANICO`.
7. O valor dos serviços é obtido a partir da tabela de referência de mão de obra.
8. Os valores efetivamente aplicados na OS são gravados nas entidades `OS_SERVICO` e `OS_PECA`, funcionando como “fotografia” do valor no momento da execução.
9. O campo `valor_total` da OS é derivado da soma dos subtotais de serviços e peças, mas foi mantido como atributo por conveniência.
10. A autorização do cliente foi representada por `autorizado` e `data_autorizacao` na OS, além do relacionamento com o cliente autorizador.
11. Foram incluídas `data_entrega_prevista` e `data_conclusao` para atender à narrativa.
12. Status sugeridos para a OS: Aberta, Aguardando autorização, Autorizada, Em execução, Concluída, Entregue, Cancelada.

## Como visualizar

O diagrama pode ser visualizado em ferramentas compatíveis com Mermaid, como GitHub, VS Code com extensão Mermaid ou Mermaid Live Editor.