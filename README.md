# Coffre_fort
Ce qui me frappe, c'est que les coffres forts actuels n'empêchent pas la suppression (car en général, utilisés dans des clés USB). Je vais donc créer une appli simple pour y remédier.

Ce que je vais faire:
* un dossier rennommé avec des clsid système, un attrib caché, système et lecture seule et un accès refusé à tous
* un autre dossier qui chiffre les données
Le dossier serait protégé par un kernel de surveillance
## 🧪 Arborescence du coffre

| Emplacement         | Description                                  |
|---------------------------|----------------------------------------------|
| `#/A           `          | Attribut clsid de la corbeille + `attrib +s +h +o +r /s /l /d` + gestion de icacls en mode tout refuser |
| `#A/B`           | Attrubut clsid spécial --> GOD.mode + dossier chiffré avec cipher |
| `#A/B/C.crypt`             | Zip chiffré via 2 méthodes |
| `#KEY`               | Hash de plusieurs infos servant à l'authentification             |

---
