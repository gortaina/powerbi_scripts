opened_file = open('AppleStore.csv')
from csv import reader
read_file = reader(opened_file)
apps_data = list(read_file)

all_ratings = []

for each_list in apps_data[1:]:
    rating = float(each_list[7])
    all_ratings.append(rating)
    
avg_rating = sum(all_ratings)/len(all_ratings)

for each_moma in moma:
    nationality = each_moma[2]
    nationality = nationality.replace("(","")
    nationality = nationality.replace(")","")
    each_moma[2] = nationality
    gender  = each_moma[5]                           
    gender = gender.replace("(","")
    gender = gender.replace(")","")
    each_moma[5] = gender  

    
for each_moma in moma:
    gender = each_moma[5]
    gender = gender.title()
    if(gender == ""):
        gender = "Gender Unknown/Other"
        
    each_moma[5] = gender
    nationality = each_moma[2]
    nationality = nationality.title()
    if(not nationality):
        nationality = "Nationality Unknown"
    each_moma[2] = nationality    
    
def clean_and_convert(date):
    # check that we don't have an empty string
    if date != "":
        # move the rest of the function inside
        # the if statement
        date = date.replace("(", "")
        date = date.replace(")", "")
        date = int(date)
    return date


for each_mona in moma:
    each_mona[3] = clean_and_convert(each_mona[3])
    each_mona[4] = clean_and_convert(each_mona[4])
    
    
test_data = ["1912", "1929", "1913-1923",
             "(1951)", "1994", "1934",
             "c. 1915", "1995", "c. 1912",
             "(1988)", "2002", "1957-1959",
             "c. 1955.", "c. 1970's", 
             "C. 1990-1999"]

bad_chars = ["(",")","c","C",".","s","'", " "]

def strip_characters(word):
    for bad_char in bad_chars:
        word = word.replace(bad_char,"")
    return word

stripped_test_data = []

for each_data in test_data:
    each_data = strip_characters(each_data)
    stripped_test_data.append(each_data)
    
print(stripped_test_data)    
    
############################################
## Code clean exercise
############################################
# import the reader function from the csv module
from csv import reader

# use the python built-in function open()
opened_file = open('artworks.csv')

# use csv.reader() to parse the data
read_file = reader(opened_file)

# use list() to convert the read file
# into a list of lists format
children = list(read_file)

print(len(children))
moma = children = children[1:]

test_data = ["1912", "1929", "1913-1923",
             "(1951)", "1994", "1934",
             "c. 1915", "1995", "c. 1912",
             "(1988)", "2002", "1957-1959",
             "c. 1955.", "c. 1970's", 
             "C. 1990-1999"]

bad_chars = ["(",")","c","C",".","s","'", " "]

def strip_characters(string):
    for char in bad_chars:
        string = string.replace(char,"")
    return string

stripped_test_data = ['1912', '1929', '1913-1923',
                      '1951', '1994', '1934',
                      '1915', '1995', '1912',
                      '1988', '2002', '1957-1959',
                      '1955', '1970', '1990-1999']


def process_date(word):
    if "-" in word:
        lista = word.split('-')
        yearSum = int(lista[0])+int(lista[1])
        yearAverage = round(yearSum/2)
    else:
        yearAverage = int(word)

    return yearAverage

processed_test_data = []

for each_data in stripped_test_data:
    processed_test_data.append(process_date(each_data))
   
for each_moma in moma:
    dataTemp_1 = each_moma[6]
    dataTemp_2 = strip_characters(dataTemp_1)
    dataTemp_3 = process_date(dataTemp_2)
    each_moma[6] = dataTemp_3
    
    
    
