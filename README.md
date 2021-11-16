# Microblaze Linux Example
------

Пример Linux-системы на основе Microblaze и Petalinux для платы Avnet 7A50T.

------

#### Содержимое Block Design

- Microblaze;
- Контроллер прервываний;
- Таймер;
- Контроллер DDR памяти (MIG);
- Два контроллера ethernet (Emaclite);
- Контроллер SPI;
- Контроллер IIC;
- Контроллер UART;
- Контроллер GPIO для светодиодов;

#### Иерархия файлов

- **Board_File** - документация на плату Avnet 7A50T:
- **mii_to_rmii_v2_0** - ядро преобразователя MII в RMII;
- **init-ifupdown** - рецепт для установки статических IP адресов;
- **phytool** - рецепт для чтения регистров физики ethrenet;
- **ledstoggle** - рецепт для моргания светодиодами;
- **src** - исходные файлы агента
- **tcl** - скрипты для запуска тестов

------

#### Makefile

- **make all** - запустить тестирование Master и Slave агентов
- **make test_master** - запустить тестирование Master агента
- **make test_slave** - запустить тестирование Slave агента
- **make axi_lite_master** - создать проект для тестирования Master агента
- **make axi_lite_slave** - создать проект для тестирования Slave агента
- **make check** - проверка log-файлов
- **make clean** - очистка проекта

------

