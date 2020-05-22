# Dowload-Airtable
Scripts to automatically login to Airtable and download tables from a specified base to your local computer

# RoadMap

AirtableMaster.R -- This master file runs all other files in the correct order. Once you have correctly set your base directory and entered all your Airtable API credentials, you can complete the download by simply running this file.

AirtableLogin+Dowload.R -- This file calls other methods from static functions to complete the download. You will need to tell this script what base you want to dowload, where to dowload it to, and also feed it your API credentials.

LoadPackages.R -- List of packages you will need.

Airtable Credentials.R -- This is where you can pull your API credentials from as envirnoment variables. 

Static Functions -- This folder is where most of the heavy lifting is done. You wont have to touch anything in here, but if your curious about how some of the functions defined in here work, feel free to send an email to matthewalexobrien@gmail.com.


