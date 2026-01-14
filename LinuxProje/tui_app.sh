#!/bin/bash

# --- ROOT KONTROLÜ ---
if [ "$EUID" -ne 0 ]; then
    whiptail --title "HATA: Yetki Sorunu" --msgbox "Bu programı çalıştırmak için YÖNETİCİ (root) yetkisi gereklidir.\nLütfen 'sudo' komutu ile çalıştırınız." 10 60
    exit 1
fi

# Arka plan fonksiyonlarını dahil et
source ./lib_functions.sh

# --- TUI FONKSİYONLARI ---

# Ana Menü Döngüsü
while true; do
    SECIM=$(whiptail --title "Pardus Servis Yöneticisi" --menu "Yapmak istediğiniz işlemi seçin:" 20 70 10 \
    "1" "Servisleri Listele" \
    "2" "Servis Başlat" \
    "3" "Servis Durdur" \
    "4" "Servis Durumu (Status)" \
    "5" "Servis Logları (Journal)" \
    "6" "Çıkış" 3>&1 1>&2 2>&3)

    # İptal'e basılırsa çık
    if [ $? -ne 0 ]; then
        break
    fi

    case $SECIM in
        1) # Listele
            whiptail --title "Lütfen Bekleyiniz" --infobox "Servis listesi alınıyor..." 8 40
            servisleri_listele > /tmp/servis_listesi.txt
            whiptail --title "Servis Listesi" --textbox /tmp/servis_listesi.txt 20 80 --scrolltext
            ;;
        2) # Başlat
            SERV_AD=$(whiptail --inputbox "Başlatılacak servisin adını girin (örn: ssh):" 8 40 3>&1 1>&2 2>&3)
            if [ -n "$SERV_AD" ]; then
                SONUC=$(servis_baslat "$SERV_AD")
                whiptail --title "İşlem Sonucu" --msgbox "$SONUC" 8 50
            fi
            ;;
        3) # Durdur
            SERV_AD=$(whiptail --inputbox "Durdurulacak servisin adını girin (örn: cron):" 8 40 3>&1 1>&2 2>&3)
            if [ -n "$SERV_AD" ]; then
                SONUC=$(servis_durdur "$SERV_AD")
                whiptail --title "İşlem Sonucu" --msgbox "$SONUC" 8 50
            fi
            ;;
        4) # Durum
            SERV_AD=$(whiptail --inputbox "Durumu sorgulanacak servis (örn: bluetooth):" 8 40 3>&1 1>&2 2>&3)
            if [ -n "$SERV_AD" ]; then
                servis_durumu "$SERV_AD" > /tmp/servis_durumu.txt
                whiptail --title "Servis Durumu: $SERV_AD" --textbox /tmp/servis_durumu.txt 20 80 --scrolltext
            fi
            ;;
        5) # Loglar
            SERV_AD=$(whiptail --inputbox "Logları istenecek servis:" 8 40 3>&1 1>&2 2>&3)
            if [ -n "$SERV_AD" ]; then
                servis_loglari "$SERV_AD" > /tmp/servis_log.txt
                whiptail --title "Son Loglar: $SERV_AD" --textbox /tmp/servis_log.txt 20 80 --scrolltext
            fi
            ;;
        6) # Çıkış
            break
            ;;
    esac
done

clear
echo "Programdan çıkıldı."
