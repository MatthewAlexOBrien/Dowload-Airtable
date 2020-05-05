

##################################################################################
############################ Load Static Functions ###############################
##################################################################################

source(paste(Base, "/Static Functions/airtable_schema.R", sep = ""))
source(paste(Base, "/Static Functions/airtable.R", sep = ""))

##################################################################################
#################### Set Global Environment Variables  ###########################
##################################################################################

# AIRTABLE_API_KEY, AIRTABLE_LOGIN_EMAIL, AIRTABLE_LOGIN_PWD are secret

source(paste(Base, "/airtable_credentials.R", sep = ""))
DATA_PATH = paste(Base, "/Data", sep = "") # Where to locally to store dowloaded data
AT_BASE = "yourbaseid" # The base we are working off of
AIRTABLE_API_KEY = Sys.getenv("AIRTABLE_API_KEY")
AIRTABLE_LOGIN_EMAIL = Sys.getenv("AIRTABLE_LOGIN_EMAIL")
AIRTABLE_LOGIN_PWD = Sys.getenv("AIRTABLE_LOGIN_PWD")


##################################################################################
############################# Download Tables  ####################################
##################################################################################

# Puts tables into the the DATA_PATH folder as csv's
# calls get_airtable_schema and airtable_names from  airtable_schema.R and also 
# save_airtable from airtable.R

at_schema = get_airtable_schema(AT_BASE, AIRTABLE_LOGIN_EMAIL, AIRTABLE_LOGIN_PWD)
tables <- airtable_names(at_schema)
save_airtable(AT_BASE, tables, path = DATA_PATH)



