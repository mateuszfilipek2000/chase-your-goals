import json
import sqlite3
import argparse

#DOESNT WORK YET

supportedLocales = [
    "pl",
    "en"
]

con = sqlite3.connect("assets/databases/internationalization_database.db")

baseInternationalizationFilePath = "lib/core/config/l10n/"

con.close()

def addNewMessage(locale, title ,message, description=None):

    if locale in supportedLocales:
        # fileLength = 0
        # f = open(baseInternationalizationFilePath + "app_"+locale+".arb", "r")
        # for line in f :
        #     fileLength += 1
        # f.close()

        with open(baseInternationalizationFilePath + "app_"+locale+".arb", 'r+') as f:
            content = f.read().split("\n")
            f.seek(len(content) - 1)
            print(content)
            del content[0 : len(content) - 1]
            print(content)

            # f.write('"' + title + '": ' + '"' + message + '\n')
            # if description != None:
            #     f.write('"@' + title + '": {\n' + '"description: "' +'"' + description + '"\n}' + content)
            # else:
            #     f.write(content)

    else:
        print("locale's not existing")



parser = argparse.ArgumentParser(
    description="Basic db helper to help me with internationalization"
)

parser.add_argument('-nM', "--new_message", type=str, nargs='*', help="adds new message, you will be prompted to insert translated message in every available language\n first argument: language code, second argument: title, third argument is optional")
parser.add_argument('-l', "--languages", help="lists all added languages")
parser.add_argument("-nL", "--new_language", type=str, help="NOT WORKING adds new language to db, you will be prompted to insert translation for every message")
parser.add_argument("-m", "--messages", help="lists all added messages")

args = parser.parse_args()

if (args.new_message):
    #createNewScreen(args.new_page)
    if (len(args.new_message) == 4):
        print("adding new message winkey smiley face")
        print(args.new_message)
        addNewMessage(args.new_message[0], args.new_message[1], args.new_message[2], args.new_message[3])
        
    else:
        print("No, Kitty! That's a bad Kitty!")

#inserting into languages
#INSERT INTO Languages (code, name, name_native, date_format, currency) VALUES ("pl_PL", "Polish", "Polski", "DD-MM-YYYY", "PLN")

#inserting into translations
#INSERT INTO Translations (language_code_index, name, message) VALUES ( (SELECT id FROM Languages WHERE Languages.code="pl_PL") ,"Hello","Cześć")

#selecting message 
#SELECT Translations.message FROM Translations INNER JOIN Languages ON Translations.language_code_index = Languages.id WHERE Translations.name = "Hello" AND Languages.code = "pl_PL"

#selecting all added messages
#SELECT DISTINCT Translations.name from Translations



con = sqlite3.connect("assets/databases/internationalization_database.db")

baseInternationalizationFilePath = "lib/core/config/l10n/"

con.close()
# enFile = open(baseInternationalizationFilePath + "app_en.arb", "a")
# plFile = open(baseInternationalizationFilePath + "app_pl.arb", "a")

# enFile.close()
# plFile.close()
