#!/bin/bash

# --- SERVİS YÖNETİM FONKSİYONLARI ---

# Tüm servisleri listele (Ad, Durum, Aktiflik)
# systemctl çıktısını temizleyip sadece işimize yarayan kısımları alıyoruz.
function servisleri_listele() {
    systemctl list-units --type=service --all --plain --no-legend | awk '{print $1, $3, $4}' | column -t
}

# Seçilen servisi BAŞLAT
function servis_baslat() {
    hizmet_adi=$1
    if systemctl start "$hizmet_adi"; then
        echo "BASARILI: $hizmet_adi servisi başlatıldı."
    else
        echo "HATA: $hizmet_adi başlatılamadı!"
    fi
}

# Seçilen servisi DURDUR
function servis_durdur() {
    hizmet_adi=$1
    if systemctl stop "$hizmet_adi"; then
        echo "BASARILI: $hizmet_adi servisi durduruldu."
    else
        echo "HATA: $hizmet_adi durdurulamadı!"
    fi
}

# Seçilen servisin DURUMUNU göster
function servis_durumu() {
    hizmet_adi=$1
    systemctl status "$hizmet_adi" --no-pager
}

# --- LOG GÖRÜNTÜLEME ---
# journalctl kullanarak son 50 logu getirir
function servis_loglari() {
    hizmet_adi=$1
    journalctl -u "$hizmet_adi" -n 50 --no-pager
}
