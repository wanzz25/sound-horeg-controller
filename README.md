# 🎛️ Sound Horeg Controller

Script executor untuk game **Sound Horeg** di Roblox.  
Auto **Power ON** + **Knob Full** khusus alat milik kamu sendiri.

---

## ✨ Fitur

- ⚡ Power ON otomatis (6 metode universal)
- 🔊 Knob full kanan (rotate fisik + value + attribute)
- 👤 Hanya menyentuh alat **milik sendiri**
- 🛡️ Anti-detect (random delay, semua dibungkus pcall)
- 🪟 GUI bisa digeser (drag)
- ➕ Auto detect alat baru yang di-spawn
- `RightAlt` = sembunyikan / tampilkan GUI

---

## 📁 Struktur File

```
sound-horeg-controller/
├── main.lua       ← Paste ke Delta Executor
├── config.lua     ← Konfigurasi & konstanta
├── gui.lua        ← Tampilan GUI
├── drag.lua       ← Fungsi drag window
├── scanner.lua    ← Deteksi alat & kepemilikan
└── actions.lua    ← Logic Power + Knob
```

---

## 🚀 Cara Pakai

### 1. Setup GitHub
1. Fork / clone repo ini
2. Buka `main.lua`
3. Ganti baris ini:
```lua
local BASE = "https://raw.githubusercontent.com/YOUR_USERNAME/sound-horeg-controller/main/"
```
Contoh:
```lua
local BASE = "https://raw.githubusercontent.com/aroman0502/sound-horeg-controller/main/"
```
4. Commit & push semua file

### 2. Jalankan di Roblox
1. Buka game **Sound Horeg**
2. Spawn alat kamu terlebih dahulu
3. Paste isi `main.lua` ke **Delta Executor**
4. Klik **Execute**
5. Tunggu GUI muncul (±2 detik)

### 3. Pakai GUI
| Tombol | Fungsi |
|--------|--------|
| 🔍 Scan Alat Saya | Temukan semua alatmu |
| ⚡ Power ON | Nyalakan power semua alat |
| 🔊 Knob Full | Putar knob ke kanan penuh |
| ▶ Jalankan Semua | Power ON + Knob Full sekaligus |
| `RightAlt` | Sembunyikan / tampilkan GUI |

---

## ⚙️ Konfigurasi

Edit `config.lua` untuk menyesuaikan:

```lua
scanRadius = 60,      -- Radius deteksi kepemilikan (studs)
audioNames = { ... }, -- Nama alat yang dikenali
```

---

## 📜 Lisensi

MIT License — bebas digunakan, dimodifikasi, dan didistribusikan.

---

## ❗ Disclaimer

Script ini dibuat untuk keperluan pribadi dalam game Sound Horeg.  
Penggunaan sepenuhnya tanggung jawab pengguna.
