# This is intro to R
# Basic operations ####
3 + 3 # sum
3 - 2 # subtraction
7 / 2 # division
3 * 3 # multiplication
3**2 # exponent
3^2 # exponent
7 %% 2 # mod, same as remainder
7 %/% 2# integer division, it returns the whole

# Logic Operators
3 == 2 # equal comparison
3 == 3 # equal
3 < 5 # less than
3 < 3 # less than
3 <= 3 # less or equal
3 > 5 # greater than
3 >= 5 # greater or equal
3 != 5 # different

# Variables and Objects ####
a = 2 # assign number 2 to variable "a"
b <- 3 # assign number 3 to variable "b"
4 -> c # assign number 4 to variable "c"
e <- 5

# Operation
a * b

# If you have multiple lines of comments you shouldn't keep writing, 
# you shouldn't go past the 80 character

# Functions
class(a) # get the class type of a
class(b)

# Use quotation marks for strings
f <- "4" # assign string "4" to f
class(f) # check class type of f

# Create an object called daisys_age that holds the number 8. 
# Multiply daisys_age by 4 and save the results in another 
# object called daisys_human_age
daisys_age <- 9
daisys_human_age <- (daisys_age * 4)
daisys_human_age

# Creating Vectors #####
# python example: my_pets_ages = [8, 2, 6, 3, 1]
my_pets_ages <- c(8, 2, 6, 3, 1)
my_pets_ages * 4
class(my_pets_ages)

my_pets_ages_2 <- c(8, 2, 6, "3", 1)
my_pets_ages_2 * 4
class(my_pets_ages_2)

my_pets_ages_3 <- list(8, 2, 6, "3", 1)

# Indexing a vector
length(my_pets_ages)
my_pets_ages[1]
my_pets_ages[3]

# Indexing a list
my_pets_ages_3[2]

