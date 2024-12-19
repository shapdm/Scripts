#!/bin/bash

# Устанавливаем pub сертификат
echo "Добавляем pub сертификат..."
wget https://downloads.sourceforge.net/project/v2raya/openwrt/v2raya.pub -O /etc/opkg/keys/94cc2a834fb0aa03 || {
    echo "Ошибка при загрузке pub сертификата" && exit 1
}

# Прописываем репозиторий
echo "Добавляем репозиторий в customfeeds.conf..."
echo "src/gz v2raya https://downloads.sourceforge.net/project/v2raya/openwrt/$(. /etc/openwrt_release && echo "$DISTRIB_ARCH")" | tee -a "/etc/opkg/customfeeds.conf"

# Обновляем список репозиториев
echo "Обновляем список пакетов..."
opkg update || { echo "Ошибка обновления списка пакетов" && exit 1; }

# Устанавливаем необходимые пакеты
echo "Устанавливаем пакеты v2raya и зависимости..."
opkg install v2raya || { echo "Ошибка установки v2raya" && exit 1; }
opkg install kmod-nft-tproxy || { echo "Ошибка установки kmod-nft-tproxy" && exit 1; }
opkg install iptables-mod-conntrack-extra \
  iptables-mod-extra \
  iptables-mod-filter \
  iptables-mod-tproxy \
  kmod-ipt-nat6 || { echo "Ошибка установки iptables модулей" && exit 1; }

opkg install xray-core || { echo "Ошибка установки xray-core" && exit 1; }

# Устанавливаем LuCI интерфейс для v2raya
echo "Устанавливаем luci-app-v2raya..."
opkg install luci-app-v2raya || { echo "Ошибка установки luci-app-v2raya" && exit 1; }

# Настраиваем v2raya
echo "Настраиваем v2raya..."
uci set v2raya.config.enabled='1'
uci commit v2raya

# Включаем автозапуск и запускаем
echo "Включаем автозапуск и запускаем v2raya..."
/etc/init.d/v2raya enable
/etc/init.d/v2raya start || { echo "Ошибка запуска v2raya" && exit 1; }

# Определяем IP-адрес роутера
IP_ADDR=$(ip -4 addr show br-lan | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

# Завершаем установку
echo "Установка и настройка v2raya завершены."
echo "Для дальнейшей настройки перейдите в браузере по адресу: http://$IP_ADDR:2017"
