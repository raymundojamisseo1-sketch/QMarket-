# QMarket — primeira versão de teste

QMarket é a evolução do protótipo Quitunda Market. A proposta é começar em Quitunda e crescer para outras regiões de Moçambique, permitindo anunciar e encontrar diferentes tipos de produtos.

## Incluído nesta versão
- Nome e identidade QMarket.
- Categorias para diferentes tipos de produtos.
- Pesquisa por nome, categoria, descrição e localização.
- Formulário para publicar um produto.
- Página de detalhes do produto.
- Formulário para registar um pedido com nome e telefone do comprador.
- Área de conta com contagem de produtos e pedidos da sessão.

## Limitações importantes
Esta é uma versão de demonstração local. Os produtos e pedidos ficam apenas na memória enquanto a aplicação está aberta e são apagados ao fechar a aplicação. Ainda não há contas reais, sincronização entre telemóveis, upload de fotografias, pagamentos, entregas ou painel administrativo. Não deve ser apresentada como marketplace operacional até essas funções serem implementadas e testadas.

## Preparar o projeto Flutter para Android
Este pacote contém os ficheiros de código e configuração, mas não inclui as pastas nativas Android geradas pelo Flutter.

Num computador com Flutter instalado, dentro desta pasta:

```bash
flutter create . --project-name qmarket --platforms android
flutter pub get
flutter run
```

Para gerar o APK de teste:

```bash
flutter build apk --release
```

O APK ficará em `build/app/outputs/flutter-apk/app-release.apk`.

## Próximas etapas
1. Testar a navegação e os formulários.
2. Guardar produtos e pedidos de forma permanente.
3. Criar contas de compradores e vendedores.
4. Sincronizar os dados entre dispositivos através de uma base de dados online.
5. Adicionar fotografias, contactos e fluxo de encomendas real.
6. Só depois avaliar pagamentos, entregas e publicação na Play Store.
