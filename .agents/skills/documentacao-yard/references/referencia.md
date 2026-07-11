# Referência YARD – Tags e Tipos (FleetMaster)

## Tags utilizadas no projeto

| Tag | Uso | Exemplo |
|-----|-----|---------|
| ` @param` | Parâmetro do método | ` @param usuario [User] O usuário que realiza a ação` |
| ` @return` | Valor de retorno | ` @return [Boolean] verdadeiro se sucesso` |
| ` @example` | Exemplo de uso | Bloco de código com chamada típica |
| ` @see` | Classe/módulo relacionado | ` @see OtherClass` |
| ` @raise` | Exceção possível | ` @raise [StandardError]` |
| ` @note` | Nota importante | ` @note Apenas para administradores` |

## Tipos comuns

- Primitivos: `String`, `Integer`, `Float`, `Boolean`, `Symbol`, `nil`
- Coleções: `Array`, `Hash`
- Opcionais: `[String, nil]`, `[Integer, nil]`
- Classes da App: `User`, `Company`, `Team`
- Genérico: `void` para nenhum retorno significativo.

## Formato @param

```ruby
 @param nome [Tipo] Breve descrição
```

## Formato @return

Sempre coloque uma **linha em branco** antes de ` @return`.

```ruby
 @return [Tipo] Descrição do retorno
```

## Formato @example

```ruby
# @example Uso básico
#   MyClass.new(arg: "valor").call
```
