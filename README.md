# Darbų valdymas – pirmoji versija

Web programėlės pradinis MVP 5–10 darbuotojų komandai.

## Kas jau paruošta
- Prisijungimas el. paštu ir slaptažodžiu bei darbuotojo registracija.
- Darbuotojų sąrašas ir atskiras kiekvieno darbuotojo darbų filtras.
- Bendras visų darbų sąrašas.
- Darbų kūrimas, priskyrimas darbuotojui, aprašymas ir privalomas terminas.
- Darbo pažymėjimas kaip atlikto ir ištrynimas.
- Vėluojančių darbų žymėjimas.
- Prisitaikantis telefono ir kompiuterio vaizdas.

## Svarbu
Šis ZIP yra programėlės kodas, o ne jau internete veikianti sistema. Kad keli darbuotojai matytų tuos pačius duomenis, reikia prijungti bendrą Supabase duomenų bazę ir paskelbti svetainę internete. Demonstracinis režimas be Supabase naudoja tik pavyzdinius duomenis naršyklės lange.

## Paleidimas
Reikalingas Node.js 20 ar naujesnis.

1. Sukurkite nemokamą projektą https://supabase.com/.
2. Supabase SQL Editor lange paleiskite failo `supabase/schema.sql` turinį.
3. Supabase Authentication > Providers įjunkite Email. Jei norite paprastesnio vidinio testavimo, galite išjungti email confirmation.
4. Nukopijuokite `.env.example` į `.env` ir įrašykite Supabase Project URL bei anon/publishable key.
5. Terminale projekto kataloge vykdykite:

   ```bash
   npm install
   npm run dev
   ```

6. Paskelbimui naudokite Vercel arba Netlify: įkelkite projekto katalogą, nustatykite aplinkos kintamuosius `VITE_SUPABASE_URL` ir `VITE_SUPABASE_ANON_KEY`, build komanda `npm run build`, katalogas `dist`.

## Darbuotojų pridėjimas
Kiekvienas darbuotojas užsiregistruoja savo el. paštu ir vardu. Po registracijos jo vardas atsiranda darbuotojų sąraše. Prisijungę vartotojai mato bendrus darbus ir gali juos pridėti, pažymėti atliktais arba ištrinti.

## Saugumas
Kliento pusėje naudojamas tik Supabase anon/publishable raktas. Niekada nedėkite `service_role` rakto į `.env` ar naršyklės kodą. Dabartinės taisyklės leidžia visiems prisijungusiems darbuotojams kurti, redaguoti būseną ir trinti darbus – taip, kaip numatyta pirmame variante.
