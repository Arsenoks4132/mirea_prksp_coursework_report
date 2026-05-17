#import "../../const.typ"

= ТЕСТИРОВАНИЕ И РАЗВЁРТЫВАНИЕ ПРИЛОЖЕНИЯ

== Фаззинг-тестирование

=== Подход к тестированию

Для обеспечения качества разрабатываемого приложения применяется фаззинг-тестирование (fuzz testing) — метод, при котором на вход программы автоматически подаются случайные, граничные или некорректные данные с целью выявления ошибок обработки, нарушений валидации и некорректного поведения @hoffman2021.

В качестве инструмента фаззинг-тестирования выбрана библиотека Hypothesis — реализация property-based testing для Python. В отличие от классических unit-тестов с фиксированными входными данными, Hypothesis автоматически генерирует большое количество вариантов входных данных в соответствии с заданными стратегиями и ищет значения, при которых тест не проходит. Найденные контрпримеры минимизируются и сохраняются для воспроизведения.

=== Реализованные тесты

Тесты размещены в файле `Tasks/tests.py` и разделены на следующие классы.

*`TaskModelValidationTest`* — фаззинг модели `Task`, поле `spent`:

- `test_valid_spent_values` — любое целое значение в диапазоне $[1, 24]$ должно проходить `full_clean()` без исключения;
- `test_invalid_spent_values` — любое значение вне диапазона $[1, 24]$ должно вызывать `ValidationError`;
- `test_task_total_cost_calculation` — произведение `spent × cost` всегда является корректным неотрицательным целым числом.

*`AddTaskFormFuzzTest`* — фаззинг формы `AddTaskForm`:

- `test_form_accepts_any_valid_comment` — форма должна быть валидна для любого комментария длиной до 1000 символов;
- `test_form_rejects_invalid_spent` — форма должна возвращать ошибку поля `spent` при значениях вне допустимого диапазона;
- `test_form_rejects_too_long_comment` — форма должна отклонять комментарии длиной свыше 1000 символов.

*`CategoryFormFuzzTest`* — фаззинг формы `CategoryForm`:

- `test_valid_category_name` — форма валидна для любого непустого названия длиной до 100 символов;
- `test_valid_category_cost` — форма принимает любое неотрицательное целое значение стоимости;
- `test_category_name_too_long` — форма отклоняет названия длиннее 100 символов.

*`RegisterFormEmailFuzzTest`* — фаззинг поля `email` формы регистрации:

- `test_unique_email_accepted` — форма регистрации принимает корректный уникальный адрес электронной почты;
- `test_invalid_email_rejected` — строки без символа `@` должны отклоняться как некорректный email.

*`RoleBasedAccessTest`* — проверка ролевой модели на несанкционированный доступ:

- `test_anonymous_profile_redirects_to_login` — неаутентифицированный запрос к `/profile` перенаправляет на страницу входа;
- `test_anonymous_statistics_forbidden` — неаутентифицированный запрос к `/statistics` перенаправляется;
- `test_employee_cannot_access_statistics` — сотрудник без `is_staff` получает 302 или 403 при обращении к `/statistics`;
- `test_supervisor_can_access_statistics` — руководитель с `is_staff = True` получает HTTP 200 на `/statistics`;
- `test_employee_cannot_access_categories` — сотрудник не имеет доступа к `/categories`;
- `test_supervisor_can_access_categories` — руководитель получает HTTP 200 на `/categories`;
- `test_employee_cannot_edit_other_task` — сотрудник получает 302 или 403 при попытке редактировать чужую задачу;
- `test_employee_can_edit_own_task` — сотрудник получает HTTP 200 при обращении к редактированию собственной задачи.

Результаты запуска фаззинг-тестов представлены на рисунке @fuzz-tests-output.

/*
  ПЛЕЙСХОЛДЕР — результаты запуска фаззинг-тестов
  Файл: images/fuzz_tests_output.png
  Описание: Скриншот терминала с результатом команды:
    python manage.py test Tasks
  Ожидаемый вывод: строки вида
    "Ran N tests in X.XXXs"
    "OK"
  Команда для запуска (внутри контейнера django_backend или локально):
    cd TaskAndTime && python manage.py test Tasks
*/
#figure(
  rect(width: 95%, height: 6cm, stroke: (paint: black, dash: "dashed"))[
    #align(center + horizon)[
      *[ПЛЕЙСХОЛДЕР]*\
      Результаты запуска тестов (`python manage.py test Tasks`)\
      Ожидаемый вывод: `Ran N tests in X.XXXs — OK`\
      Сохранить как: `images/fuzz_tests_output.png`
    ]
  ],
  caption: [Результаты запуска фаззинг-тестов],
) <fuzz-tests-output>

== Размещение кода в системе контроля версий

=== Структура репозитория

Исходный код проекта размещён в репозитории GitHub по адресу:
`https://github.com/Arsenoks4132/TaskMetrics`

Репозиторий содержит полную структуру проекта, описанную в файле `README.md`, включая схему директорий, архитектурную схему, таблицу стека технологий, инструкцию по запуску через Docker Compose, описание переменных окружения и сведения о демонстрационных пользователях.

Файл `README.md` содержит следующие разделы:

- описание функциональности приложения по ролям;
- полное дерево директорий с описанием ключевых файлов;
- архитектурная схема прохождения запроса (от браузера до СУБД);
- таблица технологического стека;
- инструкция по запуску (`docker compose up -d --build`);
- список необходимых переменных окружения (`.env`);
- логины и пароли демонстрационных пользователей.

=== История коммитов

Для репозитория ведётся содержательная история изменений. Каждый коммит отражает логически завершённое изменение с описанием цели правки. История коммитов репозитория представлена на рисунке @github-commits.

/*
  ПЛЕЙСХОЛДЕР — история коммитов репозитория GitHub
  Файл: images/github_commits.png
  Описание: Скриншот страницы https://github.com/Arsenoks4132/TaskMetrics/commits/master
  Должно быть видно: не менее 8 последних коммитов с хэшами, датами и сообщениями.
  Последние коммиты (снизу вверх):
    - "b0caac4 new fixture data; better startup script"
    - "cf51ab3 Add full CRUD for tasks: edit and delete views with role-based access"
    - "30e42f8 Add profile editing, password change, and enable password validators"
    - "9a9e8d0 Add frontend CRUD for task categories (supervisor only)"
    - "2097ec7 Add fuzz and property-based tests using Hypothesis"
    - "eaf8901 Expand README with project structure, architecture, and run instructions"
*/
#figure(
  rect(width: 95%, height: 8cm, stroke: (paint: black, dash: "dashed"))[
    #align(center + horizon)[
      *[ПЛЕЙСХОЛДЕР]*\
      История коммитов GitHub-репозитория\
      URL: `https://github.com/Arsenoks4132/TaskMetrics/commits/master`\
      Сохранить как: `images/github_commits.png`
    ]
  ],
  caption: [История коммитов репозитория GitHub],
) <github-commits>

== Контейнеризация приложения

=== Dockerfile

Сборка образа Django-приложения описана в файле `docker/django/Dockerfile`. Образ основан на `python:3.12`, устанавливает зависимости из `requirements.txt`, копирует конфигурационный файл `.env` и скрипт запуска `entrypoint.sh`. Скрипт запуска последовательно выполняет применение миграций базы данных, загрузку начальной фикстуры (при первом запуске) и старт Gunicorn-сервера.

=== Docker Compose

Оркестрация всех сервисов приложения описана в файле `docker-compose.yaml`. Состав сервисов представлен в таблице @services-table.

#figure(
  table(
    columns: (1.5fr, 2fr, 1fr, 2.5fr),
    [Сервис], [Образ], [Реплики], [Роль],
    [`django_backend`], [`python:3.12` (кастомный)], [3], [Сервер приложений (Gunicorn + Django)],
    [`postgres_db`], [`postgres:17`], [1], [Основная СУБД],
    [`nginx_frontend`], [`nginx:1.27`], [3], [Веб-сервер, отдача статики],
    [`traefik_balancer`], [`traefik:v3.2`], [1], [Балансировщик нагрузки, точка входа],
    [`redis_cache`], [`redis:latest`], [1], [Кэш страниц],
  ),
  caption: [Сервисы Docker Compose приложения TaskAndTimes],
) <services-table>

Django-контейнеры и Nginx-контейнеры запускаются в трёх репликах для обеспечения горизонтального масштабирования. Traefik распределяет входящие запросы между репликами по алгоритму round-robin. PostgreSQL и Redis запускаются в одном экземпляре.

Диаграмма развёртывания контейнеров на Yandex Cloud VM представлена на рисунке @deployment-diagram.

/*
  ПЛЕЙСХОЛДЕР — диаграмма развёртывания
  Файл: images/deployment_diagram.png
  Источник: diagrams/deployment_diagram.puml
  Описание: UML deployment diagram.
  Показывает: узел "Yandex Cloud Compute VM (Ubuntu, Docker)" с Docker Compose,
  внутри: контейнеры traefik_balancer, nginx_frontend × 3, django_backend × 3,
  postgres_db, redis_cache. Узел "Пользователь" с браузером.
  Как получить: отрендерить diagrams/deployment_diagram.puml через PlantUML
  и сохранить как images/deployment_diagram.png
*/
#figure(
  rect(width: 95%, height: 10cm, stroke: (paint: black, dash: "dashed"))[
    #align(center + horizon)[
      *[ПЛЕЙСХОЛДЕР]*\
      Диаграмма развёртывания (UML Deployment Diagram)\
      Источник: `diagrams/deployment_diagram.puml`\
      Отрендерить и сохранить как `images/deployment_diagram.png`
    ]
  ],
  caption: [Диаграмма развёртывания приложения на Yandex Cloud],
) <deployment-diagram>

== Развёртывание на Yandex Cloud

=== Процесс развёртывания

Приложение развёртывается на виртуальной машине Yandex Cloud Compute Cloud с операционной системой Ubuntu. Процесс развёртывания включает следующие шаги:

1. *Создание ВМ* — в консоли Yandex Cloud создаётся виртуальная машина с публичным IP-адресом. Открываются входящие порты 80 (HTTP) и 22 (SSH).

2. *Установка окружения* — на ВМ устанавливаются Docker и Docker Compose. Используются следующие команды: `sudo apt update && sudo apt install -y docker.io docker-compose-plugin` и `sudo usermod -aG docker $USER`.

3. *Клонирование репозитория* — исходный код загружается с GitHub командой `git clone https://github.com/Arsenoks4132/TaskMetrics.git`.

4. *Конфигурация окружения* — создаётся файл `.env` с необходимыми переменными: секретный ключ Django, данные для подключения к PostgreSQL, IP-адрес сервера.

5. *Запуск приложения* — выполняется сборка и запуск всех контейнеров командой `docker compose up -d --build`.

6. *Проверка работоспособности* — приложение становится доступным по публичному IP-адресу ВМ через браузер. При первом запуске автоматически выполняются миграции и загружается тестовая фикстура с демонстрационными данными.

=== Результат развёртывания

После завершения развёртывания приложение доступно по адресу публичного IP-адреса виртуальной машины Yandex Cloud. Работающее приложение в облаке представлено на рисунке @cloud-deploy.

/*
  ПЛЕЙСХОЛДЕР — работающее приложение в облаке
  Файл: images/cloud_deploy.png
  Описание: Скриншот браузера с открытым главным экраном приложения (или профилем сотрудника)
  по адресу http://<PUBLIC_IP_YANDEX_CLOUD>/
  В адресной строке должен быть виден публичный IP-адрес.
  При наличии домена — показать доменное имя.
  Также добавить в текст отчёта реальный URL после деплоя.
*/
#figure(
  rect(width: 95%, height: 7cm, stroke: (paint: black, dash: "dashed"))[
    #align(center + horizon)[
      *[ПЛЕЙСХОЛДЕР]*\
      Приложение, развёрнутое на Yandex Cloud VM\
      URL: `http://<IP_АДРЕС_ВМ>/` (добавить после деплоя)\
      Сохранить как: `images/cloud_deploy.png`
    ]
  ],
  caption: [Приложение TaskAndTimes, развёрнутое на Yandex Cloud],
) <cloud-deploy>

== Выводы по главе

В ходе выполнения данной главы было реализовано фаззинг-тестирование приложения с использованием библиотеки Hypothesis. Написаны четыре класса тестов, охватывающих граничные значения числовых полей, произвольные строковые данные в текстовых полях, валидацию форм и проверку ролевой модели на попытки несанкционированного доступа.

Исходный код проекта размещён в репозитории GitHub `https://github.com/Arsenoks4132/TaskMetrics` с содержательной историей коммитов и развёрнутым файлом `README.md`. Приложение полностью контейнеризировано с помощью Docker: образ сервера приложений описан в `Dockerfile`, оркестрация пяти сервисов — в `docker-compose.yaml`. Процесс развёртывания на виртуальной машине Yandex Cloud сведён к четырём командам и не требует ручной настройки каждого сервиса.
