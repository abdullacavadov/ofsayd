# Ofsayd? — Futbol Bilik Yoxlaması

Mini veb app: təsadüfi ölkə+klub və ya klub+klub göstərilir, sən oyunçu adını yazırsan,
sistem TheSportsDB pulsuz API-si ilə cavabı doğrulayır.

## İşə salmaq

Node.js **18 və ya daha yeni** versiya lazımdır (daxili `fetch` üçün).

```bash
npm install
npm start
```

Sonra brauzerdə aç: **http://localhost:3000**

## Necə işləyir

- `server.js` — Express serveri: statik faylları göstərir, `data/settings.json` və
  `data/score.json` fayllarını oxuyub-yazır, həmçinin TheSportsDB sorğularını
  server üzərindən keçirir (CORS problemi olmasın deyə).
- `data/settings.json` — hansı ölkələrin klublarının və hansı ölkə yığmalarının
  randomda çıxacağı. Tənzimləmələr ekranından dəyişdirilir, brauzer keşi
  təmizlənsə belə saxlanılır, çünki serverdəki fayldadır.
- `data/score.json` — ümumi xal, düzgün/səhv sayı. Eyni səbəbdən serverdə saxlanılır.
- `public/app.js` — bütün oyun məntiqi: sual qurulması, 10 saniyəlik taymer,
  ad normalizasiyası (diakritiklərin təmizlənməsi + kiçik yazı səhvlərinə tolerantlıq)
  və TheSportsDB-dən gələn məlumatla cavabın doğrulanması.

## Cavab necə yoxlanılır

1. Sən yazdığın adla `searchplayers.php` sorğusu göndərilir.
2. Tapılan oyunçunun **millətinə** (`strNationality`) və **cari/keçmiş klublarına**
   (`strTeam` + `lookupformerteams.php`) baxılır.
3. Ölkə-klub rejimində: millət uyğun gəlməli VƏ klub siyahısında olmalıdır.
   Klub-klub rejimində: hər iki klub oyunçunun keçmiş/cari komandaları arasında olmalıdır.

Ad müqayisəsi diakritikləri normallaşdırır (Ø→O, ç→c və s.) və kiçik yazı
fərqlərinə (1-2 hərf) tolerantlıdır — "Odegaard" da "Ødegaard" kimi qəbul olunur.

## Məhdudiyyətlər (pulsuz API-nin təbiəti)

- TheSportsDB-nin pulsuz təbəqəsi bəzi endpoint-lərdə nəticə sayını məhdudlaşdırır
  (məs. keçmiş klublar siyahısı üçün ilk 5 nəticə). Çox məşhur olmayan oyunçularda
  və ya kiçik liqalarda data natamam ola bilər.
- Bəzi klublar/liqalar üçün komanda siyahısı boş qayıda bilər — belə halda app
  avtomatik başqa ölkə/klub seçməyə cəhd edir.
- Əgər oyunçu tapılmırsa və ya klub/millət uyğunluğu görünmürsə, bu bəzən datanın
  natamamlığından ola bilər, sənin cavabının səhv olmasından yox.
