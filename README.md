# System Design социальной сети для курса по System Design
https://balun.courses/courses/system_design

## Функциональные требования
- Пользователь может опубликовать пост, включающий фотографии, текстовое описание и геолокацию
- Пользователь может комментировать посты других пользователей
- Пользователь может ставить реакции постам других пользователей
- Пользователь может подписываться на других пользователей
- Пользователь может искать места для путешествий и просматривать посты с найденных мест
- Пользователь может просматривать ленту других пользователей

## Нефункциональные требования
- DAU - через год 10 000 000, в дальнейшем будет расти до 20 000 000.
- Регион использования: Только СНГ
- Сезонность в приложении: основные пики нагрузки будут приходиться на летний период, новогодние и майские праздники.
- Условия хранения данных: данные храним всегда.
- Лимиты и ограничения: 
  - кол-во фото в посте: от 0 до 10
  - размер текстового описания к посту: от 2 до 1000 символов
  - размер текста комментария: от 2 до 1000 символов
  - на кол-во постов в ленте ограничений нет
  - на кол-во подписчиков ограничений нет
  - вес одного фото не должен превышать 10 МЬ
- Ожидания:
  - один пользователь в среднем подписан на 5 других пользователей
  - один пост содержит в среднем 3 фото, описание на 300 символов и геолокацию
  - один пост содержит в среднем 5 комментариев по 50 символов и 10 реакций
  - вес фото в посте в среднем 6 Mb
- Доступность: 99.999%
- Тайминги:
  - добавление поста и комментария: не более 1 секунды
  - загрузка ленты: не более 2 секунд
  - поиск: не более 3 секунд
- Активность:
  - Лента
    - В сезонность: 1 пользователь просматривает ленту 4 раза в день.
    - В обычное время: 1 пользователь просматривает ленту 1 раз за два дня.
    - Ожидается, что старые посты (которым больше года) в ленте будут просматриваться часто именно в несезон, т.к. пользователи будут искать места для отдыха.
  - Публикация постов
    - В сезонность: 1 пользователь публикует 3 поста в день.
    - В обычное время: 1 пользователь публикует 1 пост в неделю.
  - Комментарии и реакции
    - В сезонность: 1 пользователь оставляет 5 комментариев и реакций в день.
    - В обычное время: 1 пользователь оставляет 2 комментария и реакции в день.
  - Поиск
    - В сезонность: 1 пользователь может искать места для путешествий раз в три дня.
    - В обычное время: 1 пользователь может искать места для путешествий 1 раз в день.
  - Просмотр найденных постов
    - В сезонность: 1 пользователь может просматривать 3 найденных поста.
    - В обычное время: 1 пользователь может просматривать 6 найденных постов.
  - Просмотр постов из ленты
    - В сезонность: 1 пользователь может просматривать 2 поста за один просмотр ленты.
    - В обычное время: 1 пользователь может просматривать 1 пост за один просмотр ленты.
## Расчет нагрузки
### RPS
- Лента
  - В сезонность:
    - RPS (read) = 20 000 000 * 4 / 86 400 = 930
  - В обычное время:
    - RPS (read) = 20 000 000 / 2 / 86 400 = 115
- Посты
  - В сезонность:
    - RPS (read) = 20 000 000 * (1 + 2 * 4) / 86 400 = 2100
    - RPS (write) = 20 000 000 * 3 / 86 400 = 700
  - В обычное время:
    - RPS (read) = 20 000 000 * (6 + 0.5) / 86 400 = 1500
    - RPS (write) = 20 000 000 * (1/7) / 86 400 = 33
- Комментарии и реакции
  - В сезонность:
    - RPS (read) = RPS (read) для постов = 2100
    - RPS (write) = 20 000 000 * 5 / 86 400 = 1200
  - В обычное время:
    - RPS (read) = RPS (read) для постов = 1500
    - RPS (write) = 20 000 000 * 2 / 86 400 = 450
- Поиск
  - В сезонность:
    - RPS (read) = 20 000 000 * (1/3) / 86 400 = 77
  - В обычное время:
    - RPS (read) = 20 000 000 * 1 / 86 400 = 230
### Traffic
- Фото в посте: 6 Mb * 3 = 18 Mb
- Описание + комментарии в посте: 300 bytes (описание) + 8 bytes (геолокация) + 260 bytes (комментарии) = 568 bytes
- Лента
  - При загрузке ленты отображаются первые 5 постов, остальные подгружаются уже после загрузки также по 5 постов за запрос
  - При передачи по сети фото передаются в сжатом виде и уменьшены в размере на 50%
  - Фото: 5 * (18 Mb * 0.5) = 45 Mb
  - Остальное: 5 * 568 bytes = 3 Kb
  - В сезонность:
    - Traffic (read) фото = 930 * 45 Mb = 42 000 Mb/s
    - Traffic (read) остальное = 930 * 3 Kb = 3 000 Kb/s
  - В обычное время:
    - Traffic (read) фото = 115 * 27 Mb = 3 000 Mb/s
    - Traffic (read) остальное = 115 * 3 Kb = 345 Kb/s
- Посты
  - В сезонность:
    - Traffic (read) = 0 (посты уже загружены в ленте или в поиске)
    - Traffic (write) = 700 * (18 Mb * 0.5) Mb = 6 300 Mb/s
  - В обычное время:
    - Traffic (read) = 0 (посты уже загружены в ленте или в поиске)
    - Traffic (write) = 33 * (18 Mb * 0.5) Mb = 300 Mb/s
- Комментарии и реакции
  - В сезонность:
    - Traffic (read) = 0 (комментарии уже загружены в ленте или в поиске)
    - Traffic (write) = 1200 * 50 bytes = 60 Kb/s
  - В обычное время:
    - Traffic (read) = 0 (комментарии уже загружены в ленте или в поиске)
    - Traffic (write) = 450 * 50 bytes = 23 Kb/s
- Поиск
  - Если подгрузка по 5 постов за запрос:
  - В сезонность:
    - Traffic (read) фото = 77 * 45 Mb = 3 500 Mb/s
    - Traffic (read) остальное = 77 * 3 Kb = 230 Kb/s
  - В обычное время:
    - Traffic (read) фото = 230 * 45 Mb = 10 000 Mb/s
    - Traffic (read) остальное = 230 * 3 Kb = 700 Kb/s