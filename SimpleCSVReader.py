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
