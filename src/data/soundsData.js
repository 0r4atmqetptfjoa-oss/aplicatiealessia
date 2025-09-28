// soundsData.js
//
// This module exports a dictionary of sound categories used by the sound
// discovery mini‑game in "Lumea Alesiei".  Each category maps to an array of
// 12 descriptive labels representing audio clips that will be added later.
// The labels are purely nominal for now; actual audio files will be
// associated during asset integration.

const sounds = {
  farm: [
    'Muguritul vacii (muget de vacă)',
    'Nechezatul calului',
    'Grohăitul porcului',
    'Cocorâitul cocoşului',
    'Cotcodăcitul găinii',
    'Behăitul oilor',
    'Bêlâitul caprei',
    'Macănitul raţei',
    'Orăcănitul curcanului',
    'Răgetul măgarului',
    'Lătrat de câine ciobănesc',
    'Mârtâitul iepurelui'
  ],
  wild: [
    'Răget de urs',
    'Urlet de lup',
    'Lătrat de vulpe',
    'Cântat de cuc',
    'Cârtâit de veveriţă',
    'Sforăit de mistreţ',
    'Glas de cerb',
    'Ţipăt de uliu',
    'Huhuit de bufniţă',
    'Croăit de broască',
    'Zumzet de albină',
    'Ciocănit de ciocănitoare'
  ],
  sea: [
    'Clichet de delfin',
    'Cântec de balenă',
    'Bâlbâit de focă',
    'Ţipăt de pescăruş',
    'Ţipăt de pelican',
    'Clămpănit de crab',
    'Clipocit de peşti',
    'Susur de meduză',
    'Şuierat de rechin',
    'Ronţăit de ţestoasă',
    'Clămpănit de pelican',
    'Sforăit de morsă'
  ],
  vehicles: [
    'Motor de maşină',
    'Vâjâit de avion',
    'Vâjâit de elicopter',
    'Fluierat de tren',
    'Horn de barcă',
    'Claxon de autobuz',
    'Roţi de camion',
    'Bicicletă cu sonerie',
    'Sirena ambulanţei',
    'Sirena pompierilor',
    'Accelerare de motocicletă',
    'Sunet de tramvai'
  ],
  house: [
    'Sonerie de uşă',
    'Aspirator',
    'Maşină de spălat',
    'Microunde',
    'Ceas tic-tac',
    'Curgere de apă',
    'Pisică torcând',
    'Câine lătrând',
    'Fierbător de apă',
    'Telefon sunând',
    'Taste de tastatură',
    'Paşi pe podea'
  ],
  nature: [
    'Ploaie căzând',
    'Tunet în depărtare',
    'Vânt printre copaci',
    'Cântat de păsări',
    'Curgerea unui râu',
    'Foşnet de frunze',
    'Pocnit de foc de tabără',
    'Valuri la mal',
    'Ţârâit de greieri',
    'Orăcăit de broaşte',
    'Paşi pe zăpadă',
    'Vuiet de cascadă'
  ],
  ambient: [
    'Ambianţă de pădure',
    'Ambianţă de plajă',
    'Ambianţă urbană',
    'Ecou de peşteră',
    'Ambianţă spaţială',
    'Ambianţă de junglă',
    'Ambianţă subacvatică',
    'Vânt de deşert',
    'Ambianţă de câmpie',
    'Ambianţă de fermă',
    'Ambianţă de noapte',
    'Ambianţă tropicală'
  ]
};

export default sounds;