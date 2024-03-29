Program: get_data.sh

Author: Matias Lin <<matiasenoclin@gmail.com>>

Date: 08/12/2019
********************************************************************************

Program Description:
--------------------
This program allows the user to build their own dataset of images extracted from
Google Images. Expect the data to be as good as Google Images can be. This
program is meant just for prototypes or other cases where large amounts of data
is more important than the quality of images.

Installation:
-------------
To clone this repository, use the following command:

        '$ git clone https://github.com/matiaslin/get_data.git'

Note: The 'chromedriver.exe' should be according to the user's system.

Usage:
------
1) To execute the program cd into the directory with the 'get_data.sh' file and 
enter either of the following commands:
 ```
 $ ./get_data.sh or $ bash get_data.sh
 ```

2) This will prompt the following message:

  >######################################################################################
  >
  > Welcome!
  > This program will allow you to create your own dataset extracted from Google images.
  > USAGE: Just help us out with the following information and we'll do the rest.
  > RECOMMENDATIONS: Look up the query beforehand in Google Images.
  > NOTE: Expect the quality of the images to be as good as a Google Images search.
  >
  >######################################################################################

3) The program will ask you to specify the following information:
  - The search query.
  - The format of the images.
  - If you want to include related images.
  - The limit of images per category.
  - (if the user decided to include related images) Max number of related 
  categories.

4) The program will now ask for confirmation before initializing the download.
After reviewing the summary, if the user decides to continue then type "y",
otherwise, enter "n".

5) Now the program will undergo a series of automated processes which might take
a few minutes depending of how many images the user specified. Once finished,
the program will output the PATH to the folder where the dataset is found. 

The name of your dataset will have the following pattern: "*FORMAT*_*QUERY*".
Inside the folder you will find:
  - A download log.
  - Folders categorized accordingly with their search queries.
  - A folder named "total" containing all the images for easy manipulation.
  - A .tar file containing all the images.

Note:
-----
The user can run several instances of this script at the same time.
Please execute this program in the directory where the script is.

Copyrights and License:
-----------------------
In order to download the Google Images, this script is using the following
python program "google-images-download". You can find the license to it
in mining/google-images-download/Licence.txt.
(Repo available here: https://github.com/hardikvasa/google-images-download)

This script is licensed under the [MIT License](LICENSE).

Additional Information:
-----------------------
Consider using the "partition.sh" script to manage your recently created dataset.
It will allow you to sort your dataset into training and validation folders.
(Repo available here: https://github.com/matiaslin/partition)
