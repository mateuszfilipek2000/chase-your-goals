import json
import sqlite3

#inserting into languages
#INSERT INTO Languages (code, name, name_native, date_format, currency) VALUES ("pl_PL", "Polish", "Polski", "DD-MM-YYYY", "PLN")

#inserting into translations
#INSERT INTO Translations (language_code_index, name, message) VALUES ( (SELECT id FROM Languages WHERE Languages.code="pl_PL") ,"Hello","Cześć")

#selecting message 
#SELECT Translations.message FROM Translations INNER JOIN Languages ON Translations.language_code_index = Languages.id WHERE Translations.name = "Hello" AND Languages.code = "pl_PL"

con = sqlite3.connect("/assets/internationalization_database.db")

baseInternationalizationFilePath = "/assets/i18n/"

enFile = open(baseInternationalizationFilePath + "en_US.json")
plFile = open(baseInternationalizationFilePath + "pl_PL.json")