# What is a string?
# A string is a sequence of characters.
this_is_a_string <- "This is a string. I can add 9 and 3."
class(this_is_a_string)

this_is_another_string <- 'Put this at the end.'

combined_strings <- paste(this_is_a_string, this_is_another_string)

# What is vector?
# a vector is an ordered collection of values (strings, numeric)
numeric_vector <- c(3, 1, 7, 3)
numeric_vector[1]

character_vector <- c("a", "b", "c")

# Dataframes ####
# create a vector that holds my pets' ages
my_pets_ages <- c(8, 2, 6, 3, 1)

# create a vector that holds my pets' names
my_pets_names <- c("Daisy", "Violet", "Lily", "Iris", "Poppy")

# create a dataframe that holds info about my pets
my_pets <- data.frame(name = my_pets_names,
                      age = my_pets_ages)
my_pets
# run class() function on my_pets
class(my_pets)

# summarized info about my_pets
summary(my_pets)

# number of rows
nrow(my_pets)

# number of columns
ncol(my_pets)

# number of dimensions
dim(my_pets)

# Indexing your dataframe
my_pets

# retrieve value in first row and second column
my_pets[1, 2]

# retrieve value in fifth row and first column
my_pets[5, 1]

# retrieve all values in second row
my_pets[2, ]

# retrieve all ages
my_pets[, 2]
my_pets[, "age"]

# retrieve age of second pet
my_pets[2, "age"]

# retrieve all names
my_pets[, "name"]
my_pets$name

# retrieve second pet's name
my_pets$name[2]

# CHALLENGE
# Multiply the age column in the my_pets dataframe by 4
my_pets$age * 4
my_pets[,2] * 4

# create a new column on our dataframe
my_pets$human_age <- my_pets$age * 4
my_pets
summary(my_pets)

# Descriptive Stats
mean(my_pets$age)
median(my_pets$age)
sum(my_pets$age)/nrow(my_pets)
max(my_pets$age)
min(my_pets$age)
range(my_pets$age)
sd(my_pets$age)

# let's add some missing data to our data frame
my_pets
my_pets$name[6] <- "Sunflower"

new_pet <- c("Sunflower", NA, NA)
class(new_pet)

my_pets <- rbind(my_pets, new_pet)

my_pets$age <- as.numeric(my_pets$age)
my_pets$human_age  <- as.numeric(my_pets$human_age)

# descriptive stats with NA (missing values)
mean(my_pets$age, na.rm = TRUE)
summary(my_pets)
my_pets

# comparisons
my_pets$age > 2

my_pets$older_two <- my_pets$age > 2

my_pets

