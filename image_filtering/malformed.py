# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# This program will try opening the image files downloaded to test if they    #
# are corrupted or not.                                                       #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

from PIL import Image
import sys

def remove():
 image = sys.argv[1]
 try:
   v_image = Image.open(image)
   v_image.verify()
 except:
     print(image)

if __name__ == "__main__":
  remove()
