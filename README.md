## Fitur
- list character ai [x]
- chat dengan character ai [x]
- login character ai to get token [x]
- list kategori character [x]
- list chat history [x]
- chat with open ai ? []

## Instalasi
- silahkan clone repo ini https://github.com/bagusindrayana/web-headless-api dan baca instruksinya
- jalankan server api node js
- edit variabel `base_url` di file `provider/ApiProvider.dart` sesuai dengan url server node js api yang di jalankan (jika di localhost maka gunakan IPv4 Address untuk ganti url localhost - bisa di cek di ipconfig), dan janganlupa untuk parameter `?url=` nya di akhir url
- silahkan jalankan di emulator

## Pemakaian
- jika tidak login maka aplikasi akan menggenerate token sementara dari web beta character ai, token ini terbatas untuk melakukan chat (kurang lebih 5 pesan)
- proses login akan mengganti token sementara dengan token yang di dapat dari web beta character ai

## Batasan
- proses login masih manual karena di lindungi dengan recaptcha (tidak bisa di scrape dengan api node js) (kecuali jika menggunakan service seperti 2captcha atau deathbycaptcha)