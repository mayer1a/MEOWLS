<p align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://static.artemayer.ru/images/github/logo-wc/meowls-logo-wc.png">
  <source media="(prefers-color-scheme: light)" srcset="https://static.artemayer.ru/images/github/logo-bc/meowls-logo-bc.png">
  <img src="https://static.artemayer.ru/images/github/logo-bc/meowls-logo-bc.png" height="140" alt="MEOWLS">
</picture> 
</p>

<br>

**MEOWLS** — мобильное приложение для iOS, которое предлагает пользователям удобную платформу покупки товаров для домашних животных. Приложение имеет два режима: Store для клиентов и POS для сотрудников.

## Содержание

- [Основные возможности](#основные-возможности)
- [Технологии и инструменты](#технологии-и-инструменты)
- [Структура проекта](#структура-проекта)
- [Внешний вид приложения](#внешний-вид-приложения)
- [Развертывание и запуск](#развертывание-и-запуск)
  - [1. Установка Homebrew](#1-установка-homebrew)
  - [2. Установка brew пакетов из Brewfile](#2-установка-brew-пакетов-из-brewfile)
  - [3. Установка Bundler](#3-установка-bundler)
  - [4. Установка гемов из Gemfile](#4-установка-гемов-из-gemfile)
  - [5. Сборка проекта скриптом setup](#5-сборка-проекта-скриптом-setup)
  - [6. Выбор таргета и сборка проекта](#6-выбор-таргета-и-сборка-проекта)
- [Тестирование](#тестирование)
  - [1. Запуск тестов из Xcode](#1-запуск-тестов-из-xcode)
  - [2. Запуск тестов через Fastlane](#2-запуск-тестов-через-fastlane)
- [Поддержка и вклад](#поддержка-и-вклад)
- [Помощь](#помощь)
- [Благодарность](#благодарность)
- [Лицензия](#лицензия)

---


## Основные возможности

- [X] **Главная страница**: Экран с автоматическими и обычными слайдерами баннеров, статическими баннерами, текущими акциями, скидками, подборками товаров;
- [X] **Поиск**: Возможность поиска интересующего товара или категории;
- [X] **Избранное**: Любимые товары, отмеченные сердечком не потеряются. Поддержка сохранения избранных товаров и для неавторизованного пользователя, с последующей синхронизацией (merge) с уже избранными товарами после авторизации;
- [X] **Авторизация**: Экран входа, чтобы ничего не потерять. Возможность просмотреть пользовательское соглашение и политику конфиденциальности;
- [X] **Регистрация**: Если еще нет аккаунта, его легко создать; После регистрации выполняется автоматический вход в аккаунт;
    - [X] При авторизации или регистрации выполняется синхронизация корзины, избранного, если там есть товары;
- [ ] **Каталог**: Просмотр товаров по выбранным категориям или сразу всех;
- [ ] **Листинг товаров**: Возможность посмотреть товары, добавить в корзину/избранное, не открывая товар, применить желаемые фильтры и сортировку или открыть выбранный товар;
- [ ] **Карточка товара**: Детально изучите выбранный товар, посмотрите нужную информацию, изображения;
- [ ] **Корзина**: Добавляйте товары для того, чтобы их не потерять и купить по выгодной цене;
- [ ] **Оформление заказа/Чекаут**: Заполните необходимую информацию об адресе доставки, времени получении, получателе и способе оплаты;
- [ ] **Заказы**: Ваши предыдущие заказы;
- [ ] **Профиль пользователя**: Возможность перейти в нужные разделы приложения, просмотреть/изменить личную информацию, открыть совершенные заказы, контактную информацию, выйти из аккаунта или его удалить;


## Технологии и инструменты

- **Swift**: Язык проекта;
- **Архитектура**: MVVM+State Machine+Router (UIKit), MVVM+Observation+Router (SwiftUI+Combine);
- **Паттерны**: Фабрика, Билдер, Синглтон, Стратегия+Команда;
- **SOLID, DRY, KISS, YAGNI**: Разработка придерживающаяся этих принципов;
- **UI**: UIKit, SwiftUI. Верстка кодом. Кастомные переиспользуемые компоненты;
- **Изображения**: Kingfisher + кеширование;
- **Сеть**: Alamofire, кастомные обертки APIWrapper, APIService. Работа с сервером посредством REST-API, кодирование/декодирование данных. Пагинация запросов (кастомный Paginator);
- **Многопоточность и асинхронность**: GCD, async/await, Task;
- **Dependency Injection**: [Factory](https://github.com/hmlongco/Factory) + вся инъекция через протоколы;
- **Хранение данных**: Обертки над Keychain, UserDefaults;
- **Безопасность**: Часть запросов покрываются токеном со сроком действия, поддержка обновления токена или предложения повторной авторизации.
- **Fastlane**: Автоматизация процессов сборки, тестирования и эмулирование развертывания. При МР в develop или main запускает сборку проекта, тесты для двух таргетов для получения возможности влить изменения;
- **GitHub Actions + self-hosted runner**;
- **XcodeGen**: Автоматизация и предотвращение проблем, связанных с ручной правкой .xcodeproj. Сборка проекта на раннере;
- **SwiftGen**: Генерация кода для изображений, цветов;
- **Поддержка нескольких языков**: Локализация строк для русского и английского языков;
- ~~**Ошибки и аналитика**: Firebase~~


## Структура проекта

<details>
  <summary>
    <b>👀 РАСКРЫТЬ СТРУКТУРУ</b>
  </summary>
  <br>
  
  ```plaintext
.
├── MEOWLS
│   ├── Store                                                       # Специфичные таргету покупателя исходные коды
│   │   ├── Common                                                    # Общие файлы для всего таргета
│   │   │   ├── Extensions                                              # Расширения
│   │   │   ├── Files                                                   # Файлы, например json, картинка ресурсов и т.д.
│   │   │   └── Resources                                               # Картинки, цвета
│   │   │       ├── Assets.xcassets
│   │   │       ├── Colors.xcassets
│   │   │       ├── Generated                                             # Сгенерированный SwiftGen ресурсы
│   │   │       ├── Info.plist
│   │   │       ├── Storyboards                                           # Только LaunchScreen используется в проекте как сториборд
│   │   │       └── Strings                                               # Локализация строк
│   │   ├── Components                                                # Кастомные UI компоненты
│   │   │   └── SwiftUI.                                                # для SwftUI
│   │   │       └── Controls
│   │   ├── Modules                                                   # Модули(экраны) покупателя
│   │   │   ├── App                                                     # AppDelegate, SceneDelegate
│   │   │   ├── Favorites                                               # Экран избранного. Каждый модуль внутри разбит на одинаковую структуру:
│   │   │   │   ├── ApiService                                            # Сетевой слой модуля, взаимодействующий с глобальными APIService или APIWrapper.
│   │   │   │   │   ├── FavoritesApiService.swift                           # Реализация
│   │   │   │   │   └── FavoritesApiServiceProtocol.swift                   # и обязательный протокол 
│   │   │   │   ├── Builder                                               # Сборщик модуля (протокол и регистрация в DI внутри)
│   │   │   │   │   └── FavoritesBuilder.swift
│   │   │   │   ├── Helper                                                # Различные хелперы и сервисы только для данного модуля
│   │   │   │   │   └── FavoritesCellFactory.swift                          # Фабрика создания моделей для таблицы(List)
│   │   │   │   ├── Model                                                 # Модель модуля
│   │   │   │   │   └── FavoritesModel.swift
│   │   │   │   ├── Router                                                # Роутер модуля, наследует CommonRouter. Может проксировать запросы роутинга в глобальный Router
│   │   │   │   │   ├── FavoritesRouter.swift                               # Релизация, наследующая CommonRouter
│   │   │   │   │   └── FavoritesRouterProtocol.swift                       # и обязательный протокол, наследующий CommonRouterProtocol
│   │   │   │   ├── View                                                  # Содержит View или ViewController. Может содержать компоненты/ячейки для этого модуля
│   │   │   │   │   └── FavoritesView.swift
│   │   │   │   └── ViewModel                                             # Бизнес логика модуля. Может содержать дочерние вью модели
│   │   │   │       ├── FavoritesViewModel.swift                            # Реализация
│   │   │   │       └── FavoritesViewModelProtocol.swift                    # и обязательный протокол наследующий ObservableObject
│   │   │   ├── Intro
│   │   │   ├── ProfileData                                             # Пример структуры папок модуля с дочерней вью моделью
│   │   │   │   ├── ApiService
│   │   │   │   ├── Builder
│   │   │   │   ├── Helper
│   │   │   │   ├── Model
│   │   │   │   ├── Router
│   │   │   │   ├── View
│   │   │   │   └── ViewModel
│   │   │   │       └── ChildViewModel
│   │   │   └── Root                                                    # Рутовый таб контроллер для приложения покупателя
│   │   │       └── RootTabController.swift
│   │   ├── Services                                                  # Специфичные для таргета сервисы
│   │   └── Tests                                                     # Тесты(API, Unit, UI) для приложения покупателя
│   ├── Kit                                                         # Общие для всех таргетов исходные коды
│   │   ├── API                                                       # Модели ответов и запросов
│   │   │   └── Model
│   │   │       ├── Address
│   │   │       │   ├── Address.swift
│   │   │       │   ├── City.swift
│   │   │       │   └── Location.swift
│   │   │       ├── Cart
│   │   │       ├── Category
│   │   │       ├── Coordinatable.swift
│   │   │       ├── Dummy
│   │   │       ├── Error
│   │   │       ├── Favorites
│   │   │       ├── Image
│   │   │       ├── MainBanner
│   │   │       ├── Network                                             # API path для обращения к серверу, дженерик модели ответов сервера
│   │   │       │   ├── APIResourcePath.swift
│   │   │       │   ├── APIResourceServer.swift
│   │   │       │   ├── APIResourceService.swift
│   │   │       │   └── APIResponse.swift
│   │   │       ├── Pagination                                          # Пагинация
│   │   │       ├── Product
│   │   │       ├── Redirect
│   │   │       ├── Sale
│   │   │       ├── Search
│   │   │       ├── Suggestions
│   │   │       └── User
│   │   ├── Common
│   │   │   ├── Extensions
│   │   │   ├── Files
│   │   │   └── Resources
│   │   ├── Components
│   │   │   ├── Alert                                             # Кастомный алерт
│   │   │   ├── DesignSystem                                      # Дизайн система, кастомные компоненты для всего приложения
│   │   │   │   ├── SwiftUI
│   │   │   │   │   ├── Controls
│   │   │   │   │   │   ├── ButtonStyles
│   │   │   │   │   │   └── Loader
│   │   │   │   │   ├── DomainHostingController.swift
│   │   │   │   │   ├── Extensions
│   │   │   │   │   ├── Message
│   │   │   │   │   ├── TextFields
│   │   │   │   │   └── Web
│   │   │   │   └── UIKit
│   │   │   │       ├── Buttons
│   │   │   │       ├── Cells
│   │   │   │       │   ├── DomainBoldWithButtonCollectionHeader
│   │   │   │       │   ├── DomainHeaderWithButtonTableCell
│   │   │   │       │   └── ProductCell
│   │   │   │       ├── Controls
│   │   │   │       │   └── DomainImageSlider
│   │   │   │       ├── View
│   │   │   │       │   └── Message
│   │   │   │       └── Web
│   │   │   ├── Navigation
│   │   │   ├── Nibless
│   │   │   └── Utilities
│   │   ├── Modules
│   │   │   ├── Authorization
│   │   │   ├── AutoCompleteField
│   │   │   ├── Catalogue
│   │   │   │   └── CatalogueListing
│   │   │   ├── Intro
│   │   │   ├── MainFlow
│   │   │   ├── Region
│   │   │   └── Search
│   │   ├── Services
│   │   │   ├── DataSource
│   │   │   ├── FavoritesService
│   │   │   ├── Keychain
│   │   │   ├── LocationManager
│   │   │   ├── Logging.swift
│   │   │   ├── Network
│   │   │   │   ├── APIErrorLocalizer.swift
│   │   │   │   ├── APIService.swift
│   │   │   │   ├── APIServiceProtocol.swift
│   │   │   │   └── APIWrapper
│   │   │   │       ├── APIWrapper.swift
│   │   │   │       └── APIWrapperProtocol.swift
│   │   │   ├── RegionService
│   │   │   │   └── RegionAgent
│   │   │   ├── Router
│   │   │   │   ├── CommonRouter.swift
│   │   │   │   └── CommonRouterProtocol.swift
│   │   │   ├── SettingsService
│   │   │   │   ├── SettingsKey.swift
│   │   │   │   ├── SettingsService.swift
│   │   │   │   └── SettingsServiceProtocol.swift
│   │   │   ├── UniversalPaginator
│   │   │   │   ├── Paginator.swift
│   │   │   │   └── PaginatorProtocol.swift
│   │   │   ├── User
│   │   │   │   ├── Customer
│   │   │   │   ├── Employee
│   │   │   │   └── User.swift
│   │   │   ├── Validation
│   │   │   │   └── Validator.swift
│   │   │   └── WebView
│   │   │       └── WebKitCacheCleaner.swift
│   │   └── Tests
│   ├── POS
│   │   ├── Common
│   │   ├── Components
│   │   ├── Modules
│   │   ├── Services
│   │   └── Tests
│   ├── Podfile
│   ├── Podfile.lock
│   ├── Pods
│   │   ├── Alamofire
│   │   ├── Factory
│   │   ├── Kingfisher
│   │   ├── PhoneNumberKit
│   │   └── SnapKit
│   ├── Tests
│   │   ├── APITests
│   │   │   ├── POS
│   │   │   └── Store
│   │   ├── UITests
│   │   │   ├── POS
│   │   │   └── Store
│   │   └── UnitTests
│   │       ├── POS
│   │       └── Store
│   ├── build
│   │   └── XCBuildData
│   ├── Fastlane
│   │   ├── Fastfile
│   │   ├── README.md
│   │   ├── report.xml
│   │   └── test_output
│   │       ├── api_tests_pos
│   │       ├── ui_tests_pos
│   │       └── unit_tests_pos
│   ├── project.yml
│   ├── swiftgen.yml
│   ├── MEOWLS.xcodeproj
│   └── MEOWLS.xcworkspace
├── Automation
│   ├── Scripts
│   │   └── setup
│   └── Swiftgen
│       ├── ColorAssets.stencil
│       ├── ImageAssets.stencil
│       ├── KitColorAssets.stencil
│       └── KitImageAssets.stencil
├── Brewfile
├── Brewfile.lock.json
├── Gemfile
├── Gemfile.lock
├── LICENSE
├── README.md
└── XcodeTemplate
  ```
  <br>
</details>


## Внешний вид приложения
Только Store приложение

<details>
  <summary>
    <b>👀 РАСКРЫТЬ СКРИНШОТЫ [ВЫБОР РЕГИОНА ПОЛЬЗОВАТЕЛЯ]</b>
  </summary>
  <br>
  
  [<kbd> <br> Открыть в высоком разрешении <br><br> </kbd>](https://static.artemayer.ru/images/github/meowls-screenshots/region_selection_large.png)
  <p align="center">
    <a href="https://static.artemayer.ru/images/github/meowls-screenshots/region_selection_large.png" target="_blank">
      <picture>
        <img src="https://static.artemayer.ru/images/github/meowls-screenshots/region_selection_small.png" alt="User region selection screen">
      </picture>
    </a> 
  </p>
  <br>
</details>
<details>
  <summary>
    <b>👀 РАСКРЫТЬ СКРИНШОТЫ [ГЛАВНЫЙ ЭКРАН И ПОИСК]</b>
  </summary>
  <br>
  
  [<kbd> <br> Открыть в высоком разрешении <br><br> </kbd>](https://static.artemayer.ru/images/github/meowls-screenshots/main_flow_search_original.png)
  <p align="center">
    <a href="https://static.artemayer.ru/images/github/meowls-screenshots/main_flow_search_original.png" target="_blank">
      <picture>
        <img src="https://static.artemayer.ru/images/github/meowls-screenshots/main_flow_search_small.png" alt="Main flow and search">
      </picture>
    </a> 
  </p>
  <br>
</details>
<details>
  <summary>
    <b>👀 РАСКРЫТЬ СКРИНШОТЫ [АВТОРИЗАЦИЯ И РЕГИСТРАЦИЯ]</b>
  </summary>
  <br>
  
  [<kbd> <br> Открыть в высоком разрешении <br><br> </kbd>](https://static.artemayer.ru/images/github/meowls-screenshots/authorization_large.png)
  <p align="center">
    <a href="https://static.artemayer.ru/images/github/meowls-screenshots/authorization_large.png" target="_blank">
      <picture>
        <img src="https://static.artemayer.ru/images/github/meowls-screenshots/authorization_small.png" alt="User authorization and registration">
      </picture>
    </a> 
  </p>
  <br>
</details>
<details>
  <summary>
    <b>👀 РАСКРЫТЬ СКРИНШОТЫ [ИЗБРАННОЕ]</b>
  </summary>
  <br>
  
  [<kbd> <br> Открыть в высоком разрешении <br><br> </kbd>](https://static.artemayer.ru/images/github/meowls-screenshots/favorites_original.png)
  <p align="center">
    <a href="https://static.artemayer.ru/images/github/meowls-screenshots/favorites_original.png" target="_blank">
      <picture>
        <img src="https://static.artemayer.ru/images/github/meowls-screenshots/favorites_small.png" alt="User's favorites products">
      </picture>
    </a> 
  </p>
  <br>
</details>
<details>
  <summary>
    <b>👀 РАСКРЫТЬ СКРИНШОТЫ [ВСЯ СХЕМА]</b>
  </summary>
  <br>
  
  [<kbd> <br> Открыть в высоком разрешении <br><br> </kbd>](https://static.artemayer.ru/images/github/meowls-screenshots/flows_original.png)
  <p align="center">
    <a href="https://static.artemayer.ru/images/github/meowls-screenshots/flows_original.png" target="_blank">
      <picture>
        <img src="https://static.artemayer.ru/images/github/meowls-screenshots/flows_small.png" alt="Full flows scheme">
      </picture>
    </a> 
  </p>
  <br>
</details>
<br>

**ОБЗОР ПРИЛОЖЕНИЯ**
[<kbd> <br> Открыть в высоком разрешении <br> <br> </kbd>](https://static.artemayer.ru/images/github/meowls-screenshots/fullMEOWLSAppRecord.mp4)

https://github.com/user-attachments/assets/7f00c2ff-9ec0-4a91-af8c-563e5e04840f

---

## Развертывание и запуск

### 1. Установка [Homebrew](https://brew.sh/):
```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
ИЛИ
```zsh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

> [!IMPORTANT]
> Для продолжения убедитесь, что у вас установлен Homebrew.

### 2. Установка brew пакетов из [Brewfile](Brewfile):

> [!IMPORTANT]
> Для продолжения убедитесь, перейдите в папку с проектом, содержащую папки `Automation`, `MEOWLS` и т.д.

```zsh
brew bundle && \
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
```

---

### 3. Установка [Bundler](https://bundler.io/):
```zsh
gem install bundler --user-install
```
ИЛИ если есть проблемы
```zsh
sudo gem install bundler
```

---

### 4. Установка гемов из [Gemfile](Gemfile):
```zsh
bundle install
```

---

### 5. Сборка проекта скриптом [setup](Automation/Scripts/setup):

> [!IMPORTANT]
> Для продолжения убедитесь, перейдите в папку со скриптом ./Automation/Scripts и запустите скрипт из командной строки:

Поддерживаются команды для скрипта: «open» для открытия проекта после сборки и «clear» для очистки существующих проектных файлов перед сборкой (например, `./setup clear open`).
Скрипт запустит `xcodegen` для сборки проекта, `swiftgen` для генерации ресурсов и `pod install --repo-update` для установки под зависимостей проекта.
```zsh
./setup
```

---

### 6. Выбор таргета и сборка проекта:

> [!IMPORTANT]
> В данный момент реализовано только приложение для покупателя [ТАРГЕТ Store Debug/Release], для просмотра MVP проекта выбирайте его.
> Можно зарегистрироваться под любым номером телефона без подтверждения.

---


## Тестирование

### 1. Запуск тестов из Xcode:

1. Выберите таргет Store Debug/Release;
2. Необходимо собрать проект для тестирования: Product -> Build For -> Testing (<kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>U</kbd>);
3. Далее нужно выбрать тестовый план: Pdouct -> Test Plan -> APITest(по умолчанию)/UITest/UnitTest;
4. Запуск тестов: Product -> Test (<kbd>⌘</kbd>+<kbd>U</kbd>).

---

### 2. Запуск тестов через Fastlane:

1. Откройте терминал и перейдите в корень проекта - папка, содержащая `Stote`, `Kit` и `POS`;
2. Запустите сборку/тесты командами, указанными в [файле](MEOWLS/Fastlane/README.md) `Fastlane/README.md`, например:
```zsh
fastlane ios debug_build_store && \
fastlane ios ui_tests_store
```

---


## Поддержка и вклад

Я рад любым предложениям по улучшению проекта. Для этого создайте форк репозитория и отправьте Pull Request.


## Помощь

Если нужно связаться со мной или получить помощь по проекту, пишите на <a href="mailto:mayer1art@gmail.com">почту</a> и в <a href="https://t.me/mayer1a">телеграм</a>.


## Благодарность

Все иконки в приложении взяты с сайта https://www.svgrepo.com/. \
Vectors and icons by <a href="https://www.svgrepo.com/" target="_blank">SVG Repo</a>.

Для получения информации со своего сервера используется API https://api.meowls.artemayer.ru. \
Статика, пользовательское соглашение, политика конфиденциальности, правила возврата, условия доставки и контакты доступны по адресу https://static.artemayer.ru/.


## Лицензия

Проект лицензирован под GPL-3.0 License. Подробности смотрите в файле [LICENSE](./LICENSE).

