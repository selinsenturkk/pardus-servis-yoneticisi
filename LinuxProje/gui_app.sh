#!/bin/bash

# --- ROOT KONTROLÜ ---
if [ "$EUID" -ne 0 ]; then
    yad --title="HATA: Yetki Sorunu" --image="dialog-error" --text="Bu programı çalıştırmak için YÖNETİCİ (root) yetkisi gereklidir.\nLütfen 'sudo' komutu ile çalıştırınız." --button="Tamam:1"
    exit 1
fi

# Arka plan fonksiyonlarını dahil et
source ./lib_functions.sh

# --- GUI FONKSİYONLARI (YAD) ---

while true; do
    # Ana Menü Tasarımı
    SECIM=$(yad --title "Pardus Servis Yöneticisi" \
        --width=400 --height=300 \
        --window-icon="preferences-system" \
        --text="Lütfen yapmak istediğiniz işlemi seçin:" \
        --list \
        --column="ID" --column="İşlem" \
        1 "Servisleri Listele" \
        2 "Servis Başlat" \
        3 "Servis Durdur" \
        4 "Servis Durumu (Status)" \
        5 "Servis Logları (Journal)" \
        6 "Çıkış" \
        --no-headers --separator="" --print-column=1)

    # Pencere kapatılırsa veya İptal'e basılırsa çık
    if [ -z "$SECIM" ]; then
        break
    fi

    case $SECIM in
        1) # Listele
            servisleri_listele > /tmp/gui_list.txt
            yad --title "Servis Listesi" --text-info --filename=/tmp/gui_list.txt \
                --width=600 --height=500 --fontname="Monospace 10" \
                --button="Kapat:0"
            ;;
        2) # Başlat
            SERV_AD=$(yad --entry --title "Servis Başlat" --text "Başlatılacak servis adı (örn: ssh):")
            if [ -n "$SERV_AD" ]; then
                SONUC=$(servis_baslat "$SERV_AD")
                yad --title "Sonuç" --msgbox --text "$SONUC" --button="Tamam:0"
            fi
            ;;
        3) # Durdur
            SERV_AD=$(yad --entry --title "Servis Durdur" --text "Durdurulacak servis adı (örn: cron):")
            if [ -n "$SERV_AD" ]; then
                SONUC=$(servis_durdur "$SERV_AD")
                yad --title "Sonuç" --msgbox --text "$SONUC" --button="Tamam:0"
            fi
            ;;
        4) # Durum
            SERV_AD=$(yad --entry --title "Servis Durumu" --text "Durumu sorgulanacak servis:")
            if [ -n "$SERV_AD" ]; then
                servis_durumu "$SERV_AD" > /tmp/gui_status.txt
                yad --title "Servis Durumu: $SERV_AD" --text-info --filename=/tmp/gui_status.txt \
                    --width=700 --height=500 --fontname="Monospace 10" \
                    --button="Kapat:0"
            fi
            ;;
        5) # Loglar
            SERV_AD=$(yad --entry --title "Log Görüntüle" --text "Logları istenecek servis:")
            if [ -n "$SERV_AD" ]; then
                servis_loglari "$SERV_AD" > /tmp/gui_log.txt
                yad --title "Loglar: $SERV_AD" --text-info --filename=/tmp/gui_log.txt \
                    --width=800 --height=500 --fontname="Monospace 10" \
                    --button="Kapat:0"
            fi
            ;;
        6) # Çıkış
            break
            ;;
    esac
done
