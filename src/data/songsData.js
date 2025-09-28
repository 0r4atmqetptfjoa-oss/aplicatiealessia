// songsData.js
//
// This module defines two arrays: one for traditional play songs (cântece de
// joacă) and one for Christmas carols (colinde).  All entries are
// public‑domain folk songs; where available, the origin of the song is
// identified as anonymous or "Folclor".  These lists will drive the audio
// player in the final application.

export const playSongs = [
  {
    id: 'un-elefant-se-legana',
    title: 'Un elefant se legăna',
    origin: 'Anonim (folclor)',
    description: 'Copiii numără câţi elefanţi se legănă pe o pânză de păianjen; versurile continuă pe măsură ce numărul creşte.'
  },
  {
    id: 'alunelu-alunelu',
    title: 'Alunelu, alunelu',
    origin: 'Anonim (folclor)',
    description: 'Cântec de dans pentru copii în care cercul de prieteni se roteşte şi bate din palme.'
  },
  {
    id: 'podul-de-piatra',
    title: 'Podul de piatră',
    origin: 'Anonim (folclor)',
    description: 'Un cântec-joc despre un pod care se dărâmă şi este reconstruit, acompaniat de mişcări de joacă în perechi.'
  },
  {
    id: 'catelus-cu-parul-cret',
    title: 'Cățeluș cu părul creț',
    origin: 'Anonim (folclor)',
    description: 'Cântec hazliu despre un cățeluș năstruşnic care fură raţa din coteţ şi se jură că nu a făcut-o.'
  },
  {
    id: 'melc-melc-codobelc',
    title: 'Melc, melc codobelc',
    origin: 'Anonim (folclor)',
    description: 'Cântec scurt de chemare a melcului din cochilie, cântat de copii când găsesc melci în grădină.'
  },
  {
    id: 'avion-cu-motor',
    title: 'Avion cu motor',
    origin: 'Anonim (folclor)',
    description: 'Cântec ritmat în care copiii imită zgomotul unui avion şi salută bunicii şi părinţii.'
  },
  {
    id: 'bate-vantul-frunza',
    title: 'Bate vântul frunza-n dungă',
    origin: 'Anonim (folclor)',
    description: 'Cântec de grup în care copiii imită mişcările frunzelor suflate de vânt.'
  },
  {
    id: 'taraful-de-papusi',
    title: 'Ţăranul e pe câmp',
    origin: 'Anonim (folclor)',
    description: 'Cântec-joc în care copiii mimează munca la câmp şi schimbă rolurile într-un cerc de joacă.'
  },
  {
    id: 'in-padurea-cu-alune',
    title: 'În pădurea cu alune',
    origin: 'Anonim (folclor)',
    description: 'Poveste muzicală despre un şoricel care adună provizii de alune în pădure.'
  },
  {
    id: 'm-am-suit-pe-deal',
    title: 'M-am suit pe dealul Clujului',
    origin: 'Anonim (folclor)',
    description: 'Cântec vesel în care copiii numesc plante şi animale în timp ce urcă pe deal.'
  },
  {
    id: 'pisoi-pis-pis',
    title: 'Pisoi, pis-pis-pis',
    origin: 'Anonim (folclor)',
    description: 'Cântec scurt în care copiii cheamă un pisoi şi îl răsfaţă cu lapte şi mângâieri.'
  },
  {
    id: 'cucurigu',
    title: 'Cucurigu, cucurigu',
    origin: 'Anonim (folclor)',
    description: 'Cântec despre cocoşul care anunţă dimineaţa şi trezeşte gospodăria.'
  },
  {
    id: 'oac-oac-diri',
    title: 'Oac, oac, diri-diri-dac',
    origin: 'Anonim (folclor)',
    description: 'Cântec haios despre broscă, în care copiii repetă onomatopee şi râd împreună.'
  },
  {
    id: 'vine-ursul',
    title: 'Vine ursul',
    origin: 'Anonim (folclor)',
    description: 'Cântec-joc în care un copil joacă rolul ursului, iar ceilalţi îl păcălesc să nu le ia mâncarea.'
  },
  {
    id: 'inelus-cercelus',
    title: 'Ineluş–cerceluş',
    origin: 'Anonim (folclor)',
    description: 'Cântec de joc în care copiii ascund un inel în mâini şi ghicesc unde se află.'
  }
];

export const carols = [
  {
    id: 'o-ce-veste-minunata',
    title: 'O, ce veste minunată!',
    origin: 'Colind (folclor)',
    description: 'Colindă veche care vesteşte Naşterea lui Iisus; melodia a fost culeasă din tradiţia românească de Dumitru Kiriac‑Georgescu.'
  },
  {
    id: 'astazi-s-a-nascut-hristos',
    title: 'Astăzi s‑a născut Hristos',
    origin: 'Colind (folclor)',
    description: 'Colindă tradiţională care povesteşte naşterea Mântuitorului şi aduce urări de bine.'
  },
  {
    id: 'colindam-colindam-iarna',
    title: 'Colindăm, colindăm iarna',
    origin: 'Colind (folclor)',
    description: 'Colindă veselă cântată de copii în ajunul Crăciunului, cu urări de sănătate şi belşug.'
  },
  {
    id: 'florile-dalbe',
    title: 'Florile dalbe',
    origin: 'Colind (folclor)',
    description: 'Colindă delicată care face aluzie la florile dalbe, simbol al purităţii şi al iernii.'
  },
  {
    id: 'trei-pastori',
    title: 'Trei păstori se întâlniră',
    origin: 'Colind (folclor)',
    description: 'Colindă narativă despre păstorii care primesc vestea Naşterii Domnului de la îngeri.'
  },
  {
    id: 'steaua-sus-rasare',
    title: 'Steaua sus răsare',
    origin: 'Colind (folclor)',
    description: 'Colindă care descrie steaua care i‑a călăuzit pe magi spre Bethleem.'
  },
  {
    id: 'iata-vin-colindatori',
    title: 'Iată, vin colindători',
    origin: 'Colind (folclor)',
    description: 'Colindă optimistă care anunţă sosirea colindătorilor şi a bucuriei sărbătorilor.'
  },
  {
    id: 'domn-domn-sa-naltam',
    title: 'Domn, Domn să‑nălţăm',
    origin: 'Colind (folclor)',
    description: 'Colindă veche în care colindătorii îl slăvesc pe Dumnezeu şi urează gazdelor belşug.'
  },
  {
    id: 'buna-dimineata-la-mos-ajun',
    title: 'Bună dimineaţa la Moş Ajun',
    origin: 'Colind (folclor)',
    description: 'Colindă scurtă cântată în Ajunul Crăciunului pentru a ura bună dimineaţa gazdelor.'
  },
  {
    id: 'deschide-usa-crestine',
    title: 'Deschide uşa, creştine',
    origin: 'Colind (folclor)',
    description: 'Colindă emoţionantă care invită gazda să deschidă uşa colindătorilor şi inimile către vestea cea bună.'
  }
];