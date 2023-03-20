# ModulbankInformer

<img src="https://cdn.githubraw.com/makoni/ModulbankInformer/main/screenshot1.png">

[![Platforms](https://img.shields.io/badge/platforms-macOS%2013-ff0000.svg?style=flat)](https://github.com/makoni/ModulbankInformer) [![Swift 5](https://img.shields.io/badge/swift-5.7.2-orange.svg?style=flat)](http://swift.org)

Модульбанк Информер - простое приложение для статус-бара macOS, которое показывает баланс средств на счетах, включая остаток на транзитных счетах, используя API Модульбанка. 

### Как подключить
Для использования приложения сгенерируйте ключ API в Личном Кабинете Модульбанка:
<img src="https://cdn.githubraw.com/makoni/ModulbankInformer/main/api-key-1.png">

Для отображения баланса достаточно выбрать "account-info". Нажмите Сгенерировать и вставьте ключ API в приложении.
<img src="https://cdn.githubraw.com/makoni/ModulbankInformer/main/api-key-2.png">

Ключ API хранится безопасно в macOS внутри Keychain. В любой момент его можно удалить, нажав в приложении "Отозвать доступ", или запустив приложение Keychain Access (Связка Ключей) и набрав в поле поиска ModulbankInformer. Кроме того, в ключ всегда можно отозвать в Личном Кабинете Модульбанка.
