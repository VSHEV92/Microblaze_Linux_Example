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

- **board_files** - документация на плату Avnet 7A50T:
- **mii_to_rmii_v2_0** - ядро преобразователя MII в RMII;
- **init-ifupdown** - рецепт для установки статических IP адресов;
- **phytool** - рецепт для чтения регистров физики ethrenet;
- **ledstoggle** - рецепт для моргания светодиодами;
- **system-user.dtsi** - файл, для добавления узлов в device tree;
- **pins.xdc** - файл с ограничениями для проекта Vivado;
- **create_xsa.tcl** - скрипт для сборки проекта Vivado;
- **boot.mcs** - файл для загрузки с flash.

------

#### Makefile

- **make all** - собрать проекты Vivado и Petalinux;
- **make mcs** - сгенерировать загрузочный файл;
- **make microblaze_paltform.xsa** - собрать проект Vivado;
- **make clean_peta** - очистка проекта Petalinux;
- **make clean_peta** - очистка проекта Vivado;
- **make clean** - полная очистка.

------

#### Настройки системы

Статические сетевые адреса: 

- интерфейс - eth0; адрес - 192.168.0.10; маска - 255.255.255.0;
- интерфейс - eth1; адрес - 192.168.0.11; маска - 255.255.255.0.

Консоль: IP - Uart Lite; скорость - 115200. 

