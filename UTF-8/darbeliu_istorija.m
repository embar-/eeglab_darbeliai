%
% Pakeitimai:
% ------------------------
% v2015.04.15.1
% + Galios spektro vaizdavimas.
%
% v2015.03.29.1
% + Atverti sukurtus tekstinius failus.
%
% v2015.03.14.1
% + Automatinis dažnių srities intervalo nustatymas skaičiuojant visą spektrinę galią.
%
% v2015.02.25.1
% + „Nuoseklus apdorojimas“ nenulūš užvėrus kanalų pasirinkimo interpoliavimui dialogą.
%
% v2015.02.24.1
% + Eksportuojant į Ragu, EEGLAB duomenų rinkinio kanalai gali būti ne iš eilės 
%   (tvarka suvienodinama eksportuojant pagal pirmąjį).
%
% v2015.02.14.1
% + Galima rinktis savus kanalus atskaitos sistemai.
% + Galima nurodyti fiksuotą ICA komponenčių kiekį.
%
% v2015.01.28.1
% + ERP savybių peržiūroje failų grupavimas.
%
% v2015.02.01.1
% + Veikia failų vidurkinimas ERP savybių peržiūroje ir eksportavime.
%
% v2015.01.13.1
% ~ Kanalų pasirinkimas galėjo neveikti, jei nebuvo įdiegtas SIFT priedas, 
%   nes buvo naudojama šio priedo statusbar funkcija; dabar ši funkcija pasiskolinta.
% 
% v2014.12.31.1
% + EEG speaktrinės galios skaičiavimuose galima pasirinkti, ar leisti kanalų interpoliavimą.
% + EEG speaktrinės galios skaičiavimų grafiniame lange tikrinti parametrų reikšmes.
% 
% v2014.12.08.1
% + Pradinė grafinė sąsaja EEG spektrinės galios skaičiavimui.
%
% v2014.11.20.1 
% ~ Ištaisyta SĮSP (ERP) savybių rodymo klaida, dėl kurios neveikė
%   vidurkinimas per failus.
% + Nauja programėlė pop_rankinis.m: patys galite įrašyti komandas,
%   kurios bus atliekamos įkėlus pasirinktus duomenis.
% + Dauguma funkcijų palaiko raidinius įvykius, kanalų pavadinimus su
%   tarpais ir turi išskleidžiamus meniu aplankui pasirinkti.
%   
% v2014.11.19.1 
% + Nuosekliame apdorojime galima pasirinkti apdorotinus kanalus kai kurioms
%   funkcijoms: tinklo triukšmo filtravimui, laiko atkarpų atmetimui pagal 
%   amplitudės slenkstį ir spektrą, automatiniam kanalų atmetimui pagal spektrą, ICA.
% + atmest_pg_amplit.m gali atsižvelgti ir tik į pasirinktus kanalus, nebūtinai visus.
% + RRI_perziura importuoja BIOPAC ACQ.
%
% v2014.11.18.1
% ~ ištaisyta v2014.11.11.1 klaida, dėl kurios ta versija kartais galėjo 
%   nepasileisti, jei nebuvo interneto ryšio.
% + Nauji papildinio poaplankiai:
%   GUIDE grafiniai objektai perkelti į „fig“;
%   kitų žmonių sukurtos programos perkeltos į „external“.
% + RRI_perziura.m importuoja LabChart įvykius, kurių pavadinimai prasideda
%   raidėmis ECG arba HRV.
% + RRI_perziura.m importuoja paprastame tekstiniame faile surašytus RRI.
% ~ LabchartEventToEEGLAB pervadinta į labchartEKGevent2eeglab. Joje atsižvelgiama,
%   kad visi įvykiai būtų iš to paties bloko.
%
% v2014.11.11.1
% + Nuošiol ir Windows sistemoje veiks filter_filenames.m viršaplankiuose
%   ir poaplankiuose, tad Windows naudotojai irgi gali vienu metu apdoroti
%   skirtinguose aplankuose esančius failus per „nuoseklų apdorojimą“,
%   „EEG+EKG“, „epochavimą pg. stim. ir ats.“, „SĮSP savybes, eksportą“
%   (pvz., nurodyto ir vienu lygiu žemiau esančių poaplankių apdorojimui 
%   tam reikia ties „Rodyti“ įrašyti „*.set;.\*\*.set“).
% + „Nuosekliame apdorojime“ šalia aplankų pasirinkimo nuspaudus „v“
%   galima rasti anksčiau pasirinktus aplankus, viršaplankius ir poaplankius.
% + RRI_perziura.m gali importuoti EKG iš rinkmenų, gautų eksportuojant 
%   duomenis iš LabChart  į *.MAT. Reikia pasrinkti kalaną (jei jų keli).
%   Šioje RRI_perziura.m versijoje įvykiai neimportuojami.
% + RRI_perziura.m leidžia iš naujo EKG įraše aptikti QRS pagal bet kurį
%   QRS_detekt.m palaikomą algoritmą (šiuo metu – vieną iš 4 algoritmų, 
%   t.y. išskyrus QRS_detekt_fMRIb.m).
% ~ Atnaujintas QRS aptikimo Pan-Tompkin algoritmas, kurį realizavo Sedghamiz.
% ~ Keli smulkūs kosmetiniai pakeitimai.
%
% v2014.11.06.1
% + Jei aptinkamos kelios darbelių versijos – kitas versijas
%   perkels į EEGLAB deactivatedplugins aplanką.
% + Jei Ragu.m nerandama aktyviuose MATLAB keliuose, tuomet 
%   dar papildomai patikrinamas EEGLAB priedų aplankas.
%
% v2014.11.05.1
% ~ Dabar iš tiesų veiks parinktis „pabaigus užverti langą“.
% + Nuosekliame apdorojime leisti pasirinkti kanalus, kurių pavadinime yra tarpas.
% + Nuosekliame apdorojime leisti pasirinkti raidinius įvykius.
%
% v2014.10.28.1
% + RRI/QRS peržiūros lange galima vienu metu peržiūrėti ir RRI, ir EKG,
%   jei pastarasis pasirenkamas iš tarp EEG kanalų esančių.
%
% v2014.10.27.1
% + RRI peržiūros langas (QRS aptikimo tikrinimui).
%
% v2014.10.26.1
% + Pirmasis grafinės sąsajos variantas QRS įterpimui į EEG.
% ~ Nepaisoma filtrų failų sąraše esant tik vienam vienam failui,
%   nes MATLAB neleidžia nepasirinkti vienintelio elemento sąraše. 
% + Nesaugoti tuščių failų (kartais šitai pasitaikydavo).
% + Rodoma eigos juosta įkeliant kanalų ar įvykių sąrašą, jei įkėlimas 
%   užtrunka ilgiau nei sekundę; šį įkėlimą galima pertraukti. 
% + Nuosekliame apdorojime leisti rinktis ir nesančius kanalus –
%   tai gali praversti importuojant, kai nėra galimybės greitai peržiūrėti 
%   iš anksto kanalų.
%
% v2014.10.24.2
% ~ eksportuoti_ragu_programai.m tvarkingiau perima ALLEEG/EEG duomenų 
%   struktūrą, jei ji pateikiama besikreippiant į pačią funkciją.
% ~ Įspėjimas nuosekliame apdorojime epochavimui laiko intervalą 
%   parinkus netelpantį į jau epocuotų duomenų intervalą.
%
% v2014.10.22.1
% ~ Nuoseklus apdorojimas: ištaisyta klaida, kai filtravimo veiksenai 
%   naudotas ne tas kintamasis.
%
% v2014.10.19.1
% ~ Užblokuoti „Vykdyti“ mygtuką pradėjus darbus.
% ~ Įgalinti slinktį rinkmenų sąraše taip pat ir jų apdorojimo metu.
% - Pašalintas meniu punktas eksportavimui į Ragu. Tam naudokite SĮSP (ERP) 
%   savybių programėlę.
% + SĮSP savybės: galima įkelti failus po jų apdorojimo.
% + SĮSP savybės: failų vidurkio peržiūra (eksportavimas nepalaikomas).
% + Nuoseklus apdorojimas: laiko atkarpų atmetimas pagal slekstį mikrovoltais; 
%   tinka akių judesių atmetimui.
%
% v2014.10.12.2
% + Išbaigta pop_ERP_savybes funkcija. 
%   Ji taip pat leidžia ERP eksportuoti ERP į Ragu, txt, Excel.
%
% v2014.10.09.1
% ~ Eksportavimui į Ragu buvo remiamasi EEG.filename įrašu,
%   bet kai kuriuose duomenyse jis tuščias. Tad jei taip nutinka,
%   pavadinimas dabar kuriamas pagal EEG.setname. Jei ir jis tuščias - 
%   imamas eilinis numeris.
% + Nauja prorgamėlė pop_ERP_savybes ERP savybėms peržiūrėti 
%   (versija neužbaigta).
%
% v2014.09.29.2
% + Nuosekliame apdorojime: galimybė pasirinkti būtent tuos
%   kanalus ir įvykius, kurie yra pasirinktuose failuose.
% + Nuosekliame apdorojime: schemos pasirinkimas nustatant kanalų padėtis.
% + „Nuosekliame apdorojime“ ir „Epochavime pg stim ir ats“: 
%   galima įkelti failus iš skirtingų poaplankių. Tam į failų
%   rodymo filtrą rašykite „.\*\*.set;*.cnt“ (Windows sistemai)
%   arba „./*/*.set;*.cnt“ (Unix: Linux, MAC sistemoms) be kabučių.
%
% v2014.09.28.5
% + Epochavimas pg stim ir ats: galimybė pasirinkti būtent tuos
%   įvykius, kurie yra pasirinktuose failuose.
%
% v2014.09.28.1
% + pervadinimas.m: tikrinimas, ar failas jau yra.
% + pervadinimas.m: parinktis ar leisti perrašyti failus.
% + pervadinimas.m ir nuoseklus_darbas.m: nuo šiol
%   nepriklausomos nuo MATLAB darbinio kelio pasikeitimų.
%
% v2014.09.27.1
% ~ Darbelių meniu aktyvus ir tuomet kai įkelta daug įrašų (STUDY).
% + Pervadinime su info atnaujinimu nauja parinktis: ar 
%   pervadinti/perkelti failus (pašalinti originalius failus),
%   ar juos kopijuoti (palikti originalius failus).
% + Nuoseklus_apdorojimas: du kartus galima pasirinkti filtravimo 
%   tipą: nufiltruoti žemesnius, aukštesnius dažnius arba abu iš karto.
%
% v2014.09.25.1
% + Numatytuoju atveju papildinys bando atsinaujinti pats.
% ~ Kosmetiniai pakeitimai, kad dialogai tilptų mažesniuose ekranuose. 
%
% v2014.09.22.1
% + Lokalizavimo galimybė
% + Papildinio nuostatos atnaujinimų paieškai ir kalbos pasirinkimui
% ~ ištaisyta pop_erp_area.m klaida, dėl kurios funcija
%   veikė tik su vienu EEG duomenų rinkiniu
%
% v2014.08.29.1
% + Pervadinant failus galima panaudoti seną informaciją:
%   tiriamojo kodą, grupę, tyrimo sąlygą ir sesiją.
%
% v2014.08.28.3
% + Pranešimas apie atnaujinimą
%
% v2014.08.27.2
% + ERP vidutinės amplitudės radimas
%
% v2014.08.27.1
% + ERP minimumų ir maksimumų radimas
%
% v2014.08.26.3
% + Funkcijos ERP plotui ir x reikšmei ties puse ploto rasti.
% 
% v2014.08.26.2
% + Eksportavimas į Ragu programą veiks ir kai pažymėta EEGLAB 
%   parinktis „keep at most one dataset in memory“.
% + Po eksportavmo į Ragu, atverti santrauką.
% + Eksportuojant Ragu programai, kanalų padėtis ir informacinį 
%   failą įrašyti į atskirą aplanką.
%
% v2014.08.26.1
% ~ Eksportuojant duomenis Ragu programai ERP, eksporuoti vidurkį
%
% v2014.08.25.1
% ~ Epochavimo pagal stimulus ir atsakus dialogo langas 
%   dabar panašus į nuoseklaus apdorojimo dialogo langą.
%
% v2014.08.22.5
% + Šio papildinio parsiuntimas ir įdiegimas. 
% ~ Veikia epochuotų duomenų epochavimas per „nuoseklus darbas“.
% ~ nieko nepažymėti nuosekliam apdorojimui.
% ~ epochuojant pg. stimulus ir atsakus veikia baseline šalinimas.
%
% v2014.08.21.1
% + RAGU diegimo/atnaujinimo funkcija.
% + Eksportuojat EEG duomenis ragu programai į *.TXT:
%   pagerintas duomenų suderinamumo tikrinimas, kartu 
%   eksportuojamas ir atitinkamas kanalų išdėstymas į MAT.
% + Nuoseklus apdorojimas: galimybė atrinkti įrašus, kuriuose 
%   įrašai būtinai yra su visais nurodytais kanalais.     
%
% v2014.08.19.1 
% + Nauja meniu f-ja: įrašų eksportavimas į *.TXT RAGU programai. 
% ~ Pagerintas veikimas esant skirtingoms koduotėms. 
% ~ Ištaisytas įrašų vienodinimas: anksčiau buvo paliekami per trumpi įrašai.
%
% v2014.08.18.1
% ~ ištaisytas "pervadinimas.m": anksciau nepasileisdavo, jei 
%   darbiniame kataloge nebuvo failų
%
% v2014.07.25.3 
% ~ ištaisytas epochavimas, nebaigtų įrašų pažymėjimas po 
%   darbų (jei prašoma nutraukti anksčiau)
%
% v2014.07.25.2
% ~ epochochavimas pagal stimulus ir atsakus palieka tarpinius failus
%
% v2014.07.25.1
% + pervadinimas su info atnaujinimu
%
% v2014.07.21
% ~ nuoseklus apdorojimas v0.2
function darbeliu_istorija
doc darbeliu_istorija