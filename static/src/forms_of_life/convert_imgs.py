import os, sys
import numpy as np
import cv2

GREEN = [ 27.0, 181.0, 50.0, 255 ]

def keep_max_cc(img):
    mask = img
    _, labels_im, stats, _ = cv2.connectedComponentsWithStats(mask, connectivity=4)
    max_area = np.argmax(stats[1:, -1]) + 1
    return (labels_im == max_area).astype('uint8')*255

indir = sys.argv[1]
for root, dirs, filenames in os.walk(indir):
    for f in filenames:
        if f.endswith('.png') and not f.startswith('+'):
            img = cv2.imread(os.path.join(root, f), 0)
            img = keep_max_cc(img)
            
            img[0, :] = 0
            img[-1, :] = 0
            img[:, 0] = 0
            img[:, -1] = 0

            img = 255 - img
            imga = cv2.cvtColor(img, cv2.COLOR_GRAY2RGBA)
            imga[:, :, -1] = 255
            
            # white becomes transparant
            white = imga[:, :, 0] == 255
            imga[white, -1] = 0

            imga[imga[:,:,0] == 0] = GREEN

            # print((imga[1:-1,1:-1,-1] == 0).sum())
            # imga[1:-1, 1:-1][imga[1:-1,1:-1,-1] == 0] = 255

            cv2.imwrite(os.path.join(root, '+'+f), imga)
