### Environment

Running testbed: **NUSHPC**

Container: /app1/common/singularity-img/3.0.0/pytorch_1.5_cuda10.2-ubuntu20.04-py38.simg

Packet Requirment: `./requirment.txt`



### Dataset:

Following the https://github.com/MengyangPu/EDTER to download BSDS500 ,NYUD and pretrained model. 

Download MULTICUE and COCO manually.

### Run the Code

Follow Github to train the model.

Run the `EDTER/img_crop.py` first to crop the image for testing. Change the Path inside 

When test the model, 

1. please change the file path in `EDTER/config/_base_/datasets/bsds.py` and `EDTER/config/_base_/datasets/bsds_multi_scale.py`
2. Replace the `test.txt` in `/EDTER/data/BSDS/ImageSets` use your own test dataset path



